//
//  WHHAIDestinyLinesViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/26.
//

import UIKit
import JXSegmentedView

class WHHAIDestinyLinesViewController: WHHBaseViewController {
    lazy var topView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    var lastGetMaxId: String = ""
    var index: Int = 0
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorD6D4FF
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    lazy var topImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        view.image = UIImage(named: "personVIP")
        return view
    }()

    lazy var getButton: UILabel = {
        let view = UILabel()
        view.text = "获取"
        view.textAlignment = .center
        view.backgroundColor = .white
        view.font = pingfangRegular(size: 13)
        view.textColor = .black
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var jumpButton: UIButton = {
        let view = UIButton(type: .custom)
        view.addTarget(self, action: #selector(didVipButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var listTitle: UILabel = {
        let view = UILabel()
        view.text = "记录"
        view.textAlignment = .center
        view.textColor = .black
        view.font = pingfangSemibold(size: 15)
        return view
    }()

    lazy var lineLabel: UILabel = {
        let view = UILabel()
        view.text = "命运丝线：0"
        view.textAlignment = .center
        view.font = pingfangRegular(size: 12)
        view.textColor = .white
        return view
    }()

    lazy var bottomView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.5)
        return bgView
    }()
    
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

    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = ["全部", "消耗", "获取"]
        segmentedDataSource.itemSpacing = 5
        segmentedDataSource.itemWidthIncrement = 20
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleNormalFont = pingfangRegular(size: 12)!
        segmentedDataSource.titleSelectedFont = pingfangSemibold(size: 12)
        segmentedDataSource.titleNormalColor = UIColor.white.withAlphaComponent(0.8)
        segmentedDataSource.titleSelectedColor = .black
        

        return segmentedDataSource
    }()

//    lazy var listContainerView: JXSegmentedListContainerView! = JXSegmentedListContainerView(dataSource: self)

//    lazy var segmentedView: JXSegmentedView = {
//        let segmentedView = JXSegmentedView()
//        segmentedView.dataSource = segmentedDataSource
//        segmentedView.backgroundColor = .black
//        segmentedView.listContainer = listContainerView
//        segmentedView.layer.masksToBounds = true
//        segmentedView.layer.cornerRadius = 20
//        let indicator = JXSegmentedIndicatorBackgroundView()
//               indicator.indicatorHeight = 36
//        indicator.layer.cornerRadius = 18
//        indicator.layer.masksToBounds = true
//        indicator.indicatorWidth = 120
//        indicator.indicatorWidthIncrement = 0
//        indicator.indicatorColor = UIColor.white
//        segmentedView.indicators = [indicator]
//        return segmentedView
//    }()


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRequest), name: NSNotification.Name("vipBuyFinish"), object: nil)
        
        gk_navTitle = "命运丝线"
        gk_backStyle = .black
        gk_navTitleColor = .black
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(WHHAllNavBarHeight + 10)
            make.height.equalTo(170)
        }
        topView.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }

        bottomView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        bottomView.addSubview(getButton)
        getButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        view.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
        bottomLineView.addSubview(listTitle)
        listTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        bottomLineView.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
//        segmentedView.snp.makeConstraints { make in
//            make.left.equalTo(20)
//            make.top.equalTo(listTitle.snp.bottom).offset(10)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(40)
//        }
//
//        bottomLineView.addSubview(listContainerView)
//        listContainerView.scrollView.backgroundColor = .clear
//        listContainerView.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalTo(segmentedView.snp.bottom).offset(10)
//        }
        topView.addSubview(jumpButton)
        jumpButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        getUserInfo()
        whhRefreshHeader()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
   @objc func reloadRequest() {
        
       getUserInfo()
       whhRefreshHeader()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        bottomLineView.whhAddSetRectConrner(corner: [.topLeft,.topRight], radile: 12)
        
    }

   @objc private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in
            if code == 1 {
                self?.lineLabel.text = "命运丝线:" + "\(model.luckValueNum)"
            }
        }
    }
    
    @objc override func whhRefreshHeader() {
        super.whhRefreshHeader()

        WHHMineRequestApiViewModel.whhGetMyLuckValueRecordList(lastGetMaxId: lastGetMaxId, income: index) { [weak self] dataArray, code, _ in
            self?.listTableView.mj_header?.endRefreshing()
            if code == 1 {
                if dataArray.count < 5 {
                    self?.listTableView.mj_footer?.isHidden = true
                } else {
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
    
   @objc func didVipButtonClick() {
       WHHHUD.whhShowLoadView()
       FCVIPRequestApiViewModel.whhRequestProductList {[weak self] dataArray in
           WHHHUD.whhHidenLoadView()
           let vipView = WHHAIDestinyLineIVIPView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
          let model = dataArray.first(where: {$0.code == "com.abb.AIProjectWeek"})
           model?.isSelect = true
           vipView.dataArray = dataArray
           self?.view.addSubview(vipView)
       }
      
    }
}
//extension WHHAIDestinyLinesViewController: JXSegmentedListContainerViewDataSource {
//    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
//        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
//            return titleDataSource.dataSource.count
//        }
//        return 0
//    }
//
//    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
//        let sqVC = WHHAIDestinyLineItemViewController()
//        sqVC.index = index
//        return sqVC
//    }
//}
extension WHHAIDestinyLinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHAIDestinyLineItemTableViewCell") as! WHHAIDestinyLineItemTableViewCell
        let model = listArray[indexPath.row]

        cell.nameLabel.text = model.remark
        if model.income {
            cell.priceLabel.text = "+" + model.num
        } else {
            cell.priceLabel.text = "-" + model.num
        }
        cell.timeLabel.text = WHHDateFormatterManager.shared.convertTimestamp(model.createTime / 1000)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
}
