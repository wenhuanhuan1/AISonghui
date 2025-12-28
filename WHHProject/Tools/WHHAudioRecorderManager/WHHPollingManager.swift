//
//  File.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import Foundation

final class WHHPollingManager {

    typealias PollingTask = () -> Void

    private var timer: DispatchSourceTimer?
    private let queue: DispatchQueue

    private var interval: TimeInterval
    private var maxCount: Int?
    private var currentCount: Int = 0

    private var task: PollingTask?

    var isRunning: Bool {
        return timer != nil
    }

    // MARK: - Init
    init(
        interval: TimeInterval,
        maxCount: Int? = nil,
        queueLabel: String = "com.whh.polling.timer"
    ) {
        self.interval = interval
        self.maxCount = maxCount
        self.queue = DispatchQueue(label: queueLabel)
    }

    // MARK: - Start
    func start(task: @escaping PollingTask) {
        guard timer == nil else { return }

        self.task = task
        self.currentCount = 0

        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: interval)

        timer.setEventHandler { [weak self] in
            guard let self = self else { return }

            self.currentCount += 1

            if let max = self.maxCount, self.currentCount > max {
                self.stop()
                return
            }

            DispatchQueue.main.async {
                self.task?()
            }
        }

        self.timer = timer
        timer.resume()
    }

    // MARK: - Stop
    func stop() {
        timer?.cancel()
        timer = nil
        task = nil
        currentCount = 0
    }

    deinit {
        stop()
    }
}
