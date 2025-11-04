//
//  WHHAIDestinyLineIVIPView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

import UIKit

class WHHAIDestinyLineIVIPView: UIView {
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var openButtonClick: UIButton!
    @IBOutlet weak var mingyunLineView: UILabel!
    @IBOutlet weak var sourceBgView: UIView!
    
    
    var dataArray = [WHHVIPCenterModel]()
    
    @IBOutlet weak var shopTableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        getUserInfo()
    }
    
    private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            if code == 1 {
                self?.mingyunLineView.text = "命运丝线:" + "\(model.luckValueNum)"
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        commonInit()
    }

    // MARK: - 加载 XIB

    private func commonInit() {
        if let view = UINib(nibName: "WHHAIDestinyLineIVIPView", bundle: nil).instantiate(withOwner: self, options: nil).first as? WHHAIDestinyLineIVIPView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
            
            openButtonClick.layer.cornerRadius = 25
            openButtonClick.layer.masksToBounds = true
            
            view.sourceBgView.layer.cornerRadius = 12
            view.sourceBgView.layer.masksToBounds = true
            topImageView.layer.cornerRadius = 12
            topImageView.layer.masksToBounds = true
            shopTableView.dataSource = self
            shopTableView.delegate = self
            shopTableView.separatorStyle = .none
            shopTableView.isScrollEnabled = false
            shopTableView.register(UINib(nibName: "WHHAIDestinyLineIVIPCell", bundle: nil), forCellReuseIdentifier: "WHHAIDestinyLineIVIPCell")
        }
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        
        removeFromSuperview()
    }
    
    @IBAction func openButtonClicl(_ sender: UIButton) {
        
        if let model = dataArray.first(where: { $0.isSelect }) {
            WHHApplePurchaseManager.shared.whhCreateOrderRequest(goodsId: model.productId, payPage: "不知道是啥")
            WHHApplePurchaseManager.shared.purchaseHandle = { [weak self] status in
                if status == .success {
                    self?.getUserInfo()
                    NotificationCenter.default.post(name: NSNotification.Name("vipBuyFinish"), object: nil)
                }
            }
        }
        
    }
}

extension WHHAIDestinyLineIVIPView: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHAIDestinyLineIVIPCell") as! WHHAIDestinyLineIVIPCell
        let model = dataArray[indexPath.row]
        cell.nameLabel.text = model.name
        cell.priceLabel.text = "￥" + model.price
        if indexPath.row == 0 {
            cell.smallLabel.text = "每周获取14根命运丝线"
        }else if indexPath.row == 1 {
            cell.smallLabel.text = "每月获取70根命运丝线"
        }else{
            cell.smallLabel.text = "每年获取999根命运丝线"
        }
        if model.isSelect {
            cell.bgsasView.backgroundColor = Color4F48CF
            cell.nameLabel.textColor = .white
            cell.smallLabel.textColor = .white
            cell.priceLabel.textColor = .white
            cell.openWenDa.textColor = .white
            
        }else {
            cell.bgsasView.backgroundColor = Color999999
            cell.nameLabel.textColor = .black
            cell.smallLabel.textColor = .black
            cell.priceLabel.textColor = .black
            cell.openWenDa.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        for item in dataArray {
            item.isSelect = false
        }
        let model = dataArray[indexPath.row]
        model.isSelect = true
        tableView.reloadData()
    }

}
