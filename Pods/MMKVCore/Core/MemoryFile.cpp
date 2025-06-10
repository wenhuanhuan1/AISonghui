/*
 * Tencent is pleased to support the open source community by making
 * MMKV available.
 *
 * Copyright (C) 2018 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "MemoryFile.h"

#ifndef MMKV_WIN32

#    include "InterProcessLock.h"
#    include "MMBuffer.h"
#    include "MMKVLog.h"
#    include "ScopedLock.hpp"
#    include <cerrno>
#    include <utility>
#    include <fcntl.h>
#    include <sys/mman.h>
#    include <sys/stat.h>
#    include <unistd.h>
#    include <sys/file.h>
#    include <dirent.h>
#    include <cstring>
#    include <unistd.h>
#    include <filesystem>

using namespace std;
namespace fs = std::filesystem;

namespace mmkv {

static bool getFileSize(const char *path, size_t &size);

#    ifdef MMKV_ANDROID
extern size_t ASharedMemory_getSize(int fd);
#    else
File::File(MMKVPath_t path, OpenFlag flag) : m_path(std::move(path)), m_fd(-1), m_flag(flag) {
    open();
}

MemoryFile::MemoryFile(MMKVPath_t path, size_t expectedCapacity, bool readOnly, bool mayflyFD)
    : m_diskFile(std::move(path), readOnly ? OpenFlag::ReadOnly : (OpenFlag::ReadWrite | OpenFlag::Create))
    , m_ptr(nullptr), m_size(0), m_readOnly(readOnly), m_isMayflyFD(mayflyFD)
{
    reloadFromFile(expectedCapacity);
}
#    endif // !defined(MMKV_ANDROID)

#    ifdef MMKV_IOS
void tryResetFileProtection(const string &path);
#    endif

static int OpenFlag2NativeFlag(OpenFlag flag) {
    int native = O_CLOEXEC;
    if ((flag & OpenFlagRWMask) == OpenFlag::ReadWrite) {
        native |= O_RDWR;
    } else if (flag & OpenFlag::ReadOnly) {
        native |= O_RDONLY;
    } else if (flag & OpenFlag::WriteOnly) {
        native |= O_WRONLY;
    }

    if (flag & OpenFlag::Create) {
        native |= O_CREAT;
    }
    if (flag & OpenFlag::Excel) {
        native |= O_EXCL;
    }
    if (flag & OpenFlag::Truncate) {
        native |= O_TRUNC;
    }
    return native;
}

bool File::open() {
#    ifdef MMKV_ANDROID
    if (m_fileType == MMFILE_TYPE_ASHMEM) {
        return isFileValid();
    }
#    endif
    if (isFileValid()) {
        return true;
    }
    m_fd = ::open(m_path.c_str(), OpenFlag2NativeFlag(m_flag), S_IRWXU);
    if (!isFileValid()) {
        MMKVError("fail to open [%s], flag 0x%x, %d(%s)", m_path.c_str(), m_flag, errno, strerror(errno));
        return false;
    }
    MMKVInfo("open fd[%d], flag 0x%x, %s", m_fd, m_flag, m_path.c_str());
    return true;
}

void File::close() {
    if (isFileValid()) {
        MMKVInfo("closing fd[%d], %s", m_fd, m_path.c_str());
        if (::close(m_fd) == 0) {
            m_fd = -1;
        } else {
            MMKVError("fail to close [%s], %d(%s)", m_path.c_str(), errno, strerror(errno));
        }
    }
}

size_t File::getActualFileSize() const {
#    ifdef MMKV_ANDROID
    if (m_fileType == MMFILE_TYPE_ASHMEM) {
        return ASharedMemory_getSize(m_fd);
    }
#    endif
    size_t size = 0;
    if (isFileValid()) {
        mmkv::getFileSize(m_fd, size);
    } else {
        mmkv::getFileSize(m_path.c_str(), size);
    }
    return size;
}

bool MemoryFile::openIfNeeded() {
    if (!m_diskFile.isFileValid()) {
        return m_diskFile.open();
    }
    return true;
}

void MemoryFile::cleanMayflyFD() {
    if (m_isMayflyFD && m_diskFile.isFileValid()) {
        m_diskFile.close();
    }
}

size_t MemoryFile::getActualFileSize() {
    if (!m_isMayflyFD && !m_diskFile.isFileValid()) {
        return 0;
    }

    return m_diskFile.getActualFileSize();
}

MMKVFileHandle_t MemoryFile::getFd() {
    if (m_isMayflyFD) {
        openIfNeeded();
    }
    return m_diskFile.getFd();
}

bool MemoryFile::truncate(size_t size, FileLock *fileLock) {
    if (m_isMayflyFD) {
        openIfNeeded();
    }
    if (!m_diskFile.isFileValid()) {
        return false;
    }
    if (size == m_size) {
        return true;
    }
    if (m_readOnly) {
        // truncate readonly file not allow
        return false;
    }
#    ifdef MMKV_ANDROID
    if (m_diskFile.m_fileType == MMFILE_TYPE_ASHMEM) {
        if (size > m_size) {
            MMKVError("ashmem %s reach size limit:%zu, consider configure with larger size", m_diskFile.m_path.c_str(), m_size);
        } else {
            MMKVInfo("no way to trim ashmem %s from %zu to smaller size %zu", m_diskFile.m_path.c_str(), m_size, size);
        }
        return false;
    }
#    endif // MMKV_ANDROID

    auto oldSize = m_size;
    m_size = size;
    // round up to (n * pagesize)
    if (m_size < DEFAULT_MMAP_SIZE || (m_size % DEFAULT_MMAP_SIZE != 0)) {
        m_size = ((m_size / DEFAULT_MMAP_SIZE) + 1) * DEFAULT_MMAP_SIZE;
    }

    if (::ftruncate(m_diskFile.m_fd, static_cast<off_t>(m_size)) != 0) {
        MMKVError("fail to truncate [%s] to size %zu, %s", m_diskFile.m_path.c_str(), m_size, strerror(errno));
        m_size = oldSize;
        return false;
    }
    if (m_size > oldSize) {
        if (!zeroFillFile(m_diskFile.m_fd, oldSize, m_size - oldSize)) {
            MMKVError("fail to zeroFile [%s] to size %zu, %s", m_diskFile.m_path.c_str(), m_size, strerror(errno));
            m_size = oldSize;

            // redo ftruncate to its previous size
            int status = ::ftruncate(m_diskFile.m_fd, static_cast<off_t>(m_size));
            if (status != 0) {
                MMKVError("failed to truncate back [%s] to size %zu, %s", m_diskFile.m_path.c_str(), m_size, strerror(errno));
            } else {
                MMKVError("success to truncate [%s] back to size %zu", m_diskFile.m_path.c_str(), m_size);
                MMKVError("after truncate, file size = %zu", getActualFileSize());
            }

            return false;
        }
    }

    if (m_ptr) {
        if (munmap(m_ptr, oldSize) != 0) {
            MMKVError("fail to munmap [%s], %s", m_diskFile.m_path.c_str(), strerror(errno));
        }
    }
    return mmapOrCleanup(fileLock);
}

bool MemoryFile::msync(SyncFlag syncFlag) {
    if (m_readOnly) {
        // there's no point in msync() readonly memory
        return true;
    }
    if (m_ptr) {
        auto ret = ::msync(m_ptr, m_size, syncFlag ? MS_SYNC : MS_ASYNC);
        if (ret == 0) {
            return true;
        }
        MMKVError("fail to msync [%s], %s", m_diskFile.m_path.c_str(), strerror(errno));
    }
    return false;
}

bool MemoryFile::mmapOrCleanup(FileLock *fileLock) {
    auto oldPtr = m_ptr;
    auto mode = m_readOnly ? PROT_READ : (PROT_READ | PROT_WRITE);
    m_ptr = (char *) ::mmap(m_ptr, m_size, mode, MAP_SHARED, m_diskFile.m_fd, 0);
    if (m_ptr == MAP_FAILED) {
        MMKVError("fail to mmap [%s], mode 0x%x, %s", m_diskFile.m_path.c_str(), mode, strerror(errno));
        m_ptr = nullptr;

        doCleanMemoryCache(true);
        return false;
    }
    MMKVInfo("mmap to address [%p], oldPtr [%p], [%s]", m_ptr, oldPtr, m_diskFile.m_path.c_str());

    if (m_isMayflyFD && fileLock) {
        fileLock->destroyAndUnLock();
    }

    cleanMayflyFD();
    return true;
}

void MemoryFile::reloadFromFile(size_t expectedCapacity) {
#    ifdef MMKV_ANDROID
    if (m_fileType == MMFILE_TYPE_ASHMEM) {
        return;
    }
#    endif
    if (isFileValid()) {
        MMKVWarning("calling reloadFromFile while the cache [%s] is still valid", m_diskFile.m_path.c_str());
        MMKV_ASSERT(0);
        doCleanMemoryCache(false);
    }

    if (openIfNeeded()) {
        FileLock fileLock(m_diskFile.m_fd);
        InterProcessLock lock(&fileLock, SharedLockType);
        SCOPED_LOCK(&lock);

        mmkv::getFileSize(m_diskFile.m_fd, m_size);
        size_t expectedSize = std::max<size_t>(DEFAULT_MMAP_SIZE, roundUp<size_t>(expectedCapacity, DEFAULT_MMAP_SIZE));
        // round up to (n * pagesize)
        if (!m_readOnly && (m_size < expectedSize || (m_size % DEFAULT_MMAP_SIZE != 0))) {
            InterProcessLock exclusiveLock(&fileLock, ExclusiveLockType);
            SCOPED_LOCK(&exclusiveLock);

            size_t roundSize = ((m_size / DEFAULT_MMAP_SIZE) + 1) * DEFAULT_MMAP_SIZE;;
            roundSize = std::max<size_t>(expectedSize, roundSize);
            truncate(roundSize, &fileLock);
        } else {
            mmapOrCleanup(&fileLock);
        }
#    ifdef MMKV_IOS
        if (!m_readOnly) {
            tryResetFileProtection(m_diskFile.m_path);
        }
#    endif
    }
}

void MemoryFile::doCleanMemoryCache(bool forceClean) {
#    ifdef MMKV_ANDROID
    if (m_diskFile.m_fileType == MMFILE_TYPE_ASHMEM && !forceClean) {
        return;
    }
#    endif
    if (m_ptr && m_ptr != MAP_FAILED) {
        if (munmap(m_ptr, m_size) != 0) {
            MMKVError("fail to munmap [%s], %s", m_diskFile.m_path.c_str(), strerror(errno));
        }
    }
    m_ptr = nullptr;

    m_diskFile.close();
    m_size = 0;
}

bool isFileExist(const string &nsFilePath) {
    if (nsFilePath.empty()) {
        return false;
    }

    return access(nsFilePath.c_str(), F_OK) == 0;
}

#ifndef MMKV_APPLE
extern bool mkPath(const MMKVPath_t &str) {
    char *path = strdup(str.c_str());

    struct stat sb = {};
    bool done = false;
    char *slash = path;

    while (!done) {
        slash += strspn(slash, "/");
        slash += strcspn(slash, "/");

        done = (*slash == '\0');
        *slash = '\0';

        if (stat(path, &sb) != 0) {
            if (errno != ENOENT || mkdir(path, 0777) != 0) {
                MMKVWarning("%s : %s", path, strerror(errno));
                // there's report that some Android devices might not have access permission on parent dir
                if (done) {
                    free(path);
                    return false;
                }
                goto LContinue;
            }
        } else if (!S_ISDIR(sb.st_mode)) {
            MMKVWarning("%s: %s", path, strerror(ENOTDIR));
            free(path);
            return false;
        }
LContinue:
        *slash = '/';
    }
    free(path);

    return true;
}
#else
// avoid using so-called privacy API
extern bool mkPath(const MMKVPath_t &str) {
    auto path = [NSString stringWithUTF8String:str.c_str()];
    NSError *error = nil;
    auto ret = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (!ret) {
        MMKVWarning("%s", error.localizedDescription.UTF8String);
        return false;
    }
    return true;
}
#endif

MMBuffer *readWholeFile(const MMKVPath_t &path) {
    MMBuffer *buffer = nullptr;
    int fd = open(path.c_str(), O_RDONLY | O_CLOEXEC);
    if (fd >= 0) {
        auto fileLength = lseek(fd, 0, SEEK_END);
        if (fileLength > 0) {
            buffer = new MMBuffer(static_cast<size_t>(fileLength));
            lseek(fd, 0, SEEK_SET);
            auto readSize = read(fd, buffer->getPtr(), static_cast<size_t>(fileLength));
            if (readSize != -1) {
                //fileSize = readSize;
            } else {
                MMKVWarning("fail to read %s: %s", path.c_str(), strerror(errno));

                delete buffer;
                buffer = nullptr;
            }
        }
        close(fd);
    } else {
        MMKVWarning("fail to open %s: %s", path.c_str(), strerror(errno));
    }
    return buffer;
}

bool zeroFillFile(int fd, size_t startPos, size_t size) {
    if (fd < 0) {
        return false;
    }

    if (lseek(fd, static_cast<off_t>(startPos), SEEK_SET) < 0) {
        MMKVError("fail to lseek fd[%d], error:%s", fd, strerror(errno));
        return false;
    }

    static const char zeros[4096] = {};
    while (size >= sizeof(zeros)) {
        if (write(fd, zeros, sizeof(zeros)) < 0) {
            MMKVError("fail to write fd[%d], error:%s", fd, strerror(errno));
            return false;
        }
        size -= sizeof(zeros);
    }
    if (size > 0) {
        if (write(fd, zeros, size) < 0) {
            MMKVError("fail to write fd[%d], error:%s", fd, strerror(errno));
            return false;
        }
    }
    return true;
}

#ifndef MMKV_APPLE

bool getFileSize(int fd, size_t &size) {
    struct stat st = {};
    if (fstat(fd, &st) != -1) {
        size = (size_t) st.st_size;
        return true;
    }
    return false;
}

bool getFileSize(const char *path, size_t &size) {
    struct stat st = {};
    if (stat(path, &st) != -1) {
        size = (size_t) st.st_size;
        return true;
    }
    return false;
}

#else // !MMKV_APPLE

// avoid using so-called privacy API
bool getFileSize(int fd, size_t &size) {
    auto cur = lseek(fd, 0, SEEK_CUR);
    if (cur == -1) {
        return false;
    }
    auto end = lseek(fd, 0, SEEK_END);
    if (end == -1) {
        return false;
    }
    size = (size_t) end;

    lseek(fd, cur, SEEK_SET);
    return true;
}

bool getFileSize(const char *path, size_t &size) {
    auto fd = open(path, O_RDONLY);
    if (fd >= 0) {
        auto ret = getFileSize(fd, size);
        close(fd);
        return ret;
    }
    return false;
}

#endif // !MMKV_APPLE

size_t getPageSize() {
    return static_cast<size_t>(getpagesize());
}

extern MMKVPath_t absolutePath(const MMKVPath_t &path) {
    fs::path relative_path(path);
    fs::path absolute_path = fs::absolute(relative_path);
    fs::path normalized = fs::weakly_canonical(absolute_path);
    return normalized.string();
}

#ifndef MMKV_APPLE

static pair<MMKVPath_t, int> createUniqueTempFile(const char *prefix) {
    char path[PATH_MAX];
#ifdef MMKV_ANDROID
    snprintf(path, PATH_MAX, "%s/%s.XXXXXX", g_android_tmpDir.c_str(), prefix);
#else
    snprintf(path, PATH_MAX, "%s/%s.XXXXXX", P_tmpdir, prefix);
#endif

    auto fd = mkstemp(path);
    if (fd < 0) {
        MMKVError("fail to create unique temp file [%s], %d(%s)", path, errno, strerror(errno));
        return {"", fd};
    }
    MMKVDebug("create unique temp file [%s] with fd[%d]", path, fd);
    return {MMKVPath_t(path), fd};
}

#if !defined(MMKV_ANDROID) && !defined(MMKV_LINUX)

bool tryAtomicRename(const MMKVPath_t &srcPath, const MMKVPath_t &dstPath) {
    if (::rename(srcPath.c_str(), dstPath.c_str()) != 0) {
        MMKVError("fail to rename [%s] to [%s], %d(%s)", srcPath.c_str(), dstPath.c_str(), errno, strerror(errno));
        return false;
    }
    return true;
}

bool copyFileContent(const MMKVPath_t &srcPath, MMKVFileHandle_t dstFD, bool needTruncate) {
    if (dstFD < 0) {
        return false;
    }
    bool ret = false;
    File srcFile(srcPath, OpenFlag::ReadOnly);
    if (!srcFile.isFileValid()) {
        return false;
    }
    auto bufferSize = getPageSize();
    auto buffer = (char *) malloc(bufferSize);
    if (!buffer) {
        MMKVError("fail to malloc size %zu, %d(%s)", bufferSize, errno, strerror(errno));
        goto errorOut;
    }
    lseek(dstFD, 0, SEEK_SET);

    // the POSIX standard don't have sendfile()/fcopyfile() equivalent, do it the hard way
    while (true) {
        auto sizeRead = read(srcFile.getFd(), buffer, bufferSize);
        if (sizeRead < 0) {
            MMKVError("fail to read file [%s], %d(%s)", srcPath.c_str(), errno, strerror(errno));
            goto errorOut;
        }

        size_t totalWrite = 0;
        do {
            auto sizeWrite = write(dstFD, buffer + totalWrite, sizeRead - totalWrite);
            if (sizeWrite < 0) {
                MMKVError("fail to write fd [%d], %d(%s)", dstFD, errno, strerror(errno));
                goto errorOut;
            }
            totalWrite += sizeWrite;
        } while (totalWrite < sizeRead);

        if (sizeRead < bufferSize) {
            break;
        }
    }
    if (needTruncate) {
        size_t dstFileSize = 0;
        getFileSize(dstFD, dstFileSize);
        auto srcFileSize = srcFile.getActualFileSize();
        if ((dstFileSize != srcFileSize) && (::ftruncate(dstFD, static_cast<off_t>(srcFileSize)) != 0)) {
            MMKVError("fail to truncate [%d] to size [%zu], %d(%s)", dstFD, srcFileSize, errno, strerror(errno));
            goto errorOut;
        }
    }

    ret = true;
    MMKVInfo("copy content from %s to fd[%d] finish", srcPath.c_str(), dstFD);

errorOut:
    free(buffer);
    return ret;
}

#endif // !defined(MMKV_ANDROID) && !defined(MMKV_LINUX)

// copy to a temp file then rename it
// this is the best we can do under the POSIX standard
bool copyFile(const MMKVPath_t &srcPath, const MMKVPath_t &dstPath) {
    auto pair = createUniqueTempFile("MMKV");
    auto tmpFD = pair.second;
    auto &tmpPath = pair.first;
    if (tmpFD < 0) {
        return false;
    }

    bool renamed = false;
    if (copyFileContent(srcPath, tmpFD, false)) {
        MMKVInfo("copyfile [%s] to [%s]", srcPath.c_str(), tmpPath.c_str());
        renamed = tryAtomicRename(tmpPath, dstPath);
        if (!renamed) {
            MMKVInfo("rename fail, try copy file content instead.");
            if (copyFileContent(tmpPath, dstPath)) {
                renamed = true;
                ::unlink(tmpPath.c_str());
            }
        }
        if (renamed) {
            MMKVInfo("copyfile [%s] to [%s] finish.", srcPath.c_str(), dstPath.c_str());
        }
    }

    ::close(tmpFD);
    if (!renamed) {
        ::unlink(tmpPath.c_str());
    }
    return renamed;
}

bool copyFileContent(const MMKVPath_t &srcPath, const MMKVPath_t &dstPath) {
    File dstFile(dstPath, OpenFlag::WriteOnly | OpenFlag::Create | OpenFlag::Truncate);
    if (!dstFile.isFileValid()) {
        return false;
    }
    auto ret = copyFileContent(srcPath, dstFile.getFd(), false);
    if (!ret) {
        MMKVError("fail to copyfile(): target file %s", dstPath.c_str());
    } else {
        MMKVInfo("copy content from %s to [%s] finish", srcPath.c_str(), dstPath.c_str());
    }
    return ret;
}

bool copyFileContent(const MMKVPath_t &srcPath, MMKVFileHandle_t dstFD) {
    return copyFileContent(srcPath, dstFD, true);
}

#endif // !defined(MMKV_APPLE)

void walkInDir(const MMKVPath_t &dirPath, WalkType type, const function<void(const MMKVPath_t&, WalkType)> &walker) {
    auto folderPathStr = dirPath.data();
    DIR *dir = opendir(folderPathStr);
    if (!dir) {
        MMKVError("opendir failed: %d(%s), %s", errno, strerror(errno), dirPath.c_str());
        return;
    }

    char childPath[PATH_MAX];
    size_t folderPathLength = dirPath.size();
    strncpy(childPath, folderPathStr, folderPathLength + 1);
    if (folderPathStr[folderPathLength - 1] != '/') {
        childPath[folderPathLength] = '/';
        folderPathLength++;
    }

    while (auto child = readdir(dir)) {
        if ((child->d_type & DT_REG) && (type & WalkFile)) {
#if defined(_DIRENT_HAVE_D_NAMLEN) || defined(__APPLE__)
            stpcpy(childPath + folderPathLength, child->d_name);
            childPath[folderPathLength + child->d_namlen] = 0;
#else
            strcpy(childPath + folderPathLength, child->d_name);
#endif
            walker(childPath, WalkFile);
        } else if ((child->d_type & DT_DIR) && (type & WalkFolder)) {
#if defined(_DIRENT_HAVE_D_NAMLEN) || defined(__APPLE__)
            if ((child->d_namlen == 1 && child->d_name[0] == '.') ||
                (child->d_namlen == 2 && child->d_name[0] == '.' && child->d_name[1] == '.')) {
                continue;
            }
            stpcpy(childPath + folderPathLength, child->d_name);
            childPath[folderPathLength + child->d_namlen] = 0;
#else
            if (strcmp(child->d_name, ".") == 0 || strcmp(child->d_name, "..") == 0) {
                continue;
            }
            strcpy(childPath + folderPathLength, child->d_name);
#endif
            walker(childPath, WalkFolder);
        }
    }

    closedir(dir);
}

bool deleteFile(const MMKVPath_t &path) {
    auto filename = path.c_str();
    if (::unlink(filename) != 0) {
        auto err = errno;
        MMKVError("fail to delete file [%s], %d (%s)", filename, err, strerror(err));
        return false;
    }
    return true;
}

#ifndef MMKV_APPLE
bool isDiskOfMMAPFileCorrupted(MemoryFile *file, bool &needReportReadFail) {
    // TODO: maybe we need reading a larger chunk than 4 byte in Android/Linux
    uint32_t info;
    auto fd = file->getFd();
    auto path = file->getPath().c_str();

    auto oldPos = lseek(fd, 0, SEEK_CUR);
    lseek(fd, 0, SEEK_SET);
    auto size = read(fd, &info, sizeof(info));
    auto err = errno;
    lseek(fd, oldPos, SEEK_SET);

    if (size <= 0) {
        needReportReadFail = true;
        MMKVError("fail to read [%s] from fd [%d], errno: %d (%s)", path, fd, err, strerror(err));
        if (err == EIO || err == EILSEQ || err == EINVAL || err == ENXIO) {
            MMKVWarning("file fail to read, consider it illegal, delete now: [%s]", path);
            return true;
        }
    }
    file->cleanMayflyFD();
    return false;
}
#endif

} // namespace mmkv

#endif // !defined(MMKV_WIN32)
