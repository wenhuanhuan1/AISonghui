//
//  WHHHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/18.
//

import GKNavigationBarSwift
import UIKit
class WHHHomeViewController: WHHBaseViewController {
    lazy var homeTableView: UITableView = {
        let homeTableView = UITableView(frame: .zero, style: .plain)
        homeTableView.backgroundColor = .white
        homeTableView.delegate = self
        homeTableView.dataSource = self

        homeTableView.estimatedRowHeight = 0
        homeTableView.estimatedSectionHeaderHeight = 0
        homeTableView.estimatedSectionFooterHeight = 0

        homeTableView.separatorStyle = .none
        homeTableView.register(WHHHomeNoSubscriptionCell.self, forCellReuseIdentifier: "WHHHomeNoSubscriptionCell")
        homeTableView.register(WHHHomeWitchTableViewCell.self, forCellReuseIdentifier: "WHHHomeWitchTableViewCell")
        homeTableView.register(UINib(nibName: "WHHHomeSubscribedTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHHomeSubscribedTableViewCell")
        homeTableView.register(UINib(nibName: "HomeVideoOrPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeVideoOrPhotoTableViewCell")
        homeTableView.register(UINib(nibName: "HomeABBTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeABBTableViewCell")
        homeTableView.isScrollEnabled = false
//        homeTableView.whhAddRefreshNormalHeader { [weak self] in
//            self?.whhRefreshFooter()
//        }
        return homeTableView
    }()

    lazy var userAvIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()

    lazy var bannerDataArray: [WHHSystemModel] = {
        let view = [WHHSystemModel]()
        return view
    }()

    private(set) var isSubscribed = false

    lazy var gradualView: WHHGradualView = {
        let gradualView = WHHGradualView()
        gradualView.didActionButtonClick = { [weak self] in
            let divinationVC = WHHDivinationViewController()
            self?.navigationController?.pushViewController(divinationVC, animated: true)
        }
        return gradualView
    }()

    lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return rightButton
    }()

    lazy var dataArray: [WHHHomeWitchModel] = {
        let dataArray = [WHHHomeWitchModel]()
        return dataArray
    }()

    lazy var todayTitle: UILabel = {
        let todayTitle = UILabel()
        todayTitle.text = "whhHomeTodayKey".localized
        todayTitle.font = pingfangSemibold(size: 28)
        todayTitle.textColor = Color121212
        todayTitle.numberOfLines = 0
        return todayTitle
    }()

    lazy var dateTitle: UILabel = {
        let dateTitle = UILabel()
        dateTitle.text = "7月3日 周三"
        dateTitle.font = pingfangSemibold(size: 20)
        dateTitle.textColor = Color89898D
        dateTitle.numberOfLines = 0
        return dateTitle
    }()

    lazy var topBgImageView: WHHBaseImageView = {
        let topBgImageView = WHHBaseImageView()
        topBgImageView.image = UIImage(named: "whhHomeTopBgIcon")
        return topBgImageView
    }()

    private(set) var foretellModel = WHHHomeForetellModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        gk_navigationBar.isHidden = true

        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-WHHBottomSafe)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight)
        }

        view.addSubview(userAvIcon)
        userAvIcon.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(WHHTopSafe)
        }
        userAvIcon.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(todayTitle)
        todayTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(rightButton)
        }
        view.addSubview(dateTitle)
        dateTitle.snp.makeConstraints { make in
            make.left.equalTo(todayTitle.snp.right).offset(5)
            make.bottom.equalTo(todayTitle)
        }
        dateTitle.text = String.getCurrentDateString()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        whhRefreshFooter()
        getUserInfo()
    }

    private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            if code == 1 {
                if model.logo.isEmpty {
                    self?.userAvIcon.image = UIImage(named: "whhAbbBigAvatar")
                } else {
                    self?.userAvIcon.whhSetImageView(url: model.logo)
                   
                }

            } else {
                self?.userAvIcon.image = UIImage(named: "whhAbbBigAvatar")
            }
        }
    }

    override func whhRefreshFooter() {
        super.whhRefreshFooter()

        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.getSysIndexBannerConfig { [weak self] model, _, code in
            WHHHUD.whhHidenLoadView()
            self?.homeTableView.mj_header?.endRefreshing()
            if code {
                self?.bannerDataArray = model
                self?.homeTableView.reloadData()
            }
        }
    }

    @objc func rightButtonClick() {
        debugPrint("点击了右边的按钮")

        let personVC = WHHPersonageViewController()

        navigationController?.pushViewController(personVC, animated: true)
    }

    private func jumpABBWitch(array: [WHHHomeWitchModel]) {
        if let model = array.first(where: { $0.wichId == "2" }) {
            if WHHUserInfoManager.shared.userModel.vip > 0 {
                let abbHomeVC = WHHABBChatViewController()
                abbHomeVC.model = model
                navigationController?.pushViewController(abbHomeVC, animated: true)
            } else {
                jumpVIPController {
                    debugPrint("支付成功")
                }
            }
        }
    }
    
    private func returnCellSacalHeight() -> CGFloat {

        debugPrint("当前的高\(WHHScreenH)")
        switch WHHScreenH {
        case 852,932,874,956,844:
            return 330
        case 896:
            return 320
        default:
            return 390
        }
        
        
    }
}

extension WHHHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return bannerDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoOrPhotoTableViewCell", for: indexPath) as! HomeVideoOrPhotoTableViewCell
            cell.cellModel = bannerDataArray[indexPath.section]
            return cell

//            if isSubscribed {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "WHHHomeSubscribedTableViewCell", for: indexPath) as! WHHHomeSubscribedTableViewCell
//                cell.cellModel = foretellModel
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "WHHHomeNoSubscriptionCell", for: indexPath) as! WHHHomeNoSubscriptionCell
//
//                return cell
//            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeABBTableViewCell", for: indexPath) as! HomeABBTableViewCell
            cell.cellModel = bannerDataArray[indexPath.section]
//            let cell = tableView.dequeueReusableCell(withIdentifier: "WHHHomeWitchTableViewCell", for: indexPath) as! WHHHomeWitchTableViewCell
//            cell.dataArray = dataArray
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (WHHScreenW - 32) * 474 / returnCellSacalHeight()

        } else {
            return (WHHScreenW - 32) * 174 / 339
        }

//        if indexPath.row == 0 {
//            if isSubscribed {
//                return (WHHAllNavBarHeight + 14) + ((WHHScreenW - 40) * 325 / 335)
//
//            } else {
//                return WHHScreenW * 353 / 375
//            }
//
//        } else if indexPath.row == 1 {
//            return (WHHScreenW - 16) * 413 / 360
//        } else {
//            return .zero
//        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            WHHHUD.whhShowLoadView()
            WHHHomeRequestViewModel.whhHomeGetWitchList { [weak self] witchDataArray in
                WHHHUD.whhHidenLoadView()
                if witchDataArray.isEmpty == false {
                    self?.jumpABBWitch(array: witchDataArray)
                }
            }

        } else {
            WHHHUD.whhShowLoadView()
            WHHHomeRequestViewModel.whhHomeGetWHHHomeappUserWitchGetFortuneRequest { [weak self] success, dataModel, _ in
                WHHHUD.whhHidenLoadView()
                if success == 1, dataModel.fortune.items.isEmpty == false {
                    let detailVC = WHHHomeSubscribedDetailViewController()
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                } else {
                    let divinationVC = WHHDivinationViewController()
                    self?.navigationController?.pushViewController(divinationVC, animated: true)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return .zero
        }
        
    }
}
