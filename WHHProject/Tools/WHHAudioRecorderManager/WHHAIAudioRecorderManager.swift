//
//  WHHAIAudioRecorderManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import Foundation

import AVFoundation

final class WHHAIAudioRecorderManager: NSObject {
    
    private var recorder: AVAudioRecorder?
    private var timer: Timer?

    private let maxDuration: Int = 60
    private var remainingSeconds: Int = 60

    var currentRecordDuration = 0
    /// 录音完成回调
    var recordFinish: ((URL) -> Void)?

    /// 倒计时回调（每秒）
    var countdownCallback: ((Int) -> Void)?

    // MARK: - 开始录音
    func startRecording() {
        requestPermission { [weak self] granted in
            guard granted else { return }
            self?.start()
        }
    }

    private func start() {
        remainingSeconds = maxDuration
        countdownCallback?(remainingSeconds)

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)

        let url = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)voice.m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.delegate = self
        recorder?.record()

        startCountdown()
    }

    // MARK: - 停止录音
    func stopRecording() {
        recorder?.stop()
        stopTimer()
    }

    // MARK: - 倒计时
    private func startCountdown() {
        stopTimer()
        currentRecordDuration = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.remainingSeconds -= 1
            self.currentRecordDuration += 1
            self.countdownCallback?(self.remainingSeconds)

            if self.remainingSeconds <= 0 {
                self.stopRecording()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - 权限
    private func requestPermission(_ completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}

extension WHHAIAudioRecorderManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag else { return }
        recordFinish?(recorder.url)
    }
}
