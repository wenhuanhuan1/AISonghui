//
//  WHHAIDestinyLineItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

import JXSegmentedView
import UIKit

class WHHAIDestinyLineItemViewController: WHHBaseViewController {
    var lastGetMaxId: String = ""

    
    lazy var listTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.backgroundColor = .clear
        view.delegate = self
        view.separatorStyle = .none
        view.register(UINib(nibName: "WHHAIDestinyLineItemTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAIDestinyLineItemTableViewCell")
        view.whhAddRefreshNormalHeader { [weak self] in
            self?.whhRefreshHeader()
        }
        view.whhAddRefreshNormalFooter { [weak self] in
            self?.whhRefreshFooter()
        }
        view.mj_footer?.isHidden = true
        return view
    }()

    lazy var listArray: [WHHAIDestinyLineItemModel] = {
        let view = [WHHAIDestinyLineItemModel]()
        return view
    }()

    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorD6D4FF
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        whhRefreshHeader()
    }

    override func whhRefreshHeader() {
        super.whhRefreshHeader()

        WHHMineRequestApiViewModel.whhGetMyLuckValueRecordList(lastGetMaxId: lastGetMaxId, income: index) { [weak self] dataArray, code, _ in
            self?.listTableView.mj_header?.endRefreshing()
            if code == 1 {
                if dataArray.count < 5 {
                    self?.listTableView.mj_footer?.isHidden = true
                }else{
                    self?.listTableView.mj_footer?.isHidden = false
                }
                self?.listArray = dataArray
                self?.listTableView.reloadData()
            }
        }
    }

    override func whhRefreshFooter() {
        super.whhRefreshFooter()
        WHHMineRequestApiViewModel.whhGetMyLuckValueRecordList(lastGetMaxId: lastGetMaxId, income: index) { [weak self] dataArray, code, _ in
            self?.listTableView.mj_footer?.endRefreshing()
            if code == 1 {
                self?.listArray.append(contentsOf: dataArray)
                self?.listTableView.reloadData()
            }
        }
    }
}

extension WHHAIDestinyLineItemViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension WHHAIDestinyLineItemViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHAIDestinyLineItemTableViewCell") as! WHHAIDestinyLineItemTableViewCell
        let model = listArray[indexPath.row]
        
        cell.nameLabel.text = model.remark
        if model.income {
            cell.priceLabel.text = "+" + model.num
        }else {
            cell.priceLabel.text = "-" + model.num
        }
        cell.timeLabel.text = WHHDateFormatterManager.shared.convertTimestamp(model.createTime/1000)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
}
