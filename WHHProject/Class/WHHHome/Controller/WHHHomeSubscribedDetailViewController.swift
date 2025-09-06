//
//  WHHHomeSubscribedDetailViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/30.
//

import UIKit

class WHHHomeSubscribedDetailViewController: WHHBaseViewController {
    lazy var amendmentButton: WHHGradientButton = {
        let amendmentButton = WHHGradientButton(type: .custom)
        amendmentButton.setTitle("whhAmendmentButtonTitleKey".localized, for: .normal)
        amendmentButton.titleLabel?.font = pingfangRegular(size: 14)
        amendmentButton.layer.cornerRadius = 22
        amendmentButton.layer.masksToBounds = true
        amendmentButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        amendmentButton.setTitleColor(.white, for: .normal)
        return amendmentButton

    }()

    lazy var homeTableView: UITableView = {
        let homeTableView = UITableView(frame: .zero, style: .grouped)
        homeTableView.backgroundColor = .clear
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.separatorStyle = .none
        homeTableView.tableHeaderView = whhHomeSubscribedDetailHeaderView()
        homeTableView.tableFooterView = getFootView()
        homeTableView.whhSetTableViewDefault()
        homeTableView.register(UINib(nibName: "WHHHomeSubscribedDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHHomeSubscribedDetailTableViewCell")
        return homeTableView
    }()

    lazy var upRightButton: UIButton = {
        let upRightButton = UIButton(type: .custom)

        upRightButton.setTitle("whhPackUpKey".localized, for: .normal)
        upRightButton.setTitle("whhUnfoldKey".localized, for: .selected)
        upRightButton.setTitleColor(.white, for: .normal)

        upRightButton.setImage(UIImage(named: "whhPackUpIcon"), for: .normal)
        upRightButton.setImage(UIImage(named: "whhUnfoldIcon"), for: .selected)
        upRightButton.titleLabel?.font = pingfangRegular(size: 14)
        upRightButton.addTarget(self, action: #selector(upRightButtonClick), for: .touchUpInside)
        return upRightButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorF0F1F5
        gk_navBackgroundColor = .clear
        gk_navTitle = "whhHomeSubscribedDetailNavTitleKey".localized
        gk_navRightBarButtonItem = UIBarButtonItem(customView: upRightButton)
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        whhRefreshHeader()
    }

    override func whhRefreshHeader() {
        super.whhRefreshHeader()

        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhHomeGetWHHHomeappUserWitchGetFortuneRequest { [weak self] success, dataModel, _ in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                self?.foretellModel = dataModel
                self?.homeTableView.reloadData()
            }
        }
    }

    private var foretellModel = WHHHomeForetellModel()

    @objc func upRightButtonClick() {
    }

    private func whhHomeSubscribedDetailHeaderView() -> UIView {
        let headerView = UIView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenW * 308 / 375))
        let headerIcon = UIImageView(image: UIImage(named: "whhDeDetailTopBgIcon"))
        headerView.addSubview(headerIcon)
        headerIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let contBgIcon = UIImageView(image: UIImage(named: "whhContentBgICon"))
        headerView.addSubview(contBgIcon)
        contBgIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo((WHHScreenW - 40) * 86 / 335)
            make.bottom.equalToSuperview().offset(-20)
        }

        let leftView = UIView()
        leftView.backgroundColor = .white
        leftView.layer.cornerRadius = 10
        leftView.layer.masksToBounds = true
        leftView.layer.borderWidth = 1
        leftView.layer.borderColor = Color4F48CF.cgColor
        contBgIcon.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(70)
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        let gradeLabel = UILabel()

        let att = NSMutableAttributedString(string: "62", attributes: [.foregroundColor: Color746CF7, .font: pingfangSemibold(size: 32)!])
        let att1 = NSAttributedString(string: "/100", attributes: [.foregroundColor: Color6A6A6B, .font: pingfangRegular(size: 18)!])
        att.append(att1)
        gradeLabel.attributedText = att

        leftView.addSubview(gradeLabel)
        gradeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }

        let tipsLabel = UILabel()
        tipsLabel.text = "今日运势分/总分"
        tipsLabel.textAlignment = .center
        tipsLabel.font = pingfangRegular(size: 8)
        tipsLabel.textColor = Color6A6A6B
        leftView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }

        let contentLabel = UILabel()
        contentLabel.text = "“不算最糟，但也别指望天上掉馅饼—如果真掉了，大概率是过期馅的。”"
        contentLabel.numberOfLines = 0
        contentLabel.font = pingfangRegular(size: 12)
        contentLabel.textColor = Color2C2B2D
        contBgIcon.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(leftView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(leftView)
        }

        return headerView
    }

    private func getFootView() -> UIView {
        let footerView = UIView(frame: CGRectMake(0, 0, WHHScreenW, 200))
        footerView.addSubview(amendmentButton)
        amendmentButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(30)
        }

        let tipsLabel = UILabel()
        tipsLabel.text = "whhAmendmentTipsTitleKey".localized
        tipsLabel.textAlignment = .center
        tipsLabel.numberOfLines = 0
        tipsLabel.font = pingfangRegular(size: 10)
        tipsLabel.textColor = Color2C2B2D
        footerView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.centerX.equalToSuperview()
            make.top.equalTo(amendmentButton.snp.bottom).offset(8)
        }

        let chooseWitchView = UIView()
        chooseWitchView.layer.cornerRadius = 15
        chooseWitchView.layer.masksToBounds = true
        chooseWitchView.layer.borderWidth = 1
        chooseWitchView.layer.borderColor = Color746CF7.cgColor

        footerView.addSubview(chooseWitchView)
        chooseWitchView.snp.makeConstraints { make in
            make.width.equalTo(104)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        let witchIcon = UIImageView(image: UIImage(named: "whhButtonWitchIcon"))
        chooseWitchView.addSubview(witchIcon)
        witchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        let title = UILabel()
        title.text = "whhChooseWitchTitleKey".localized
        title.font = pingfangRegular(size: 12)
        title.textColor = Color746CF7
        chooseWitchView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(witchIcon.snp.right).offset(2)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(chooseWitchButtonClick), for: .touchUpInside)
        chooseWitchView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return footerView
    }

    @objc func chooseWitchButtonClick() {
        debugPrint("点击了切换女巫")
    }

    @objc func submitButtonClick() {
        let inputView = WHHInputView()
        view.addSubview(inputView)
    }
}

extension WHHHomeSubscribedDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return foretellModel.fortune.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHHomeSubscribedDetailTableViewCell") as! WHHHomeSubscribedDetailTableViewCell
        cell.cellModel = foretellModel.fortune.items[indexPath.section]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 266
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
