//
//  WHHlogoutAccoutAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/2.
//

import UIKit

enum WHHlogoutAccoutAlertViewType {
    case beginLogout
    case logouting
}

class WHHlogoutAccoutAlertView: WHHBaseView {
    
    private var timer: DispatchSourceTimer?
    private var remainingTime: Int = 4000
    
    lazy var centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 8
        centerView.layer.masksToBounds = true
        return centerView
    }()

    lazy var contDown: UIView = {
        let contDown = UIView()
        contDown.backgroundColor = ColorF2F4FE
        contDown.layer.cornerRadius = 12
        contDown.layer.masksToBounds = true
        return contDown
    }()

    lazy var bigTitle: UILabel = {
        let bigTitle = UILabel()
        bigTitle.text = "确认注销"
        bigTitle.textAlignment = .center
        bigTitle.font = pingfangSemibold(size: 16)
        bigTitle.textColor = Color2C2B2D
        return bigTitle
    }()

    lazy var timeTitle: UILabel = {
        let timeTitle = UILabel()
        timeTitle.text = "11:22"
        timeTitle.textAlignment = .center
        timeTitle.font = pingfangSemibold(size: 16)
        timeTitle.textColor = Color746CF7
        return timeTitle
    }()

    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("whhDivinationBackTitleKey".localized, for: .normal)
        backButton.titleLabel?.font = pingfangRegular(size: 14)
        backButton.setTitleColor(Color2C2B2D, for: .normal)
        backButton.backgroundColor = ColorEDEBEF
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return backButton
    }()

    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .custom)
        submitButton.setTitle("注销", for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = ColorFF4D4F
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var smallTitle: UILabel = {
        let smallTitle = UILabel()
        smallTitle.text = "点击【注销】，将会自动关闭APP并开始进行数据清理，清理时间预计需要24小时，24小时将无法正常访问。"
        smallTitle.textAlignment = .center
        smallTitle.numberOfLines = 0
        smallTitle.font = pingfangRegular(size: 16)
        smallTitle.textColor = Color2C2B2D.whhAlpha(alpha: 0.6)
        return smallTitle
    }()

    var type: WHHlogoutAccoutAlertViewType? {
        didSet {
            guard let newType = type else { return }

            if newType == .beginLogout {
                bigTitle.text = "确认注销"
                smallTitle.text = "点击【注销】，将会自动关闭APP并开始进行数据清理，清理时间预计需要24小时，24小时将无法正常访问。"
                contDown.isHidden = true
                backButton.setTitle("返回", for: .normal)
                submitButton.setTitle("注销", for: .normal)
            } else if newType == .logouting {
                bigTitle.text = "正在注销..."
                smallTitle.text = "当前手机设备正在进行注销数据"
                contDown.isHidden = false
                backButton.setTitle("继续注销", for: .normal)
                submitButton.setTitle("停止注销", for: .normal)
                startCountdown()
            }
        }
    }

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.5)
        addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(225)
        }
        centerView.addSubview(bigTitle)
        bigTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(32)
        }
        centerView.addSubview(smallTitle)
        smallTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(bigTitle.snp.bottom).offset(8)
        }
        centerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        centerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-24)
            make.width.height.bottom.equalTo(backButton)
        }
        centerView.addSubview(contDown)
        contDown.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backButton.snp.top).offset(-29)
            make.height.equalTo(24)
        }
        contDown.addSubview(timeTitle)
        timeTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    private func startCountdown() {
        let queue = DispatchQueue(label: "com.WHH.SOHui")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(1))
        timer?.setEventHandler {
            onMainThread { [weak self] in
                guard let self = self else { return }
                if remainingTime > 1 {
                    remainingTime -= 1
                    self.timeTitle.text = whhFormatSecondsAsTime(remainingTime)
                } else {
                    stopCountdown()
                }
            }
        }
        timer?.resume()
    }

    func stopCountdown() {
        timer?.cancel()
    }
    

    @objc func backButtonClick() {
        removeFromSuperview()
    }

    @objc func submitButtonClick() {
    }
    
    /// 秒转时间
    func whhFormatSecondsAsTime(_ seconds: Int) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: TimeInterval(seconds))
    }
}
