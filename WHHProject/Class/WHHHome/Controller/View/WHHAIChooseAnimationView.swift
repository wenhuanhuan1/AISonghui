//
//  WHHAIChooseAnimationView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

import UIKit

class WHHAIChooseAnimationView: UIView {
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5) // 将大小扩大到原来的2倍
        activityIndicatorView.color = ColorFF4D94
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()

    lazy var loadTitle: UILabel = {
        let loadTitle = UILabel()
        loadTitle.font = pingfangSemibold(size: 15)
        loadTitle.textColor = ColorFF4D94
        loadTitle.text = "你是蛇啊"
        loadTitle.textAlignment = .center
        loadTitle.isHidden = true
        return loadTitle
    }()

    lazy var sView: WHHAISubscriptionView = {
        let a = WHHAISubscriptionView().loadXib()
        a.frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        return a
    }()

    var timer: Timer?

    var count = 0

    var witchId = 0

    lazy var amaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.layer.masksToBounds = true
        return view
    }()

    lazy var tipLabel: UILabel = {
        let view = UILabel()
        view.text = "你选择的占卜师正在解析你今天的运势\n请耐心等待一下\n命运需要时间来勾勒"
        view.textColor = .white
        view.numberOfLines = 0
        view.font = pingfangRegular(size: 15)
        return view
    }()

    lazy var bigImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        return view
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: WHHScreenW, height: WHHScreenH))
        addSubview(bigImageView)
        addSubview(amaskView)
        amaskView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 50)
        }
        amaskView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        addSubview(sView)

        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        addSubview(loadTitle)
        loadTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(activityIndicatorView.snp.bottom).offset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimation() {
        switch witchId {
        case 1:
            sView.oneLabel.text = "璇玑"
            sView.twoLabel.text = "奇门八字"
            sView.threeLabel.text = "梦幻绿"
            sView.fourLabel.text = "奇门八字，可算你三生因果..."
            sView.tipsLabel.text = "夜观天象，见紫气东来，知有缘人将至，愿以奇门为镜，六爻为引，为君解忧 辨阴阳之机  察得失之道 解宿世之缘  定趋避之法"
            loadTitle.text = "「璇玑」正在帮你获取今日预言..."
        case 2:
            sView.oneLabel.text = "织命"
            sView.twoLabel.text = "星座星象"
            sView.threeLabel.text = "冷夜青"
            sView.fourLabel.text = "让我用魔法球为你照亮前程～"
            sView.tipsLabel.text = "亲爱的，想每天睁开眼就收到来自魔法世界的专属预言吗？让我用魔法球为你提前探路——事业陷阱、桃花方位、财运波动...连你早上该喝咖啡还是红茶都能算准！"
            loadTitle.text = "「织命」正在帮你获取今日预言..."
        default:
            loadTitle.text = "「司夜」正在帮你获取今日预言..."
            sView.oneLabel.text = "司夜"
            sView.twoLabel.text = "未知黑魔法"
            sView.threeLabel.text = "诡异黄"
            sView.fourLabel.text = "啧，又来个听不得真话的小可爱？"
            sView.tipsLabel.text = "愚蠢又可爱的凡人，你每天浑浑噩噩活得像没占卜过的土拨鼠吗？查看我的「厄运预警日报」，至少能让你在踩狗屎前摆出优雅姿势——当然，查看后依然会踩，但我会教你怎么用狗屎施咒反杀。"
        }
        bigImageView.frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        sView.didCancleButtonBlock = { [weak self] in
            self?.removeFromSuperview()
        }
        sView.didSubmitButtonBlock = { [weak self] in

            self?.startRequestAction()
        }
    }

    private func showLoad(isShow: Bool) {
        loadTitle.isHidden = isShow
        activityIndicatorView.isHidden = isShow
        if isShow {
            activityIndicatorView.startAnimating()
        }
    }

    private func startRequestAction() {
        showLoad(isShow: false)
        // 开始请求
        FortuneRequestManager.shared.startRequest(witchId: witchId) { [weak self] success, message in
            if success {
                self?.showLoad(isShow: true)
                self?.jumpyuYan()
                self?.removeFromSuperview()
                print("接口返回有内容，停止请求，message: \(message)")
            } else {
                print("请求失败或超时，message: \(message)")
            }
        }
    }

    func startTimer() {
        count = 10
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func updateTimer() {
        count -= 1
        if count <= 0 {
            stopTimer()
            WHHHUD.whhShowInfoText(text: "生成失败，重新选择")
            dismessView()
        }
    }

    deinit {
        // 记得销毁定时器
        timer?.invalidate()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func dismessView() {
        removeFromSuperview()
    }

    private func requestss() {
        WHHHomeRequestViewModel.getCreateAppUserWitchCreateFortune(witchId: witchId) { [weak self] code, data, msg in
            if code == 1 {
                if data.fortune.suggestion.isEmpty == false {
                    self?.stopTimer()
                    self?.jumpyuYan()
                    self?.removeFromSuperview()
                } else {
                    WHHHUD.whhShowInfoText(text: msg)
                }

            } else {
                WHHHUD.whhShowInfoText(text: msg)
                self?.stopTimer()
                self?.dismessView()
            }
        }
    }

    private func jumpyuYan() {
        if let currentVC = UIViewController.currentViewController() {
            let detailVC = WHHHomeSubscribedDetailViewController()
            detailVC.witchId = witchId
            currentVC.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

//    func loadWrid() {
//
//        WHHHUD.whhShowLoadView()
//        WHHHomeRequestViewModel.whhHomeGetWHHHomeappUserWitchGetFortuneRequest(witchId: 1) { [weak self] success, dataModel, _ in
//            WHHHUD.whhHidenLoadView()
//            if success == 1, dataModel.fortune.items.isEmpty == false {
//                let detailVC = WHHHomeSubscribedDetailViewController()
//                self?.navigationController?.pushViewController(detailVC, animated: true)
//            } else {
//                let divinationVC = WHHDivinationViewController()
//                self?.navigationController?.pushViewController(divinationVC, animated: true)
//            }
//        }
//
//    }
}
