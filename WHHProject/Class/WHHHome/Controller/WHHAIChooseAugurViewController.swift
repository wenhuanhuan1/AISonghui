//
//  WHHAIChooseAugurViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import UIKit

class WHHAIChooseAugurViewController: WHHBaseViewController {
    lazy var augurView: WHHAIAugurView = {
        let view = WHHAIAugurView(type: .zhiming)
        view.didWHHAIAugurViewButtonBlock = { [weak self] in

            self?.amplificationAnimation(type: .zhiming)
        }
        return view
    }()

    lazy var augurView1: WHHAIAugurView = {
        let view = WHHAIAugurView(type: .xuanji)
        view.didWHHAIAugurViewButtonBlock = { [weak self] in

            self?.amplificationAnimation(type: .xuanji)
        }
        return view
    }()

    lazy var augurView2: WHHAIAugurView = {
        let view = WHHAIAugurView(type: .siye)
        view.didWHHAIAugurViewButtonBlock = { [weak self] in

            self?.amplificationAnimation(type: .siye)
        }
        return view
    }()

    lazy var witchArray: [WHHHomeWitchModel] = {
        let a = [WHHHomeWitchModel]()
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        isPopOnGesture = false
        gk_navTitle = "选择占卜师"
        gk_navTitleColor = .black
        gk_backStyle = .black
        view.addSubview(augurView)
        augurView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 10)
        }
        view.addSubview(augurView1)
        augurView1.snp.makeConstraints { make in
            make.left.right.height.equalTo(augurView)
            make.top.equalTo(augurView.snp.bottom).offset(10)
        }
        view.addSubview(augurView2)
        augurView2.snp.makeConstraints { make in
            make.left.right.height.equalTo(augurView1)
            make.top.equalTo(augurView1.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe)
        }
        GetWitchList()
    }

    func GetWitchList() {
        WHHHomeRequestViewModel.whhHomeGetWitchList { [weak self] witchDataArray in
            if witchDataArray.isEmpty == false {
                self?.witchArray = witchDataArray
            }
        }
    }

    private func amplificationAnimation(type: WHHAIAugurViewType) {
        let anView = WHHAIChooseAnimationView()

        if type == .siye {
    
            anView.bigImageView.image = UIImage(named: "司夜-全身")
            anView.witchId = 3
        } else if type == .xuanji {
            anView.bigImageView.image = UIImage(named: "璇玑-全身")
            anView.witchId = 1
        } else if type == .zhiming {
            anView.bigImageView.image = UIImage(named: "织命-全身")
            anView.witchId = 2
        }
        anView.startAnimation()
        view.addSubview(anView)
    }
}
