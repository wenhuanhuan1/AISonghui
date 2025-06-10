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

#ifndef MMKV_MAMERYFILE_H
#define MMKV_MAMERYFILE_H
#ifdef __cplusplus

#include "MMKVPredef.h"
#include <cstdint>
#include <functional>

#ifdef MMKV_ANDROID
MMKVPath_t ashmemMMKVPathWithID(const MMKVPath_t &mmapID);

long long getFileModifyTimeInMS(const char *path);

namespace mmkv {
extern int g_android_api;
extern std::string g_android_tmpDir;

enum FileType : bool { MMFILE_TYPE_FILE = false, MMFILE_TYPE_ASHMEM = true };
} // namespace mmkv
#endif // MMKV_ANDROID

namespace mmkv {

enum class OpenFlag : uint32_t {
    ReadOnly = 1 << 0,
    WriteOnly = 1 << 1,
    ReadWrite = ReadOnly | WriteOnly,
    Create = 1 << 2,
    Excel = 1 << 3, // fail if Create is set but the file already exist
    Truncate = 1 << 4,
};
constexpr uint32_t OpenFlagRWMask = 0x3; // mask for Read Write mode

static inline OpenFlag operator | (OpenFlag left, OpenFlag right) {
    return static_cast<OpenFlag>(static_cast<uint32_t>(left) | static_cast<uint32_t>(right));
}

static inline bool operator & (OpenFlag left, OpenFlag right) {
    return ((static_cast<uint32_t>(left) & static_cast<uint32_t>(right)) != 0);
}

static inline OpenFlag operator & (OpenFlag left, uint32_t right) {
    return static_cast<OpenFlag>(static_cast<uint32_t>(left) & right);
}

template <typename T>
T roundUp(T numToRound, T multiple) {
    return ((numToRound + multiple - 1) / multiple) * multiple;
}

class FileLock;

class File {
    MMKVPath_t m_path;
    MMKVFileHandle_t m_fd;
public:
    const OpenFlag m_flag;
#ifndef MMKV_ANDROID
    explicit File(MMKVPath_t path, OpenFlag flag);
#else
    File(MMKVPath_t path, OpenFlag flag, size_t size = 0, FileType fileType = MMFILE_TYPE_FILE);
    explicit File(MMKVFileHandle_t ashmemFD);

    size_t m_size;
    const FileType m_fileType;
#endif // MMKV_ANDROID

    ~File() { close(); }

    bool open();

    void close();

    MMKVFileHandle_t getFd() { return m_fd; }

    const MMKVPath_t &getPath() const { return m_path; }

#ifndef MMKV_WIN32
    bool isFileValid() const { return m_fd >= 0; }
#else
    bool isFileValid() const { return m_fd != MMKVFileHandleInvalidValue; }
#endif

    // get the actual file size on disk
    size_t getActualFileSize() const;

    // just forbid it for possibly misuse
    explicit File(const File &other) = delete;
    File &operator=(const File &other) = delete;

    friend class MemoryFile;
};

class MemoryFile {
    File m_diskFile;
#ifdef MMKV_WIN32
    HANDLE m_fileMapping;
#endif
    void *m_ptr;
    size_t m_size;
    const bool m_readOnly;
    const bool m_isMayflyFD;

    bool mmapOrCleanup(FileLock *fileLock);

    void doCleanMemoryCache(bool forceClean);

    bool openIfNeeded();

public:
#ifndef MMKV_ANDROID
    explicit MemoryFile(MMKVPath_t path, size_t expectedCapacity = 0, bool readOnly = false, bool mayflyFD = false);
#else
    MemoryFile(MMKVPath_t path, size_t size, FileType fileType, size_t expectedCapacity = 0, bool readOnly = false, bool mayflyFD = false);
    explicit MemoryFile(MMKVFileHandle_t ashmemFD);

    const FileType m_fileType;
#endif // MMKV_ANDROID

    ~MemoryFile() { doCleanMemoryCache(true); }

    size_t getFileSize() const { return m_size; }

    // get the actual file size on disk
    size_t getActualFileSize();

    void *getMemory() { return m_ptr; }

    const MMKVPath_t &getPath() { return m_diskFile.getPath(); }

    MMKVFileHandle_t getFd();

    void cleanMayflyFD();

    // the newly expanded file content will be zeroed
    bool truncate(size_t size, FileLock *fileLock = nullptr);

    bool msync(SyncFlag syncFlag);

    // call this if clearMemoryCache() has been called
    void reloadFromFile(size_t expectedCapacity = 0);

    void clearMemoryCache() { doCleanMemoryCache(false); }

#ifndef MMKV_WIN32
    bool isFileValid() { return (m_isMayflyFD || m_diskFile.isFileValid()) && m_size > 0 && m_ptr; }
#else
    bool isFileValid() { return (m_isMayflyFD || (m_diskFile.isFileValid() && m_fileMapping)) && m_size > 0 && m_ptr; }
#endif

    // just forbid it for possibly misuse
    explicit MemoryFile(const MemoryFile &other) = delete;
    MemoryFile &operator=(const MemoryFile &other) = delete;
};

class MMBuffer;

extern bool mkPath(const MMKVPath_t &path);
extern bool isFileExist(const MMKVPath_t &nsFilePath);
extern MMBuffer *readWholeFile(const MMKVPath_t &path);
extern bool zeroFillFile(MMKVFileHandle_t fd, size_t startPos, size_t size);
extern size_t getPageSize();
extern MMKVPath_t absolutePath(const MMKVPath_t &path);
#ifndef MMKV_WIN32
extern bool getFileSize(int fd, size_t &size);
#endif
extern bool tryAtomicRename(const MMKVPath_t &srcPath, const MMKVPath_t &dstPath);

// copy file by potentially renaming target file, might change file inode
extern bool copyFile(const MMKVPath_t &srcPath, const MMKVPath_t &dstPath);

// copy file by source file content, keep file inode the same
extern bool copyFileContent(const MMKVPath_t &srcPath, const MMKVPath_t &dstPath);
extern bool copyFileContent(const MMKVPath_t &srcPath, MMKVFileHandle_t dstFD);
extern bool copyFileContent(const MMKVPath_t &srcPath, MMKVFileHandle_t dstFD, bool needTruncate);

//#if defined(MMKV_APPLE) || defined(MMKV_WIN32)
bool isDiskOfMMAPFileCorrupted(MemoryFile *file, bool &needReportReadFail);
//#endif

bool deleteFile(const MMKVPath_t &path);

enum WalkType : uint32_t {
    WalkFile = 1 << 0,
    WalkFolder = 1 << 1,
};
extern void walkInDir(const MMKVPath_t &dirPath, WalkType type, const std::function<void(const MMKVPath_t&, WalkType)> &walker);

} // namespace mmkv

#endif
#endif //MMKV_MAMERYFILE_H
