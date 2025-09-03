//
//  WHHPersonageViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHPersonageViewController: WHHBaseViewController {
    lazy var abbIcon: WHHBaseImageView = {
        let abbIcon = WHHBaseImageView()
        abbIcon.image = UIImage(named: "whhSetDefaultIcon")
        return abbIcon
    }()

    lazy var oneSectionArray: [[String: Any]] = {
        let oneSectionArray = [["isHiddenLine": false, "leftIconString": "whhContactUsIcon", "leftTitleString": "联系我们"],
                               ["isHiddenLine": false, "leftIconString": "whhRecoverBuyIcon", "leftTitleString": "恢复购买"], ["isHiddenLine": true, "leftIconString": "whhAboutABBIcon", "leftTitleString": "关于阿贝贝"]]
        return oneSectionArray
    }()

    lazy var twoSectionArray: [[String: Any]] = {
        let twoSectionArray = [["isHiddenLine": true, "leftIconString": "whhGoodCommentIcon", "leftTitleString": "给阿贝贝一个好评"]]
        return twoSectionArray
    }()

    lazy var editInfoButton: UIButton = {
        let editInfoButton = UIButton(type: .custom)
        editInfoButton.setTitle("设置资料", for: .normal)
        editInfoButton.setTitleColor(.white, for: .normal)
        editInfoButton.titleLabel?.font = pingfangMedium(size: 12)
        editInfoButton.setImage(UIImage(named: "whhEditIcon"), for: .normal)
        editInfoButton.layer.cornerRadius = 18
        editInfoButton.backgroundColor = Color2C2B2D
        editInfoButton.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
        return editInfoButton
    }()

    lazy var homeTableView: UITableView = {
        let homeTableView = UITableView(frame: .zero, style: .grouped)
        homeTableView.backgroundColor = .white
//        homeTableView.whhSetTableViewDefault()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.separatorStyle = .none
        homeTableView.layer.cornerRadius = 22
        homeTableView.isScrollEnabled = false
        
        homeTableView.register(UINib(nibName: "WHHPersonageTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHPersonageTableViewCell")
        homeTableView.register(UINib(nibName: "WHHPersonageControllTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHPersonageControllTableViewCell")
        homeTableView.register(UINib(nibName: "WHHBuyFinishTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHBuyFinishTableViewCell")

        return homeTableView
    }()
    
    
    var netModel = FCMineModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = "资料卡"
        view.backgroundColor = ColorF2F4FE
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 77)
            make.bottom.equalToSuperview()
        }

        view.addSubview(abbIcon)
        abbIcon.snp.makeConstraints { make in
            make.size.equalTo(55)
            make.left.equalToSuperview().offset(21)
            make.bottom.equalTo(homeTableView.snp.top).offset(-10)
        }

        view.addSubview(editInfoButton)
        editInfoButton.snp.makeConstraints { make in
            make.centerY.equalTo(abbIcon)
            make.width.equalTo(100)
            make.height.equalTo(36)
            make.right.equalToSuperview().offset(-13)
        }
        getUserInfo()
    }

    @objc func editButtonClick() {
        
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest {[weak self] code, model in
            WHHHUD.whhHidenLoadView()
            if code == 1 {
                
                let setView = WHHSetView()
                setView.logoFileId = model.logo
                setView.birthday = model.birthday
                setView.gender = model.gender
                self?.view.addSubview(setView)
            }
        }
        
        
    }
    
    private func getUserInfo() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest {[weak self] code, model in
            WHHHUD.whhHidenLoadView()
            if code == 1 {
                self?.netModel = model
                self?.abbIcon.whhSetImageView(url: model.logo)
            }
        }
    }
}

extension WHHPersonageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if netModel.vip == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WHHBuyFinishTableViewCell", for: indexPath) as! WHHBuyFinishTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WHHPersonageTableViewCell", for: indexPath) as! WHHPersonageTableViewCell
                return cell
            }

        } else {
            let cell: WHHPersonageControllTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WHHPersonageControllTableViewCell") as! WHHPersonageControllTableViewCell

            if indexPath.section == 1 {
                cell.dataArray = oneSectionArray
            } else {
                cell.dataArray = twoSectionArray
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if netModel.vip == 1 {
                return 20
            }
            return 15
        } else {
            return 15
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if netModel.vip == 1 {
                return (WHHScreenW - 40) * 54 / 355
            } else {
                return (WHHScreenW - 40) * 152 / 355
            }

        } else if indexPath.section == 1 {
            return CGFloat(oneSectionArray.count * 52)
        } else {
            return CGFloat(twoSectionArray.count * 52)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            jumpVIPController {
                debugPrint("支付了")
            }
        }
    }
}
