//
//  WHHABBChatViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/8.
//

import UIKit

class WHHABBChatViewController: WHHBaseViewController {
    lazy var chatTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.rowHeight = UITableView.automaticDimension
        view.register(WHHABBChatTableViewCell.self, forCellReuseIdentifier: "WHHABBChatTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTabViewTapGestureRecognizerHidenOtherView(aTap:)))
        view.addGestureRecognizer(tap)
        return view
    }()

    lazy var chatInputView: WHHChatInputView = {
        let view = WHHChatInputView()
        view.didSendMessageBlock = { [weak self] showView, message in
            self?.didSendMessageWithRequest(message: message, inpputView: showView)
        }
        return view
    }()

    lazy var dataArray: [WHHChatMesageModel] = {
        let view = [WHHChatMesageModel]()
        return view
    }()

    lazy var bgView: WHHBaseView = {
        let view = WHHBaseView()
        view.backgroundColor = .white
        return view
    }()

    lazy var tableViewBgIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.image = UIImage(named: "whhAbbChatBgIcon")
        return view
    }()

    lazy var witchIcon: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    lazy var witchName: WHHLabel = {
        let view = WHHLabel()
        view.whhSetLabel(textContent: "", color: .white, numberLine: 0, textFont: pingfangRegular(size: 12)!, textContentAlignment: .left)
        return view
    }()

    var model: WHHHomeWitchModel?

    lazy var rightButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setBackgroundImage(UIImage(named: "whhSubscriptionButtonIcon"), for: .normal)
        view.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return view
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bgView.whhAddSetRectConrner(corner: [.topLeft, .topRight], radile: 20)
    }

    deinit {
        // 移除通知监听以避免内存泄漏
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加键盘显示通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // 添加键盘隐藏通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.backgroundColor = Color746CF7
        gk_navTitle = ""
        gk_navRightBarButtonItem = UIBarButtonItem(customView: rightButton)

        view.addSubview(witchIcon)
        witchIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(WHHTopSafe + 11)
            make.size.equalTo(20)
        }
        view.addSubview(witchName)
        witchName.snp.makeConstraints { make in
            make.left.equalTo(witchIcon.snp.right).offset(5)
            make.centerY.equalTo(witchIcon)
        }

        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight)
        }
        bgView.addSubview(tableViewBgIcon)
        tableViewBgIcon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        bgView.addSubview(chatInputView)
        chatInputView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(chatTableView.snp.bottom)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe)
        }

        if let tempModel = model {
            witchIcon.whhSetImageView(url: tempModel.icon)
            witchName.text = tempModel.name
        }
    }

    @objc func didTabViewTapGestureRecognizerHidenOtherView(aTap: UITapGestureRecognizer) {
        if aTap.state == .ended {
            view.endEditing(true)
            dispatchAfter(delay: 0.05) { [weak self] in
                self?.scrollToBottomRow()
            }
        }
    }

    // MARK: - Notification Methods

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.25) {
                self.chatInputView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-keyboardHeight)
                }
            } completion: { finish in

                if finish {
                    self.scrollToBottomRow()
                }
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        print("键盘已隐藏")

        UIView.animate(withDuration: 0.25) {
            self.chatInputView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-WHHBottomSafe)
            }
        }
    }

    @objc func rightButtonClick() {
        view.endEditing(true)
        let alertView = WHHABBSubscriptionAlertView()
        alertView.didSubscriptionSubmitButtonClickBlock = { [weak self] model, displayView in

            if model.subscribed == false {
                let subscriptAlertView = WHHDivinationAlertView()
                // 去订阅
                if WHHUserInfoManager.shared.userModel.vip == 1 {
                    subscriptAlertView.type = .subscription
                } else {
                    subscriptAlertView.type = .privilege
                }
                subscriptAlertView.smallTitleLabel.text = "是否订阅" + model.name + "女巫" + "「\(model.predictionName)」" + "，订阅后成功后，每天准点获取推送"
                subscriptAlertView.didCancleSubscriptionBlock = { [weak self] in
                    self?.whhSubscriptionRequest()
                    displayView.backButtonClick()
                }
                self?.view.addSubview(subscriptAlertView)
            }
        }
        alertView.model = model
        view.addSubview(alertView)
    }

    private func whhSubscriptionRequest() {
        guard let newSelectModel = model else { return }
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhSubscriptionRequest(witchId: newSelectModel.wichId) { [weak self] success, msg in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                if newSelectModel.subscribed {
                    newSelectModel.subscribed = false
                } else {
                    newSelectModel.subscribed = true
                }
                self?.model = newSelectModel
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }

            } else {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }

    /// 滚动到最底部
    private func scrollToBottomRow() {
        var toRow = -1

        if dataArray.count > 0 {
            toRow = dataArray.count - 1
            let toIndexPath = IndexPath(row: toRow, section: 0)
            chatTableView.scrollToRow(at: toIndexPath, at: .bottom, animated: true)
        }
    }

    /// 发送请求
    private func didSendMessageWithRequest(message: String, inpputView: WHHChatInputView) {
        createSendMessageBody(msg: message)
        WHHHUD.whhShowLoadView()
        WHHABBChatRequestApiViewModel.whhAbbChatSendMessageRequestApi(inputText: message) { [weak self] success, msg in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                self?.createReceiveMessageBody(msg: msg)
            } else {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }

    /// 创建发送方的消息体
    /// - Parameter msg: 消息
    private func createSendMessageBody(msg: String) {
        let sendModel = WHHChatMesageModel()
        sendModel.messageDirection = .send
        sendModel.icon = WHHUserInfoManager.shared.userModel.logo
        sendModel.chatContent = msg
        dataArray.append(sendModel)
        onMainThread { [weak self] in
            self?.reloadTableViewData()
        }
    }

    private func createReceiveMessageBody(msg: String) {
        if let newModel = model {
            let sendModel = WHHChatMesageModel()
            sendModel.messageDirection = .receive
            sendModel.icon = newModel.icon
            sendModel.chatContent = msg
            dataArray.append(sendModel)
            onMainThread { [weak self] in
                self?.reloadTableViewData()
            }
        }
    }

    private func reloadTableViewData() {
        chatTableView.reloadData()
        chatTableView.setNeedsLayout()
        chatTableView.layoutIfNeeded()
        dispatchAfter(delay: 0.25) { [weak self] in
            self?.scrollToBottomRow()
        }
    }
}

extension WHHABBChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHABBChatTableViewCell", for: indexPath) as! WHHABBChatTableViewCell
        let model = dataArray[indexPath.row]
        cell.cellModel = model
        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
