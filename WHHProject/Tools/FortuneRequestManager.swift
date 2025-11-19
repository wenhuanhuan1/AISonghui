//
//  FortuneRequestManager.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/19.
//

import Foundation
import UIKit

/// Fortune 请求管理器单例（可取消请求，回调只触发一次）
class FortuneRequestManager {

    // MARK: - 单例
    static let shared = FortuneRequestManager()

    private init() {} // 私有化初始化，确保单例

    // MARK: - 私有属性
    private var witchId: Int = 0
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    private let interval: TimeInterval = 3      // 请求间隔
    private let timeout: TimeInterval = 15      // 最大等待时间

    private var completion: Completion?
    private var hasCompleted: Bool = false  // 防止重复回调

    /// 回调闭包，只触发一次
    /// - Parameters:
    ///   - success: 是否成功（fortune.suggestion 有内容）
    ///   - message: 接口返回的提示信息
    typealias Completion = (_ success: Bool, _ message: String) -> Void

    // MARK: - 开始请求
    func startRequest(witchId: Int, completion: @escaping Completion) {
        stopRequest() // 防止重复
        self.witchId = witchId
        self.completion = completion
        self.hasCompleted = false
        elapsedTime = 0

        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(requestAction), userInfo: nil, repeats: true)
        timer?.fire() // 立即执行一次
    }

    // MARK: - 取消请求
    func cancelRequest() {
        hasCompleted = true
        stopRequest()
    }

    // MARK: - 停止定时器
    private func stopRequest() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - 请求动作
    @objc private func requestAction() {
        guard !hasCompleted else {
            stopRequest()
            return
        }

        elapsedTime += interval
        if elapsedTime > timeout {
            hasCompleted = true
            stopRequest()
            completion?(false, "请求超时")
            return
        }

        WHHHomeRequestViewModel.getCreateAppUserWitchCreateFortune(witchId: witchId) { [weak self] code, data, msg in
            guard let self = self, !self.hasCompleted else { return }

            if code == 1 {
                if !data.fortune.suggestion.isEmpty {
                    self.hasCompleted = true
                    self.stopRequest()
                    self.completion?(true, msg)
                }
                // suggestion 为空时继续轮询，不回调
            } else {
                self.hasCompleted = true
                self.stopRequest()
                self.completion?(false, msg)
            }
        }
    }

    deinit {
        cancelRequest()
    }
}
