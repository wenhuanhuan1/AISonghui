//
//  WHHAIIdentifyHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class HomeMakeView: WHHBaseView {
    var didHomeMakeViewButtonBlock: (() -> Void)?

    lazy var tipLabel: UILabel = {
        let a = UILabel()
        a.text = "阿贝贝正在使用AI魔法画笔\n帮你把梦绘制成一幅精美的画..."
        a.font = pingfangRegular(size: 14)
        a.numberOfLines = 0
        a.textColor = .white
        return a
    }()

    lazy var activityView: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.startAnimating()
        return a
    }()

    lazy var avatar: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.layer.cornerRadius = 8
        a.layer.masksToBounds = true
        a.backgroundColor = Color0F0F12.withAlphaComponent(5)
        return a
    }()

    override func setupViews() {
        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.size.equalTo(56)
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        avatar.addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func buttonClick() {
        didHomeMakeViewButtonBlock?()
    }
}

class WHHAIIdentifyHomeViewController: WHHBaseViewController {
    lazy var inputBar: UIView = {
        let a = UIView()
        a.backgroundColor = Color2B2D33
        a.layer.cornerRadius = 24
        a.layer.masksToBounds = true
        a.isHidden = true
        return a
    }()

    lazy var inputBarButton: UIButton = {
        let a = UIButton(type: .custom)
        a.addTarget(self, action: #selector(inputBarButtonClick), for: .touchUpInside)
        return a
    }()

    private lazy var waitListPolling = WHHPollingManager(
        interval: 3,
        maxCount: nil // 不限制次数（可改 20）
    )

    lazy var sendIcon: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.image = UIImage(named: "whhAIInputBarSend")
        return a
    }()

    lazy var tipLabel: UILabel = {
        let a = UILabel()
        a.text = "描述你经历的梦境..."
        a.font = pingfangRegular(size: 16)
        a.numberOfLines = 1
        a.textColor = .white.withAlphaComponent(0.3)
        return a
    }()

    private(set) var currentModel: WHHIntegralModel?

    lazy var makeView: HomeMakeView = {
        let a = HomeMakeView()
        a.backgroundColor = Color2B2D33
        a.layer.cornerRadius = 12
        a.isHidden = true
        a.layer.masksToBounds = true
        a.didHomeMakeViewButtonBlock = { [weak self] in
            debugPrint("惦记了哈哈")

            guard let model = self?.currentModel else { return }

            WHHIdetifyRequestModel.whhPostWorksWaitListRemoveRequest(worksId: model.worksId) { code, msg in

                if code == 1 {
                    self?.inputBar.isHidden = false
                    self?.makeView.isHidden = true
                    let vc = WHHIdetifyDetailViewController(worksId: model.worksId,type: .mySelf)
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    WHHHUD.whhShowInfoText(text: msg)
                }
            }
        }
        return a
    }()

    lazy var bgMaskView: WHHAIMaskView = {
        let a = WHHAIMaskView()
        return a
    }()

    lazy var bgIconImageView: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.image = UIImage(named: "whhHomwBgIcon")
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navigationBar.isHidden = true

        view.addSubview(bgIconImageView)
        bgIconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(bgMaskView)
        bgMaskView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(302)
        }
        view.addSubview(makeView)
        makeView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-WHHTabBarHeight)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(88)
            make.right.equalToSuperview().offset(-16)
        }

        view.addSubview(inputBar)
        inputBar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(48)
        }

        inputBar.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        inputBar.addSubview(sendIcon)
        sendIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        inputBar.addSubview(inputBarButton)
        inputBarButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        getwhhTimerGetRequestWorksWaitList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        waitListPolling.stop()
    }

    /// 刷新制作功能
    private func getwhhTimerGetRequestWorksWaitList() {
        WHHIdetifyRequestModel.whhGetRequestWorksWaitList { [weak self] code, model, _ in
            guard let self = self else { return }

            if code == 1 {
                if model.canMaking {
                    self.inputBar.isHidden = false
                    self.makeView.isHidden = true
                    self.waitListPolling.stop()
                    return
                }

                self.inputBar.isHidden = true
                self.makeView.isHidden = false

                guard let firstModel = model.list.first else { return }

                switch firstModel.status {
                case 1:
                    // 制作中 → 启动轮询
                    self.waitListPolling.start { [weak self] in
                        self?.getwhhTimerGetRequestWorksWaitList()
                    }

                case 2:
                    // 完成
                    self.waitListPolling.stop()
                    self.currentModel = firstModel
                case 0:
                    // 失败
                    self.waitListPolling.stop()
                    WHHHUD.whhShowInfoText(text: "制作失败")
                    self.inputBar.isHidden = false
                    self.makeView.isHidden = true
                  // 删除
                    WHHIdetifyRequestModel.whhPostWorksWaitListRemoveRequest(worksId: firstModel.worksId) { code, msg in

                    }
                    
                default:
                    break
                }

            } else {
                self.waitListPolling.stop()
                WHHHUD.whhShowInfoText(text: "请求失败")
            }
        }
    }

    @objc func inputBarButtonClick() {
        debugPrint("哈哈哈惦记了")
        let inputView = WHAIInputView()
        inputView.submitMakeFinish = { [weak self] in

            self?.getwhhTimerGetRequestWorksWaitList()
        }
        UIWindow.getKeyWindow?.addSubview(inputView)
    }
}
