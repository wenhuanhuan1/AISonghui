//
//  WHHIdetifyDetailViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import KNPhotoBrowser
import UIKit

enum WHHIdetifyDetailViewControllerType {
    case mySelf
    case target
}

class WHHIdetifyDetailViewController: WHHBaseViewController {
    lazy var listTableView: UITableView = {
        let a = UITableView(frame: .zero, style: .plain)
        a.backgroundColor = .clear
        a.delegate = self
        a.dataSource = self
        a.separatorStyle = .none
        a.register(UINib(nibName: "WHHIDetailOneTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHIDetailOneTableViewCell")
        a.register(UINib(nibName: "WHHIDetailTwoTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHIDetailTwoTableViewCell")
        return a
    }()

    var didDeleteButtonClickBlock: ((String) -> Void)?

    lazy var shareButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("分享画廊", for: .normal)
        a.backgroundColor = .white
        a.layer.cornerRadius = 20
        a.titleLabel?.font = pingfangMedium(size: 14)
        a.setTitleColor(Color0F0F12, for: .normal)
        a.addTarget(self, action: #selector(sharButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var saveButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("保存", for: .normal)
        a.backgroundColor = .white
        a.layer.cornerRadius = 20
        a.titleLabel?.font = pingfangMedium(size: 14)
        a.setTitleColor(Color0F0F12, for: .normal)
        a.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var moreButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "AIDetaiMoreIcon"), for: .normal)
        a.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var leftBackButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage.gk_image(with: "btn_back_white"), for: .normal)
        a.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var avatarIcon: WHHBaseImageView = {
        let avatarIcon = WHHBaseImageView()
        avatarIcon.layer.borderWidth = 1
        avatarIcon.layer.borderColor = UIColor.white.cgColor
        avatarIcon.layer.cornerRadius = 16
        avatarIcon.isHidden = true
        avatarIcon.backgroundColor = .red
        return avatarIcon
    }()

    lazy var nickName: UILabel = {
        let a = UILabel()
        a.textColor = .white
        a.font = pingfangSemibold(size: 16)
        a.isHidden = true
        a.text = "Gloria"
        return a
    }()

    private(set) var tempWorksId: String?

    init(worksId: String, type: WHHIdetifyDetailViewControllerType? = .mySelf) {
        super.init(nibName: nil, bundle: nil)
        tempWorksId = worksId
    }

    private(set) var tempType: WHHIdetifyDetailViewControllerType? {
        didSet {
            guard let newType = tempType else { return }

            if newType == .mySelf {
                // 自己
                avatarIcon.isHidden = true
                nickName.isHidden = true
            } else if newType == .target {
                // 对方
                avatarIcon.isHidden = false
                nickName.isHidden = false
            }
        }
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        gk_statusBarStyle = .lightContent
        view.addSubview(leftBackButton)
        leftBackButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(WHHTopSafe)
        }
        view.addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.size.equalTo(32)
            make.centerY.equalTo(leftBackButton)
        }
        view.addSubview(nickName)
        nickName.snp.makeConstraints { make in
            make.centerY.equalTo(avatarIcon)
            make.left.equalTo(avatarIcon.snp.right).offset(12)
        }

        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalToSuperview()
            make.centerY.equalTo(leftBackButton)
        }
        view.addSubview(shareButton)
        view.addSubview(saveButton)
        shareButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 8)
            make.width.equalTo(125)
        }
        saveButton.snp.makeConstraints { make in
            make.left.equalTo(shareButton.snp.right).offset(17)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 8)
        }

        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight)
            make.bottom.equalToSuperview().offset(-WHHNoSafeTabBarHeight - 50)
        }

        requestDetai()
    }

    private(set) var detailModel: WHHIntegralModel? {
        didSet {
            guard let model = detailModel else { return }

            if model.creator.userid == WHHUserInfoManager.shared.userId {
                // 自己
                tempType = .mySelf
            } else {
                // 他人
                tempType = .target
                avatarIcon.whhSetImageView(url: model.logo)
                nickName.text = model.nickname
            }
        }
    }

    private func requestDetai() {
        guard let worksId = tempWorksId else { return }
       

        if tempType == .target {
            
            WHHHUD.whhShowLoadView()
            WHHIdetifyRequestModel.whhGetMyWorksDetailRequest(worksId: worksId) { [weak self] code, model, msg in
                WHHHUD.whhHidenLoadView()
                if code == 1 {
                    self?.detailModel = model
                    self?.listTableView.reloadData()
                } else {
                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: msg)
                    }
                }
            }
        } else {
            WHHHUD.whhShowLoadView()
            WHHIdetifyRequestModel.whhGetWorksDetailRequest(worksId: worksId) { [weak self] code, model, msg in
                WHHHUD.whhHidenLoadView()
                if code == 1 {
                    self?.detailModel = model
                    self?.listTableView.reloadData()
                } else {
                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: msg)
                    }
                }
            }
        }
    }

    @objc func moreButtonClick() {
        if tempType == .mySelf {
            // 删除
            let deleteView = WHHIShareAndDeletAlertView().whhLoadXib()

            deleteView.didShareButtonBlock = { [weak self] in

                self?.didShareDream()
            }

            deleteView.didDeleteButtonBlock = { [weak self] in
                self?.didDeleteDream()
            }
            view.addSubview(deleteView)

        } else {
            // 举报
            let reportView = WHHIdetifyDetailReportView().whhLoadXib()

            reportView.didReportButtonClick = { _ in
            }
            view.addSubview(reportView)
        }
    }

    private func didDeleteDream() {
        if let vc = UIWindow.getKeyWindow {
            let view = WHHIdAlertView().whhLoadXib()
            view.bigTtitleLabel.text = "温馨提示"
            view.desTitle.text = "删除梦境后，不支持恢复\n 请谨慎选择"
            view.didSubmitBtnBlock = { [weak self] display in
                display.closeMethod()
                guard let worksId = self?.tempWorksId else { return }
                WHHHUD.whhShowLoadView()
                WHHIdetifyRequestModel.whhPostWorksDeleteRequest(worksId: worksId) { [weak self] code, msg in
                    WHHHUD.whhHidenLoadView()
                    self?.didDeleteButtonClickBlock?(worksId)
                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: msg)
                    }
                    if code == 1 {
                        dispatchAfter(delay: 0.5) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            vc.addSubview(view)
        }
    }

    private func didShareDream() {
        guard let worksId = tempWorksId else { return }
        WHHHUD.whhShowLoadView()
        WHHIdetifyRequestModel.whhPostWorksShareRequest(worksId: worksId) { [weak self] _, msg in
            WHHHUD.whhHidenLoadView()

            dispatchAfter(delay: 0.5) {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }

    @objc func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }

    @objc func sharButtonClick() {
        guard let worksId = tempWorksId else { return }
        WHHHUD.whhShowLoadView()
        WHHIdetifyRequestModel.whhPostWorksShareRequest(worksId: worksId) { [weak self] _, msg in
            WHHHUD.whhHidenLoadView()

            dispatchAfter(delay: 0.5) {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }

    @objc func saveButtonClick() {
        debugPrint("点击了保存")

        guard let model = detailModel else { return }
        WHHHUD.whhShowLoadView()
        WHHAIImageSaveManager.saveImage(
            with: model.coverUrl
        ) { success, _ in
            WHHHUD.whhHidenLoadView()
            if success {
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: "保存成功")
                }
            } else {
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: "保存失败")
                }
            }
        }
    }
}

extension WHHIdetifyDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return WHHScreenW
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WHHIDetailOneTableViewCell", for: indexPath) as! WHHIDetailOneTableViewCell

            if let model = detailModel {
                cell.iconImageView.whhSetImageView(url: model.coverUrl)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WHHIDetailTwoTableViewCell", for: indexPath) as! WHHIDetailTwoTableViewCell
            if let model = detailModel {
                cell.contentLabel.text = model.prompt
                cell.ipAddressLabel.text = "暂时不知道"
                cell.timerLabel.text = TimeFormatter15.string(from: model.createTime, isMillisecond: true) + "AI生成"
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = detailModel else { return }
        if indexPath.row == 0 {
            let item = KNPhotoItems()
            item.url = model.coverUrl
            let photoBrowser = KNPhotoBrowser()
            photoBrowser.itemsArr = [item]
            photoBrowser.present()
        }
    }
}
