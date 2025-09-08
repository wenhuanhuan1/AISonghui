//
//  WHHHomeSubscribedDetailViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/30.
//

import UIKit


class WHHOldOrNewForetellView: WHHBaseView {
    
    var didButtonClickBlock:((WHHOldOrNewForetellView,Bool)->Void)?
    
    lazy var title: WHHLabel = {
        let view = WHHLabel()
        view.text = "预言(旧)"
        view.textColor = Color6A6A6B
        view.font = pingfangRegular(size: 14)
        return view
    }()
    
    lazy var button: UIButton = {
        let view = UIButton(type: .custom)
        view.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        whhAddSetRectConrner(corner: [.topRight,.bottomRight], radile: 10)
    }
    
    @objc func didButtonClick(btn:UIButton)  {
        btn.isSelected = !btn.isSelected
        didButtonClickBlock?(self,btn.isSelected)
    }
}

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
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none

        view.whhSetTableViewDefault()
        view.register(UINib(nibName: "WHHHomeSubscribedDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHHomeSubscribedDetailTableViewCell")
        view.whhAddRefreshNormalHeader {[weak self] in
            self?.whhRefreshHeader()
        }
        return view
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
//        gk_navRightBarButtonItem = UIBarButtonItem(customView: upRightButton)
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
            self?.homeTableView.mj_header?.endRefreshing()
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                self?.foretellModel = dataModel
                self?.homeTableView.tableHeaderView = self?.whhHomeSubscribedDetailHeaderView()
                self?.homeTableView.tableFooterView = self?.getFootView()
                self?.homeTableView.reloadData()
            }
        }
    }
    
    private func getOldFortuneRequest() {
        
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhHomeGetWHHHomeappUserWitchGetOldFortuneRequest { [weak self] success, dataModel, _ in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                self?.foretellModel = dataModel
                self?.homeTableView.tableHeaderView = self?.whhHomeSubscribedDetailHeaderView()
                self?.homeTableView.tableFooterView = self?.getFootView()
                self?.homeTableView.reloadData()
            }
        }
        
    }

    private var foretellModel = WHHHomeForetellModel()

    @objc func upRightButtonClick() {
    }
    
    private func requestOldOrNewRrediction(view:WHHOldOrNewForetellView,isStatus:Bool)
    {
        
        if isStatus{
            // 请求旧的
            view.title.text = "预言(旧)"
            view.title.textColor = Color6A6A6B
            view.backgroundColor = ColorE0E0E0
            getOldFortuneRequest()
            
        }else{
            // 新的
            view.title.text = "预言(新)"
            view.title.textColor = ColorDAAE4D
            view.backgroundColor = ColorFEF5E6
            view.layer.borderWidth = 1
            view.layer.borderColor = ColorDAAE4D.cgColor
            whhRefreshHeader()
        }
        
    }

    private func whhHomeSubscribedDetailHeaderView() -> UIView {
        
        
        let headerView = UIView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenW * 308 / 375))
        let headerIcon = UIImageView(image: UIImage(named: "whhDeDetailTopBgIcon"))
        headerView.addSubview(headerIcon)
        headerIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        
        let switchButton = WHHOldOrNewForetellView()
        switchButton.isHidden = true
        switchButton.title.text = "预言(新)"
        switchButton.title.textColor = ColorDAAE4D
        switchButton.backgroundColor = ColorFEF5E6
        switchButton.layer.borderWidth = 1
        switchButton.layer.borderColor = ColorDAAE4D.cgColor
        switchButton.didButtonClickBlock = {[weak self] view,status in
            
            self?.requestOldOrNewRrediction(view: view, isStatus: status)
        }
        headerView.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        if foretellModel.hasOldFortune == 1 {
            switchButton.isHidden = false
        }else{
            switchButton.isHidden = true
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

        let att = NSMutableAttributedString(string: foretellModel.fortune.avgScore, attributes: [.foregroundColor: Color746CF7, .font: pingfangSemibold(size: 32)!])
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
        contentLabel.text = foretellModel.fortune.suggestion
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
        amendmentButton.isHidden = true
        amendmentButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(30)
        }

        let tipsLabel = UILabel()
        tipsLabel.isHidden = true
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
        chooseWitchView.isHidden = true
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
        if foretellModel.hasOldFortune == 1 {
            // 有旧的预言
            chooseWitchView.isHidden = false
            amendmentButton.isHidden = true
            tipsLabel.isHidden = true
        } else {
            chooseWitchView.isHidden = true
            amendmentButton.isHidden = false
            tipsLabel.isHidden = false
        }

        return footerView
    }

    @objc func chooseWitchButtonClick() {
        debugPrint("点击了切换女巫")
        let divinationVC = WHHDivinationViewController()
        navigationController?.pushViewController(divinationVC, animated: true)
    }

    @objc func submitButtonClick() {
        let inputView = WHHInputView()
        inputView.changeFinishBlock = {[weak self] displayView in
            self?.whhRefreshHeader()
            displayView.closeButtonClick()
        }
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
