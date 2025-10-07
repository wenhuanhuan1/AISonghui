//
//  WHHlogoutAccoutViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import Kingfisher
import UIKit
class WHHlogoutAccoutViewController: WHHBaseViewController {
    lazy var bigIconImageView: AnimatedImageView = {
        let view = AnimatedImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        gk_backStyle = .black
        abbGitBgImageView.addSubview(bigIconImageView)
        bigIconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let path = Bundle.main.path(forResource: "aboutUsAbb", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            bigIconImageView.kf.setImage(with: url)
        }
    }

    @IBOutlet var abbGitBgImageView: UIImageView!
    @IBAction func backButtonCliick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func submitButtonClick(_ sender: UIButton) {
        debugPrint("点击了提交")

        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhMineGetUserDestroyInfo { [weak self] code, model in
            WHHHUD.whhHidenLoadView()
            if code == 1 {
                if model.leftDestroyTimeSeconds == 0 {
                    let alertView = WHHlogoutAccoutAlertView()
                    alertView.type = .beginLogout
                    alertView.didSubmitButtonBlock = { [weak self] _ in

                        self?.beginAccout()
                    }
                    self?.view.addSubview(alertView)
                } else {
                    let alertView = WHHlogoutAccoutAlertView()
                    alertView.remainingTime = model.leftDestroyTimeSeconds
                    alertView.type = .logouting
                    alertView.didSubmitButtonBlock = { [weak self] _ in

                        self?.cancleAccount()
                    }
                    self?.view.addSubview(alertView)
                }
            }
        }
    }

    private func beginAccout() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhMineWriteOffAccoutRequest { code, _ in
            WHHHUD.whhHidenLoadView()
            if code == 1 {
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: "申请注销完成")
                }
            }
        }
    }

    private func cancleAccount() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhMineCancleUserDestroyInfo { _, msg in
            WHHHUD.whhHidenLoadView()
            dispatchAfter(delay: 0.5) {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }
}
