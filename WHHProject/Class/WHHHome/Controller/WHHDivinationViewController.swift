//
//  WHHDivinationViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/29.
//

import UIKit

class WHHDivinationViewController: WHHBaseViewController {
    @IBOutlet var subscriptionButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var bottomView: UIImageView!
    @IBOutlet var ednvButton: UIButton!
    @IBOutlet var shenqiNvButton: UIButton!
    @IBOutlet var nvBgIocn: UIImageView!
    @IBOutlet var xuanjinvButton: UIButton!

    @IBOutlet weak var topConf: NSLayoutConstraint!
    @IBOutlet var meetingWordsLabel: UILabel!
    @IBOutlet var anaLabel: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label1: UILabel!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var nwName: UILabel!
    @IBOutlet var icon: UIImageView!

    @IBOutlet var welfaresLabel: UILabel!
    @IBOutlet var divinationLabel: UILabel!
    @IBOutlet var subscriptionLabel: UILabel!

    private(set) var selectModel: WHHHomeWitchModel?

    lazy var dataArray: [WHHHomeWitchModel] = {
        let view = [WHHHomeWitchModel]()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = "whhDivinationNavTitleKey".localized
        gk_navBackgroundColor = .clear
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
        ednvButton.layer.cornerRadius = 13
        ednvButton.layer.masksToBounds = true
        shenqiNvButton.layer.cornerRadius = 13
        shenqiNvButton.layer.masksToBounds = true
        xuanjinvButton.layer.cornerRadius = 13
        xuanjinvButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.setTitle("whhDivinationBackTitleKey".localized, for: .normal)
        subscriptionButton.layer.cornerRadius = 22
        subscriptionButton.layer.masksToBounds = true
        subscriptionButton.setTitle("whhDivinationTitleKey".localized, for: .normal)
        subscriptionButton.setTitle("whhDivinationFinishTitleKey".localized, for: .selected)
//        subscriptionButton.setImage(UIImage(named: "whhSubscriptionButtonIcon"), for: .normal)
//        subscriptionButton.setImage(UIImage(named: "whhSubscriptionButtonIcon"), for: .selected)
        
        topConf.constant = 44
        
        whhHomeGetWitchList()
    }

    private func whhHomeGetWitchList() {
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhHomeGetWitchList { [weak self] witchDataArray in
            WHHHUD.whhHidenLoadView()
            if witchDataArray.isEmpty == false {
                self?.dataArray = witchDataArray
                self?.setDefault()
            }
        }
    }

    private func setDefault() {
        xuanjinvButton.isSelected = true
        xuanjinvButton.backgroundColor = Color6D64FF
        xuanjinvButton.setTitleColor(.white, for: .normal)
        if let model = dataArray.first(where: { $0.name == "璇玑女巫" }) {
            selectModel = model
            whhEvaluationdataWithModel(model: model)
        }
    }

    private func whhEvaluationdataWithModel(model: WHHHomeWitchModel) {
        icon.whhSetKFWithImage(imageString: model.icon)
        nwName.text = model.name + "·阿贝贝"
        label1.text = model.goodAt
        label2.text = model.luckyColor
        image1.whhSetImageView(url: model.goodAtIcon)
        image2.backgroundColor = UIColor(hex: model.luckyColorValue)
        anaLabel.text = model.meetingWords

        subscriptionLabel.text = "订阅: \(model.stat.subscribeTimes)人"
        divinationLabel.text = "占卜: \(model.stat.fortuneTimes)次"
        meetingWordsLabel.text = model.meetingWords
        var name1 = ""
        if let welfares1 = model.welfares.first {
            name1 = welfares1
        }
        if let welfares2 = model.welfares.last {
            name1 += "\n" + welfares2
        }
        welfaresLabel.text = name1
        
        if model.subscribed {
            subscriptionButton.setTitle("已订阅", for:.normal)
        }else{
            subscriptionButton.setTitle("订阅", for:.normal)
        }
        
    }

    @IBAction func edNvButtonClick(_ sender: UIButton) {
        sender.isSelected = true
        // 恶毒
        sender.backgroundColor = Color6D64FF
        sender.setTitleColor(.white, for: .normal)

        xuanjinvButton.backgroundColor = .white
        xuanjinvButton.setTitleColor(Color6D64FF, for: .normal)
        xuanjinvButton.isSelected = false

        shenqiNvButton.backgroundColor = .white
        shenqiNvButton.setTitleColor(Color6D64FF, for: .normal)
        shenqiNvButton.isSelected = false

        if let model = dataArray.first(where: { $0.name == "恶毒女巫" }) {
            selectModel = model
            whhEvaluationdataWithModel(model: model)
        }
    }

    @IBAction func shenqiNvButtonClick(_ sender: UIButton) {
        // 神奇
        sender.backgroundColor = Color6D64FF
        sender.setTitleColor(.white, for: .normal)
        sender.isSelected = true

        xuanjinvButton.backgroundColor = .white
        xuanjinvButton.setTitleColor(Color6D64FF, for: .normal)
        xuanjinvButton.isSelected = false

        ednvButton.backgroundColor = .white
        ednvButton.setTitleColor(Color6D64FF, for: .normal)
        ednvButton.isSelected = false
        if let model = dataArray.first(where: { $0.name == "神奇女巫" }) {
            selectModel = model
            whhEvaluationdataWithModel(model: model)
        }
    }

    @IBAction func xuanjiNVButtonClick(_ sender: UIButton) {
        // 玄机
        sender.backgroundColor = Color6D64FF
        sender.setTitleColor(.white, for: .normal)
        sender.isSelected = true

        shenqiNvButton.backgroundColor = .white
        shenqiNvButton.setTitleColor(Color6D64FF, for: .normal)
        shenqiNvButton.isSelected = false

        ednvButton.backgroundColor = .white
        ednvButton.setTitleColor(Color6D64FF, for: .normal)
        ednvButton.isSelected = false
        if let model = dataArray.first(where: { $0.name == "璇玑女巫" }) {
            selectModel = model
            whhEvaluationdataWithModel(model: model)
        }
    }

    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func subscriptionButtonClick(_ sender: UIButton) {
        guard let newSelectModel = selectModel else { return }
        let subscriptAlertView = WHHDivinationAlertView()
        if newSelectModel.subscribed {
            
        } else {
            // 去订阅
            if WHHUserInfoManager.shared.userModel.vip == 1 {
                subscriptAlertView.type = .subscription
            }else{
                subscriptAlertView.type = .privilege
            }
            subscriptAlertView.smallTitleLabel.text = "是否订阅" + newSelectModel.name + "女巫" + "「\(newSelectModel.predictionName)」" + "，订阅后成功后，每天准点获取推送"
            subscriptAlertView.didCancleSubscriptionBlock = {[weak self] in
                self?.whhSubscriptionRequest()
            }
            view.addSubview(subscriptAlertView)
        }
        
    }
    
    private func whhSubscriptionRequest() {
        guard let newSelectModel = selectModel else { return }
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhSubscriptionRequest(witchId: newSelectModel.wichId) {[weak self] success,msg in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                self?.whhHomeGetWitchList()
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }
               
            }else{
                WHHHUD.whhShowInfoText(text: msg)
            }
        }
    }
}
