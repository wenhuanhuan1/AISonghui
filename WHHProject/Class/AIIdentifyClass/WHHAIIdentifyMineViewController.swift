//
//  WHHAIIdentifyMineViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

import IQKeyboardManagerSwift
import JXPagingView
import JXSegmentedView

class JFCustomView: WHHBaseView {
    var didJFCustomViewButtonBlock: (() -> Void)?

    lazy var titleLabel: UILabel = {
        let a = UILabel()
        a.text = "积分：19"
        a.textAlignment = .center
        a.font = pingfangRegular(size: 12)
        a.textColor = .white
        return a
    }()

    override func setupViews() {
        super.setupViews()
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .white.withAlphaComponent(0.1)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.bottom.equalToSuperview()
        }
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func buttonClick() {
        didJFCustomViewButtonBlock?()
    }
}

class WHHAIIdentifyMineViewController: WHHBaseViewController {
    lazy var headView: WHHNewMineHeaderView = {
        let a = WHHNewMineHeaderView(frame: CGRectMake(0, 0, WHHScreenW, 230))
        a.didEditButtonBlock = { [weak self] model in

            self?.jumpEditView(model: model)
        }
        a.didSpackButtonBlock = { [weak self] _ in
        }
        return a
    }()

    lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingView(delegate: self, listContainerType: .collectionView)
        pagingView.backgroundColor = .clear
        pagingView.mainTableView.backgroundColor = .clear
        pagingView.pinSectionHeaderVerticalOffset = Int(WHHTopSafe)
        return pagingView
    }()

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titleSelectedFont = pingfangMedium(size: 14)
        dataSource.titleNormalFont = pingfangMedium(size: 14)!
        dataSource.titleNormalColor = .white.withAlphaComponent(0.5)
        dataSource.titleSelectedColor = .white
        dataSource.isItemTransitionEnabled = false
        dataSource.itemSpacing = 20
        dataSource.titles = titles
        dataSource.isItemSpacingAverageEnabled = false
        return dataSource
    }()

    let headerInSectionHeight: Int = 50

    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRectMake(0, 0, WHHScreenW, CGFloat(headerInSectionHeight)))
        view.delegate = self
        view.dataSource = segmentedDataSource
        view.indicators = [indicator]
        view.backgroundColor = .clear
        view.contentEdgeInsetLeft = 16
        return view
    }()
    
    private(set) var titles = ["说梦", "分享", "赞过"]

    lazy var indicator: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorWidth = 20
        view.indicatorColor = .white
        view.indicatorHeight = 1
        view.verticalOffset = 2
        return view
    }()

    lazy var jifenButton: JFCustomView = {
        let a = JFCustomView()
        a.didJFCustomViewButtonBlock = { [weak self] in
            self?.jumpjifenCenter()
        }
        return a
    }()

    lazy var setButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "whhSetMoreIcon"), for: .normal)
        a.addTarget(self, action: #selector(setButtonClick), for: .touchUpInside)
        return a
    }()

    @objc func setButtonClick() {
        let setCenterVC = WHHAIGallerySetCenterViewController()
        navigationController?.pushViewController(setCenterVC, animated: true)
    }

    private func jumpjifenCenter() {
        let vc = WHHAIIntegrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getUserInfo), name: NSNotification.Name("uploadUserInfo"), object: nil)

        view.addSubview(pagingView)

        segmentedView.listContainer = pagingView.listContainerView

        view.addSubview(setButton)
        setButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(WHHTopSafe)
        }
        view.addSubview(jifenButton)
        jifenButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalTo(setButton)
            make.right.equalTo(setButton.snp.left).offset(-10)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
    }

    @objc private func getUserInfo() {
        WHHHomeRequestViewModel.whhPersonGetMineUserInfoRequest { [weak self] code, model in

            if code == 1 {
                self?.headView.userInfoModel = model
            }
        }
    }

    private func jumpEditView(model: FCMineModel) {
        let infoView = WHHEditUserInfoView()
        infoView.userInfo = model
        UIWindow.getKeyWindow?.addSubview(infoView)
    }
}

extension WHHAIIdentifyMineViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let vc = WHHNewMineItemViewViewController()
        
        return vc
    }

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 230
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

}

extension JXPagingListContainerView: JXSegmentedViewListContainer {
}
