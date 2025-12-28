//
//  WHHAIIntegrationViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class WHHAIIntegrationViewController: WHHBaseViewController {
    @IBOutlet var jifenTableView: UITableView!

    @IBOutlet var jifenyuer: UILabel!
    lazy var rightBtn: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("说明", for: .normal)
        a.titleLabel?.font = pingfangRegular(size: 16)
        a.setTitleColor(.white.withAlphaComponent(0.9), for: .normal)
        a.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return a
    }()

    private(set) var lastGetMaxId = ""

    lazy var dataArray: [WHHIntegralModel] = {
        let a = [WHHIntegralModel]()
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navigationBar.isHidden = false
        gk_navTitle = "积分中心"
        gk_statusBarStyle = .lightContent
        let att = NSMutableAttributedString(string: "我的积分", attributes: [.foregroundColor: UIColor.white, .font: pingfangMedium(size: 12)!])
        let jifen = NSAttributedString(string: "1244", attributes: [.foregroundColor: UIColor.white, .font: pingfangSemibold(size: 18)!])
        att.append(jifen)
        jifenyuer.attributedText = att

        jifenTableView.dataSource = self
        jifenTableView.delegate = self

        jifenTableView.register(UINib(nibName: "WHHJIfenListTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHJIfenListTableViewCell")
        jifenTableView.whhAddRefreshNormalHeader { [weak self] in
            self?.whhRefreshHeader()
        }
        jifenTableView.whhAddRefreshNormalFooter { [weak self] in
            self?.whhRefreshFooter()
        }
        jifenTableView.mj_footer?.isHidden = true
        addEmptyDataSet(tableView: jifenTableView)
        whhRefreshHeader()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
    }

    @objc func rightButtonClick() {
    }

    @IBAction func jumpVIPButtonClick(_ sender: UIButton) {
        jumpVIPController {
        }
    }

    override func whhRefreshHeader() {
        super.whhRefreshHeader()
        lastGetMaxId = ""
        WHHHomeRequestViewModel.whhMineIntegralListGetWHHHomeappUserWitchGetFortuneRequest(lastGetMaxId: lastGetMaxId) { [weak self] code, array, _ in
            self?.jifenTableView.mj_header?.endRefreshing()
            if code == 1 {
                self?.jifenTableView.mj_footer?.resetNoMoreData()
                self?.dataArray = array
                if let firstModel = array.last {
                    self?.lastGetMaxId = firstModel.lastGetMaxId
                }
                if array.count > 8 {
                    self?.jifenTableView.mj_footer?.isHidden = false
                } else {
                    self?.jifenTableView.mj_footer?.isHidden = true
                }

                self?.jifenTableView.reloadData()
            }
        }
    }

    override func whhRefreshFooter() {
        super.whhRefreshFooter()

        WHHHomeRequestViewModel.whhMineIntegralListGetWHHHomeappUserWitchGetFortuneRequest(lastGetMaxId: lastGetMaxId) { [weak self] code, array, _ in
            self?.jifenTableView.mj_footer?.endRefreshing()
            if code == 1 {
                self?.dataArray.append(contentsOf: array)
                if let firstModel = array.last {
                    self?.lastGetMaxId = firstModel.lastGetMaxId
                }
                if array.isEmpty {
                    self?.jifenTableView.mj_footer?.endRefreshingWithNoMoreData()
                }

                self?.jifenTableView.reloadData()
            }
        }
    }

    private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            if code == 1 {
                let att = NSMutableAttributedString(string: "我的积分 ", attributes: [.foregroundColor: UIColor.white, .font: pingfangMedium(size: 12)!])
                let jifenAtt = NSAttributedString(string: "\(model.points)", attributes: [.foregroundColor: UIColor.white, .font: pingfangSemibold(size: 18)!])
                att.append(jifenAtt)
                self?.jifenyuer.attributedText = att
            }
        }
    }
}

extension WHHAIIntegrationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHJIfenListTableViewCell") as! WHHJIfenListTableViewCell
        let model = dataArray[indexPath.row]
        cell.cellModel = model
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
