//
//  WHHABBChatRequestApi.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHABBChatRequestApi: WHHRequest {
    private var chunkHandler: ((String) -> Void)?
    private var errorHandler: ((Error) -> Void)?
    private var completeHandler: (() -> Void)?

    private(set) var aParameters: [String: Any]?
    init(parameter: [String: Any] = [String: Any]()) {
        super.init()
        aParameters = parameter
    }

    override func responseSerializerType() -> YTKResponseSerializerType {
        
        return .HTTP
    }
    override func requestUrl() -> String {
        return "/chat"
    }

    override func requestArgument() -> Any? {
        return aParameters
    }

    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }

    // MARK: - 回调设置

    @discardableResult
    func onChunk(_ handler: @escaping (String) -> Void) -> Self {
        chunkHandler = handler
        return self
    }

    @discardableResult
    func onError(_ handler: @escaping (Error) -> Void) -> Self {
        errorHandler = handler
        return self
    }

    @discardableResult
    func onComplete(_ handler: @escaping () -> Void) -> Self {
        completeHandler = handler
        return self
    }

    // MARK: - 开始请求

    override func start() {
        // ✅ 设置成功 & 失败回调
        successCompletionBlock = { [weak self] _ in
            self?.completeHandler?()
        }
        failureCompletionBlock = { [weak self] request in
            if let err = request.error {
                self?.errorHandler?(err)
            }
        }

        super.start()

        guard let task = requestTask as? URLSessionDataTask else {
            return
        }

        // ⚡️ 通过 task 拿到 AFURLSessionManager
        if let session = task.value(forKey: "session") as? URLSession,
           let delegate = session.delegate as? AFURLSessionManager {
            delegate.setDataTaskDidReceiveDataBlock { [weak self] _, _, data in
                guard let self = self else { return }
                if let chunk = String(data: data, encoding: .utf8) {
                    self.chunkHandler?(chunk)
                }
            }
        }
    }
}
