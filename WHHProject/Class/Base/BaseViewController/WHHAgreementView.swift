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
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 24
        centerView.layer.masksToBounds = true
        return centerView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isEditable = false
        let att = NSMutableAttributedString(string: " 在你体验精彩有趣且带着魔法的服务之前，为了你的个人隐私能得到最好的保护，请您仔细阅读 ", attributes: [.foregroundColor:Color6A6A6B,.font:pingfangRegular(size: 12)!])
        
        let attributedString = NSMutableAttributedString(
            string: "《用户协议》",
            attributes: [.font: pingfangRegular(size: 12)!,.foregroundColor:Color6D64FF]
        )
        let range = (attributedString.string as NSString).range(of: "《用户协议》")
        attributedString.addAttribute(.link, value: "terms://", range: range)
        att.append(attributedString)
        
        let heAtt = NSAttributedString(
            string: "和",
            attributes: [.font: pingfangRegular(size: 12)!,.foregroundColor:Color6D64FF]
        )
        att.append(heAtt)
        
        let attributedString1 = NSMutableAttributedString(
            string: "《隐私政策》",
            attributes: [.font: pingfangRegular(size: 12)!,.foregroundColor:Color6D64FF]
        )
        let range1 = (attributedString1.string as NSString).range(of: "《隐私政策》")
        attributedString1.addAttribute(.link, value: "conceal://", range: range1)
        att.append(attributedString1)
        
//        let heAtt1 = NSAttributedString(
//            string: " ，点击「同意」即表示已阅读并完全同意全部条款。 ",
//            attributes: [.font: pingfangRegular(size: 12)!,.foregroundColor:Color6A6A6B]
//        )
//        att.append(heAtt1)
        textView.attributedText = att
        return textView
    }()
    
    lazy var bigTitle: UILabel = {
        let bigTitle = UILabel()
        bigTitle.text = "欢迎你的到来，我是神奇女巫·阿贝贝"
        bigTitle.textAlignment = .center
        bigTitle.font = pingfangSemibold(size: 14)
        bigTitle.textColor = Color2C2B2D
        return bigTitle
    }()
    
    lazy var contentTitle: UILabel = {
        let contentTitle = UILabel()
        contentTitle.numberOfLines = 0
        let att = NSMutableAttributedString(string: "在我的魔法屋，我会为你提供专属的", attributes: [.foregroundColor:Color6A6A6B,.font:pingfangRegular(size: 12)!])
        let att1 = NSAttributedString(string: " 每日运势占卜预言，涵盖事业、感情、财运与健康 ", attributes: [.foregroundColor:Color2C2B2D,.font:pingfangMedium(size: 12)!])
        att.append(att1)
        let att2 = NSAttributedString(string: " 。如果你愿意分享今天已发生的具体事件（如遇到的人、做出的决定或意外状况），我还可以 ", attributes: [.foregroundColor:Color6A6A6B,.font:pingfangRegular(size: 12)!])
        att.append(att2)
        
        let att3 = NSAttributedString(string: "结合现实调整预言", attributes: [.foregroundColor:Color2C2B2D,.font:pingfangMedium(size: 12)!])
        att.append(att3)
        let att4 = NSAttributedString(string: " ，让它更贴合你的实际境遇，指引更精准的未来走向。 ", attributes: [.foregroundColor:Color6A6A6B,.font:pingfangRegular(size: 12)!])
        att.append(att4)
        contentTitle.attributedText = att
        return contentTitle
    }()
    
//    lazy var backButton: UIButton = {
//        let backButton = UIButton(type: .custom)
//        backButton.setTitle("whhDivinationBackTitleKey".localized, for: .normal)
//        backButton.titleLabel?.font = pingfangRegular(size: 14)
//        backButton.setTitleColor(Color2C2B2D, for: .normal)
//        backButton.backgroundColor = ColorEDEBEF
//        backButton.layer.cornerRadius = 22
//        backButton.layer.masksToBounds = true
//        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
//        return backButton
//    }()
    
    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("同意并继续".localized, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()
    
    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .clear
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(326)
        }
        
//        centerView.addSubview(backButton)
//        backButton.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(12)
//            make.bottom.equalToSuperview().offset(-24)
//            make.height.equalTo(44)
//        }
        centerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }
        centerView.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(24)
        }
        centerView.addSubview(contentTitle)
        contentTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(bigTitle.snp.bottom).offset(20)
        }
        centerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(contentTitle.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
    }

    @objc func backButtonClick() {
        
        WHHHUD.whhShowInfoText(text: "APP即将退出")
        dispatchAfter(delay: 1) {
            exit(1)
        }
    }
    @objc func submitButtonClick() {
        
        WHHUserInfoManager.whhSaveShowPrivacyAlertView()
        routerSwitchRootViewController()

    }
}
extension WHHAgreementView:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in range: NSRange) -> Bool {
        if URL.scheme == "terms" {
            print("跳转到协议页面")
            return false // 阻止系统默认行为:ml-citation{ref="4,9" data="citationList"}
        }else if URL.scheme == "conceal"{
            
            debugPrint("点击了了隐私")
        }
        return true
    }
}
