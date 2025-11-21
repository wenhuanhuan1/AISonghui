//
//  WHHAIChatViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/7.
//

import UIKit

class WHHAIChatViewController: WHHBaseViewController {
    var conversationId = ""

    private var currentStreamedText: String = ""

    private(set) var lastId = ""

    lazy var rightButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "recordaww"), for: .normal)
        a.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var dataArray: [WHHChatMesageModel] = {
        let view = [WHHChatMesageModel]()
        return view
    }()

    lazy var chatInputView: WHHChatInputView = {
        let view = WHHChatInputView()
        view.didSendMessageBlock = { [weak self] showView, message in
            self?.didSendMessageWithRequest(message: message, inpputView: showView)
        }
        return view
    }()

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
        view.whhAddRefreshNormalHeader { [weak self] in
            self?.getChatListHeaderRequest()
        }
        view.whhAddRefreshNormalFooter { [weak self] in
            self?.getChatListFooterRequest()
        }
        view.mj_footer?.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        stayle = .darkContent
        gk_backStyle = .black
        gk_navTitle = ""
        gk_navRightBarButtonItem = UIBarButtonItem(customView: rightButton)
        // 添加键盘显示通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // 添加键盘隐藏通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.addSubview(chatTableView)
        chatTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight)
        }
        view.addSubview(chatInputView)
        chatInputView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(chatTableView.snp.bottom)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe)
        }
        getChatListFooterRequest()
    }

    private func getChatListHeaderRequest() {
        WHHHomeRequestViewModel.getChatMessageRequest(conversationId: conversationId, lastId: lastId, swipeUp: false) { [weak self] code, listArray, _ in
            self?.chatTableView.mj_header?.endRefreshing()
            if code == 1 {
                self?.getMessageHistory(netmMsgArray: listArray)
                if let firstModel = self?.dataArray.first {
                    self?.lastId = firstModel.messageId
                }
            }
        }
    }

    /// 获取历史记录
    /// - Parameter dataArray: 数据
    private func getMessageHistory(netmMsgArray: [WHHChatMesageModel]) {
        // 1. 计算插入前的 contentSize 高度
        let beforeHeight = chatTableView.contentSize.height

        dataArray.insert(contentsOf: netmMsgArray, at: 0)

        // 重新加载
        chatTableView.reloadData()
        chatTableView.layoutIfNeeded()
        // 4. 计算插入后的 contentSize 高度
        let afterHeight = chatTableView.contentSize.height

        // 5. 偏移差值 = 新旧高度差，使位置不跳动
        let heightDiff = afterHeight - beforeHeight

        chatTableView.contentOffset.y += heightDiff
    }

    private func getChatListFooterRequest() {
        WHHHomeRequestViewModel.getChatMessageRequest(conversationId: conversationId, lastId: "", swipeUp: true) { [weak self] code, listArray, _ in
            self?.chatTableView.mj_footer?.endRefreshing()
            if code == 1 {
                if let firstModel = listArray.first {
                    self?.lastId = firstModel.messageId
                }
                self?.dataArray.append(contentsOf: listArray)
                self?.chatTableView.reloadData()
                dispatchAfter(delay: 0.5) {
                    self?.scrollToBottomRow()
                }
            }
        }
    }

    @objc func rightButtonClick() {
        let recordList = WHHAIChatListViewController()
        recordList.callBackBlock = { [weak self] conversationId in
            self?.dataArray.removeAll()
            self?.chatTableView.reloadData()
            self?.conversationId = conversationId
            self?.getChatListFooterRequest()
        }
        navigationController?.pushViewController(recordList, animated: true)
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
        UIView.animate(withDuration: 0.25) {
            self.chatInputView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-WHHBottomSafe)
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
        if conversationId.isEmpty {
            // 新创建的

            WHHHomeRequestViewModel.postCreateChatConversationCreate(input: message) { [weak self] code, model, msg, errorCode in

                if code == 1 {
                    self?.createSendMessageBody(msg: message)

                    WHHABBChatRequestApiViewModel.whhAbbChatSendMessageRequestApi(inputText: message, conversationId: model.conversationId) { [weak self] success, msg in
                        if success == 1 {
                            self?.conversationId = model.conversationId
                            self?.createReceiveMessageBody(msg: msg)
                        } else {
                            // 清理数据
                            self?.currentStreamedText = ""
                        }
                    }
                } else {
                    WHHHUD.whhShowInfoText(text: msg)
                    if errorCode == "B0003" {
                        self?.jumpVIP()
                    }
                }
            }

        } else {
            // 历史会话

            createSendMessageBody(msg: message)
            dispatchAfter(delay: 0.25) { [weak self] in
                WHHABBChatRequestApiViewModel.whhAbbChatSendMessageRequestApi(inputText: message, conversationId: self?.conversationId ?? "") { [weak self] success, msg in
                    if success == 1 {
                        self?.createReceiveMessageBody(msg: msg)
                    }
                }
            }
        }
    }

    /// 创建发送方的消息体
    /// - Parameter msg: 消息
    private func createSendMessageBody(msg: String) {
        let sendModel = WHHChatMesageModel()
        sendModel.messageType = "user"
        sendModel.content = msg
        dataArray.append(sendModel)
        onMainThread { [weak self] in
            self?.reloadTableViewData()
        }
    }

    private func createReceiveMessageBody(msg: String) {
        if msg.containsNeedVIP() {
            jumpVIP()

            return
        } else if msg.containsUserInput() {
        } else {
            if dataArray.isEmpty || dataArray.last?.messageType == "user" {
                // 用户发的
                let sendModel = WHHChatMesageModel()
                sendModel.messageType = "assistant"
                sendModel.content += msg
                dataArray.append(sendModel)

            } else {
                // AI生成的
                dataArray[dataArray.count - 1].content += msg
            }

            onMainThread { [weak self] in
                self?.reloadTableViewData()
            }
        }
    }

    private func jumpVIP() {
        FCVIPRequestApiViewModel.whhRequestProductList { [weak self] dataArray in
            let vipView = WHHAIDestinyLineIVIPView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
            let model = dataArray.first(where: { $0.code == "com.abb.AIProjectWeek" })
            model?.isSelect = true
            vipView.dataArray = dataArray
            self?.view.addSubview(vipView)
            self?.view.endEditing(true)
        }
    }

    private func reloadTableViewData() {
        chatTableView.reloadData()
        dispatchAfter(delay: 0.25) { [weak self] in
            self?.scrollToBottomRow()
        }
    }
}

extension WHHAIChatViewController: UITableViewDataSource, UITableViewDelegate {
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
