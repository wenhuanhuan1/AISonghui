//
//  WHHAIChatListViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/7.
//

import UIKit

class WHHAIChatListViewController: WHHBaseViewController {
    lazy var listTableView: UITableView = {
        let a = UITableView(frame: .zero, style: .grouped)
        a.separatorStyle = .none
        a.dataSource = self
        a.delegate = self
        a.register(UINib(nibName: "WHHAIChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAIChatListTableViewCell")
        return a

    }()

    var callBackBlock: ((String) -> Void)?

    lazy var array: [WHHAIChatListModel] = {
        let a = [WHHAIChatListModel]()
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = "记录"
        gk_backStyle = .black
        gk_navTitleColor = .black
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 10)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChatListArray()
    }

    private func getChatListArray() {
        WHHHomeRequestViewModel.getChatConversationList { [weak self] code, dataArray, msg in

            if code == 1 {
                self?.array = dataArray
                self?.listTableView.reloadData()
            } else {
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }

    private func cellDidButtonMethod(section: Int, model: WHHAIChatListModel) {
        let alertView = WHHAIChatListDeleteView()
        alertView.bigTitle.text = "温馨提示"
        alertView.smallTitle.text = "删除对话后，不可追回"
        alertView.submitButton.setTitle("确认", for: .normal)
        alertView.didSubmitButtonBlock = { [weak self]  in
            WHHHUD.whhShowLoadView()
            WHHHomeRequestViewModel.deleteRequestchatConversationDelete(conversationId: model.conversationId) { [weak self] success, msg in
                WHHHUD.whhHidenLoadView()
                if success == 1 {
                    self?.array.removeAll(where: { $0.conversationId == model.conversationId })
                    self?.listTableView.reloadData()
                } else {
                    dispatchAfter(delay: 0.5) {
                        WHHHUD.whhShowInfoText(text: msg)
                    }
                }
            }
        }
        view.addSubview(alertView)
    }

    private func createNewChatMethod() {
    }
}

extension WHHAIChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHAIChatListTableViewCell", for: indexPath) as! WHHAIChatListTableViewCell

        if indexPath.section == 0 {
            cell.leftIcon.image = UIImage(named: "newChat")
            cell.centerContentLabel.text = "新问题"
            cell.centerContentLabel.textColor = Color6C73FF
            cell.didWHHAIChatListTableViewCellButtonBlock = { [weak self] in
                self?.createNewChatMethod()
            }
        } else {
            let model = array[indexPath.section - 1]
            cell.leftIcon.image = UIImage(named: "delete")
            cell.centerContentLabel.text = model.title
            cell.centerContentLabel.textColor = .black
            cell.didWHHAIChatListTableViewCellButtonBlock = { [weak self] in

                self?.cellDidButtonMethod(section: indexPath.section - 1, model: model)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            callBackBlock?("")

        } else {
            let model = array[indexPath.section - 1]
            callBackBlock?(model.conversationId)
        }
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}
