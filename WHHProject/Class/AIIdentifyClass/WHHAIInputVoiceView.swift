//
//  WHHAIInputVoiceView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/25.
//

import AVFAudio
import UIKit

class WHHAIInputVoiceView: WHHBaseView {
    
    var recordFinishBlock:((URL,Int)->Void)?
    lazy var tipsLabel: UILabel = {
        let a = UILabel()
        a.font = pingfangMedium(size: 16)
        a.text = "按住说话"
        a.textColor = .white.withAlphaComponent(0.9)
        a.textAlignment = .center
        return a
    }()

    lazy var recorder: WHHAIAudioRecorderManager = {
        let a = WHHAIAudioRecorderManager()
        a.recordFinish = {[weak self] url in
            self?.warningLabel.isHidden = true
            self?.recordFinishBlock?(url,a.currentRecordDuration)
        }
        a.countdownCallback = {[weak self] count in
            self?.warningLabel.text = "录音剩余\(count)s"
        }
        return a
    }()

    lazy var warningLabel: UILabel = {
        let a = UILabel()
        a.font = pingfangRegular(size: 12)
        a.text = "最长支持60s"
        a.isHidden = true
        a.textColor = .white.withAlphaComponent(0.5)
        a.textAlignment = .center
        return a
    }()

    lazy var voiceButton: UIButton = {
        let a = UIButton(type: .custom)
        a.backgroundColor = .white.withAlphaComponent(0.1)
        a.setImage(UIImage(named: "whhVoiceIconNormal"), for: .normal)
        a.setImage(UIImage(named: "whhVoiceIconAnimal"), for: .highlighted)
        // 按下开始
        a.addTarget(self, action: #selector(touchDown), for: .touchDown)

        // 松开结束
        a.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        a.layer.cornerRadius = 60
        a.layer.masksToBounds = true

        return a
    }()

    @objc private func touchDown() {
        MicrophonePermissionHelper.checkAndRequest { [weak self] enabled in
            if enabled == 0 {
                if let vc = UIWindow.getKeyWindow {
                    let view = WHHIdAlertView().whhLoadXib()
                    view.bigTtitleLabel.text = "麦克风授权未开启"
                    view.desTitle.text = "为了实现语音描述梦境，阿贝贝需要调您的麦克风权限"
                    view.didSubmitBtnBlock = { display in
                        display.closeMethod()
                        AVAudioSession.sharedInstance().requestRecordPermission { _ in
                        }
                    }
                    vc.addSubview(view)
                }

            } else if enabled == 2 {
                // 拒接
                MicrophonePermissionHelper.openSettings()
            } else if enabled == 1 {
                self?.tipsLabel.text = "松开确认"
                self?.voiceButton.setImage(UIImage(named: "whhVoiceIconAnimal"), for: .selected)
                self?.warningLabel.isHidden = false
                self?.recorder.startRecording()
            }
        }
    }

    @objc private func touchUp() {
        tipsLabel.text = "按住说话"
        voiceButton.setImage(UIImage(named: "whhVoiceIconNormal"), for: .normal)
        recorder.stopRecording()
    }

    override func setupViews() {
        super.setupViews()
        backgroundColor = Color030303
        addSubview(voiceButton)
        voiceButton.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.center.equalToSuperview()
        }
        addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(voiceButton)
            make.bottom.equalTo(voiceButton.snp.top).offset(-16)
        }
        addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalTo(voiceButton)
            make.top.equalTo(voiceButton.snp.bottom).offset(16)
        }
    }

    func setCurrentUIStatus(isHidden:Bool) {
        
        voiceButton.isHidden = isHidden
        tipsLabel.isHidden = isHidden
        
    }
}
