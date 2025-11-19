//
//  WHHPersonageViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHPersonageViewController: WHHBaseViewController {
    lazy var abbIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.backgroundColor = ColorF2F4FE
        view.layer.cornerRadius = 55 / 2
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
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
        editInfoButton.layer.cornerRadius = 18
        editInfoButton.backgroundColor = Color2C2B2D
        editInfoButton.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
        return editInfoButton
    }()

    lazy var homeTableView: UITableView = {
        let homeTableView = UITableView(frame: .zero, style: .grouped)
        homeTableView.backgroundColor = .white
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.separatorStyle = .none
        homeTableView.layer.cornerRadius = 22
        homeTableView.isScrollEnabled = false
       
        homeTableView.register(UINib(nibName: "WHHPersonageTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHPersonageTableViewCell")
        homeTableView.register(UINib(nibName: "WHHPersonageControllTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHPersonageControllTableViewCell")
        homeTableView.register(UINib(nibName: "WHHBuyFinishTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHBuyFinishTableViewCell")
        homeTableView.register(WHHAIPersonVIPCell.self, forCellReuseIdentifier: "WHHAIPersonVIPCell")

        return homeTableView
    }()

    var netModel = FCMineModel()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getUserInfo), name: NSNotification.Name("vipBuyFinish"), object: nil)
        
        gk_navTitle = "资料卡"
        gk_backStyle = .black
        gk_navTitleColor = Color6A6A6B
        view.backgroundColor = ColorF2F4FE
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 77)
            make.bottom.equalToSuperview().offset(30)
        }

        view.addSubview(abbIcon)
        abbIcon.snp.makeConstraints { make in
            make.size.equalTo(55)
            make.left.equalToSuperview().offset(21)
            make.bottom.equalTo(homeTableView.snp.top).offset(-10)
        }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
        
        abbIcon.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        homeTableView.whhAddShadow(ofColor: Color6C73FF, radius: 22, offset: CGSize(width: 0, height: -2), opacity: 0.4)
        homeTableView.layer.cornerRadius = 22
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func editButtonClick() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            WHHHUD.whhHidenLoadView()
            if code == 1 {
                let setView = WHHSetView()
                setView.didFinishBlock = {[weak self] in
                    self?.getUserInfo()
                }
                setView.logoFileId = model.logo
                setView.birthday = model.birthday
                setView.gender = model.gender
                setView.setDefauleData()
                self?.view.addSubview(setView)
            }
        }
    }

    @objc private func getUserInfo() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            WHHHUD.whhHidenLoadView()
            if code == 1 {
                self?.netModel = model
                if model.logo.isEmpty {
                    self?.abbIcon.image = UIImage(named: "whhAbbBigAvatar")
                    
                } else {
                    self?.abbIcon.whhSetImageView(url: model.logo)
                }
            }
        }
    }
}

extension WHHPersonageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "WHHAIPersonVIPCell", for: indexPath) as! WHHAIPersonVIPCell
            if netModel.vip == 1 {
                cell.status.isHidden = true
            }else{
                cell.status.isHidden = false
            }
            cell.lineLabel.text = "命运丝线:" + "\(netModel.luckValueNum)"
           
            return cell
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
            
            return 220

        } else if indexPath.section == 1 {
            return CGFloat(oneSectionArray.count * 52)
        } else {
            return CGFloat(twoSectionArray.count * 52)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let vc = WHHAIDestinyLinesViewController()
            navigationController?.pushViewController(vc, animated: true)
          
        }
    }
}
