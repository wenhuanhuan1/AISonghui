//
//  WHHAgreementView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/2.
//

import UIKit

class WHHAgreementView: WHHBaseView {
    lazy var centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = Color2B2D33
        centerView.layer.cornerRadius = 16
        centerView.layer.masksToBounds = true
        return centerView
    }()

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isEditable = false

        let paragraphStyle1 = NSMutableParagraphStyle()
        // 设置行间距
        paragraphStyle1.lineSpacing = 5

        let att = NSMutableAttributedString(string: " 欢迎您使用阿贝贝！ 为了更好地为您提供相关服务，我们将通过", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5), .font: pingfangRegular(size: 14)!, .paragraphStyle: paragraphStyle1])

        let attributedString = NSMutableAttributedString(
            string: "《用户协议》",
            attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: Color25C5FF]
        )
        let range = (attributedString.string as NSString).range(of: "《用户协议》")
        attributedString.addAttribute(.link, value: "terms://", range: range)
        att.append(attributedString)

        let heAtt = NSAttributedString(
            string: "和",
            attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        att.append(heAtt)

        let attributedString1 = NSMutableAttributedString(
            string: "《隐私政策》",
            attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: Color25C5FF]
        )
        let range1 = (attributedString1.string as NSString).range(of: "《隐私政策》")
        attributedString1.addAttribute(.link, value: "conceal://", range: range1)
        att.append(attributedString1)
        let paragraphStyle = NSMutableParagraphStyle()
        // 设置行间距
        paragraphStyle.lineSpacing = 5

        let heAtt1 = NSAttributedString(
            string: "，帮助您了解我们收集、使用、存储和处理个人信息的方式，以及对您个人隐私的保护措施。点击“同意并继续”代表您已阅读且同意前述协议及以下约定。 \n1、我们可能会手机设备信息(如网络设备硬件地址)、日志信息，用于保障服务正常运行和安全风控，并申请相册权限，用于下载梦境画像。这些敏感权限不会默认或强制开启收集信息。                 \n2、您承诺使用阿贝贝AI进行梦境成画创作时所提供的全部内容为您本人所有或已获得合法授权，不得使用阿贝贝进行非法活动或发布违法内容。若因您不当使用阿贝贝导致任何第三方权益受损，您将依法承担相应责任。如果您对协议或政策内容有任何疑问，可以通过邮箱:MySecret_Home@163.com 与我们联系",
            attributes: [.font: pingfangRegular(size: 14)!, .foregroundColor: UIColor.white.withAlphaComponent(0.5), .paragraphStyle: paragraphStyle]
        )
        att.append(heAtt1)
        textView.attributedText = att
        return textView
    }()

    lazy var bigTitle: UILabel = {
        let bigTitle = UILabel()
        bigTitle.text = "欢迎您使用阿贝贝！"
        bigTitle.textAlignment = .center
        bigTitle.font = pingfangSemibold(size: 18)
        bigTitle.textColor = .white
        return bigTitle
    }()

    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("不同意", for: .normal)
        backButton.titleLabel?.font = pingfangRegular(size: 14)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .clear
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return backButton
    }()

    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.setTitle("同意并继续", for: .normal)
        submitButton.titleLabel?.font = pingfangMedium(size: 14)
        submitButton.setTitleColor(Color1E2024, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.backgroundColor = .white
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = Color0F0F12
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 30)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 20)
        }

        centerView.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(24)
        }

        centerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }
        centerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(backButton.snp.top).offset(-24)
            make.height.equalTo(44)
        }

        centerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(bigTitle.snp.bottom).offset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(-20)
        }
    }

    @objc func backButtonClick() {
        if let vc = UIWindow.getKeyWindow {
            let view = WHHIdAlertView().whhLoadXib()
            view.didSubmitBtnBlock = { dis in
                dis.closeMethod()
                exit(1)
            }
            vc.addSubview(view)
        }
    }

    @objc func submitButtonClick() {
        WHHUserInfoManager.whhSaveShowPrivacyAlertView()

        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.switchRootViewController()
        }
    }
}

extension WHHAgreementView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in range: NSRange) -> Bool {
        if URL.scheme == "terms" {
            if let vc = UIViewController.currentViewController() {
                let webView = WHHWKWebViewViewController(url: "https://abeibei.vip/terms.html")
                vc.navigationController?.pushViewController(webView, animated: true)
            }
            return false // 阻止系统默认行为:ml-citation{ref="4,9" data="citationList"}
        } else if URL.scheme == "conceal" {
            if let vc = UIViewController.currentViewController() {
                let webView = WHHWKWebViewViewController(url: "https://abeibei.vip/privacy.html")
                vc.navigationController?.pushViewController(webView, animated: true)
            }
        }
        return true
    }
}
