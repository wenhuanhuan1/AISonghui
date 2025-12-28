//
//  WHAIInputView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/22.
//

import AVFAudio
import UIKit

private let whhAIInputBarMinHeight: CGFloat = 84

private let whhAIInputBarMaxHeight: CGFloat = 180

class WHHCustomMakeButton: WHHBaseView {
    var didButtonClickBlock: (() -> Void)?
    lazy var title: UILabel = {
        let a = UILabel()
        a.font = pingfangMedium(size: 14)
        return a
    }()

    lazy var icon: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.backgroundColor = .clear
        return a
    }()

    lazy var coutView: UIView = {
        let a = UIView()
        a.backgroundColor = .clear
        return a
    }()

    lazy var btn: UIButton = {
        let a = UIButton(type: .custom)
        a.addTarget(self, action: #selector(customButtonClick), for: .touchUpInside)
        return a
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(coutView)
        coutView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        coutView.addSubview(title)
        coutView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.top.bottom.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(4)
            make.right.top.bottom.equalToSuperview()
        }
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func customButtonClick() {
        didButtonClickBlock?()
    }
}

class WHAIInputView: WHHBaseView {
    lazy var closeButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "whhAIClose"), for: .normal)
        a.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var inputBgContenView: UIView = {
        let a = UIView()
        a.backgroundColor = .black
        return a
    }()

    var submitMakeFinish: (() -> Void)?

    private(set) var selectType = 2

    private(set) var recordUrl: URL?

    lazy var voiceView: WHHAIInputVoiceView = {
        let voiceView = WHHAIInputVoiceView()
        voiceView.backgroundColor = .black
        voiceView.recordFinishBlock = { [weak self] url, time in
            self?.recordUrl = url
            self?.setInputRecordTime(time: time)
        }
        return voiceView
    }()

    lazy var startMakeButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("开始生成", for: .normal)
        a.titleLabel?.font = pingfangMedium(size: 12)
        a.backgroundColor = .white
        a.setTitleColor(Color0F0F12, for: .normal)
        a.layer.cornerRadius = 14
        a.isHidden = true
        a.layer.masksToBounds = true
        a.addTarget(self, action: #selector(startMakeButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var keyboardBtn: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "whhAIKeyBoardBtnIcon"), for: .normal)
        a.setImage(UIImage(named: "whhAIKeyBoardBtnIcon"), for: .selected)
        a.addTarget(self, action: #selector(keyboardButtonClick(btn:)), for: .touchUpInside)
        return a
    }()

    lazy var videoButton: WHHCustomMakeButton = {
        let a = WHHCustomMakeButton()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.title.text = "梦成视频"
        a.icon.image = UIImage(named: "whhAIMakeSelectVideoIcon")
        a.title.textColor = .white.withAlphaComponent(0.9)
        a.backgroundColor = .white.withAlphaComponent(0.1)
        a.didButtonClickBlock = { [weak self] in

            self?.videoButton.backgroundColor = .white.withAlphaComponent(0.1)
            self?.videoButton.title.textColor = .white.withAlphaComponent(0.9)
            self?.videoButton.icon.image = UIImage(named: "whhAIMakeSelectVideoIcon")

            self?.phoneButton.icon.image = UIImage(named: "whhAIMakeNormalPictureIcon")
            self?.phoneButton.title.textColor = .white.withAlphaComponent(0.5)
            self?.phoneButton.backgroundColor = .clear

            self?.selectType = 2
        }
        return a
    }()

    lazy var phoneButton: WHHCustomMakeButton = {
        let a = WHHCustomMakeButton()
        a.title.text = "梦成图片"
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.icon.image = UIImage(named: "whhAIMakeNormalPictureIcon")
        a.title.textColor = .white.withAlphaComponent(0.5)

        a.didButtonClickBlock = { [weak self] in

            self?.phoneButton.title.textColor = .white.withAlphaComponent(0.9)
            self?.phoneButton.icon.image = UIImage(named: "whhAIMakeSelectPictureIcon")
            self?.phoneButton.backgroundColor = .white.withAlphaComponent(0.1)

            self?.videoButton.icon.image = UIImage(named: "whhAIMakeNormalVideoIcon")
            self?.videoButton.title.textColor = .white.withAlphaComponent(0.5)
            self?.videoButton.backgroundColor = .clear

            self?.selectType = 1
        }

        return a
    }()

    lazy var textView: WHHAITextView = {
        let a = WHHAITextView()
        a.backgroundColor = .clear
        a.font = pingfangRegular(size: 16)
        a.textColor = .white.withAlphaComponent(0.9)
        a.whhDelegate = self
        return a
    }()

    lazy var integralLabel: UILabel = {
        let a = UILabel()
        a.text = "本次消耗：25积分"
        a.textColor = .white.withAlphaComponent(0.5)
        a.font = pingfangRegular(size: 10)
        a.isHidden = true
        return a
    }()

    lazy var vioceDuration: UILabel = {
        let a = UILabel()
        a.text = "3″25"
        a.isHidden = true
        a.textColor = .white.withAlphaComponent(0.9)
        a.font = pingfangRegular(size: 16)
        return a
    }()

    lazy var vioceIcon: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "whhAIVoiceIcon"), for: .normal)
        a.addTarget(self, action: #selector(whhAIVoiceIconButtonClick), for: .touchUpInside)
        a.isHidden = true
        return a
    }()

    lazy var inputTextViewBgView: WHHBaseView = {
        let a = WHHBaseView()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.backgroundColor = .white.withAlphaComponent(0.05)
        return a
    }()

    lazy var selectBgView: UIView = {
        let a = UIView()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.backgroundColor = .white.withAlphaComponent(0.05)
        return a
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = Color0F0F12.withAlphaComponent(0.6)

        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(WHHTopSafe)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        addSubview(inputBgContenView)
        inputBgContenView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        addSubview(voiceView)
        voiceView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0)
            make.top.equalTo(inputBgContenView.snp.bottom).offset(0)
        }

        inputBgContenView.addSubview(selectBgView)
        selectBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(48)
        }

        selectBgView.addSubview(videoButton)
        selectBgView.addSubview(phoneButton)
        videoButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        phoneButton.snp.makeConstraints { make in
            make.left.equalTo(videoButton.snp.right)
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(videoButton)
        }
        inputBgContenView.addSubview(inputTextViewBgView)
        inputTextViewBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(selectBgView.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-10)
        }
        inputTextViewBgView.addSubview(keyboardBtn)
        keyboardBtn.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        inputTextViewBgView.addSubview(startMakeButton)
        startMakeButton.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(28)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(keyboardBtn)
        }
        inputTextViewBgView.addSubview(integralLabel)
        integralLabel.snp.makeConstraints { make in
            make.right.equalTo(startMakeButton.snp.left).offset(-8)
            make.centerY.equalTo(startMakeButton)
        }
        inputTextViewBgView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(keyboardBtn.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }

        inputTextViewBgView.addSubview(vioceIcon)
        vioceIcon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalTo(keyboardBtn.snp.right).offset(0)
            make.centerY.equalTo(keyboardBtn)
        }

        inputTextViewBgView.addSubview(vioceDuration)
        vioceDuration.snp.makeConstraints { make in
            make.left.equalTo(vioceIcon.snp.right).offset(2)
            make.centerY.equalTo(vioceIcon)
        }

        textView.becomeFirstResponder()
    }

    private func setInputRecordTime(time: Int) {
        textView.isHidden = true
        integralLabel.isHidden = false
        startMakeButton.isHidden = false
        vioceIcon.isHidden = false
        vioceDuration.isHidden = false
        vioceDuration.text = "\(time)s"
    }

    @objc func whhAIVoiceIconButtonClick() {
        debugPrint("开始播放")
    }

    func closeInputView() {
        removeFromSuperview()
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardBtn.isSelected = true
        keyboardButtonClick(btn: keyboardBtn)
    }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardHeight = UIScreen.main.bounds.height - frame.origin.y

        voiceView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-keyboardHeight)
        }
    }

    @objc func keyboardButtonClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected

        if btn.isSelected {
            // 出现voice
            voiceView.snp.updateConstraints { make in
                make.height.equalTo(240)
            }
            voiceView.setCurrentUIStatus(isHidden: false)
            textView.resignFirstResponder()

        } else {
            // 出现键盘
            voiceView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            voiceView.setCurrentUIStatus(isHidden: true)
            textView.becomeFirstResponder()
        }
    }

    @objc func startMakeButtonClick() {
        if let url = recordUrl {
            // 说明有录音

            
        } else {
            guard let text = textView.text else { return }

            WHHHUD.whhShowLoadView()
            WHHIdetifyRequestModel.whhPostRequestWorksMake(type: selectType, prompt: text) { [weak self] code, msg in
                WHHHUD.whhHidenLoadView()

                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }
                if code == 1 {
                    self?.submitMakeFinish?()
                    self?.closeInputView()
                }
            }
        }
    }

    @objc func closeButtonClick() {
        removeFromSuperview()
    }
}

extension WHAIInputView: WHHAITextViewDelegate {
    func whhAItextViewDidChange(_ textView: UITextView) {
        // 开始调整freame

        uploadTextFrame()

        // 开始计算高度
        let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let estimatedSize = textView.sizeThatFits(size)

        var currentTextViewHeight = estimatedSize.height

        if currentTextViewHeight <= whhAIInputBarMinHeight {
            currentTextViewHeight = whhAIInputBarMinHeight
        }

        if currentTextViewHeight >= whhAIInputBarMaxHeight {
            currentTextViewHeight = whhAIInputBarMaxHeight
        }
        
        if textView.text.isEmpty {
            
            currentTextViewHeight = 44
        }

        inputTextViewBgView.snp.updateConstraints { make in
            make.height.equalTo(currentTextViewHeight)
        }

        layoutIfNeeded()
    }

    private func uploadTextFrame() {
        if textView.text.isEmpty {
            integralLabel.isHidden = true
            startMakeButton.isHidden = true
            textView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(0)
            }
        } else {
            integralLabel.isHidden = false
            startMakeButton.isHidden = false
            textView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-40)
            }
        }
    }
}
