//
//  WHHWKWebViewViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import UIKit
@preconcurrency import WebKit

class WHHWKWebViewViewController: WHHBaseViewController {
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = ColorF2F4FE
        contentView.layer.cornerRadius = 22
        contentView.layer.masksToBounds = true
        return contentView
    }()

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("确认".localized, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var wkWebView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        config.allowsInlineMediaPlayback = true
        config.selectionGranularity = .dynamic
        config.processPool = WKProcessPool()
        let userContentController = WKUserContentController()
        config.suppressesIncrementalRendering = true
        config.userContentController = userContentController

        let view = WKWebView(frame: .zero, configuration: config)
        view.backgroundColor = .clear
        view.isOpaque = false
        view.uiDelegate = self
        view.navigationDelegate = self
        return view
    }()

    private(set) var webUrl: String?

    deinit {
        wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        wkWebView.removeObserver(self, forKeyPath: "title")
    }

    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        webUrl = url
        
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = "协议"
        gk_navTitleColor = .black
        gk_backStyle = .black
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 14)
        }

        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 20)
            make.top.equalTo(contentView.snp.bottom).offset(42)
        }

        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        wkWebView.addObserver(self, forKeyPath: "title", options: .new, context: nil)

        contentView.addSubview(wkWebView)
        wkWebView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(14)
            make.bottom.right.equalToSuperview().offset(-14)
        }

        guard let tempUrl = webUrl else { return }

        /// 清理缓存
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date) {
            print("WKWebView 缓存已清除")
        }

        if let url = URL(string: tempUrl) {
            let request = URLRequest(url: url)
            wkWebView.load(request)
        }
    }

    @objc func submitButtonClick() {
        navigationController?.popViewController(animated: true)
    }
}

extension WHHWKWebViewViewController: WKUIDelegate, WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" && object as AnyObject === wkWebView {
            if let newValue = change?[.newKey] as? Float {
//                progressView.progress = newValue
            }
        } else if keyPath == "title" {
            if object as AnyObject === wkWebView {
                if title == nil {
                    title = wkWebView.title
                }
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    private func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let title = webView.title {
            if self.title?.isEmpty == false {
                gk_navTitle = title
            }
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
    }

    private func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation) {}

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let actionPolicy: WKNavigationActionPolicy = .allow
        decisionHandler(actionPolicy)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load web page. Error: \(error.localizedDescription)")
    }
}

class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
