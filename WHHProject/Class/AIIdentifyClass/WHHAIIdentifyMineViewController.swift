//
//  WHHAIIdentifyMineViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

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
        let a = WHHNewMineHeaderView()
        a.didEditButtonBlock = {
        }
        a.didSpackButtonBlock = {
        }
        return a
    }()

    lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingView(delegate: self)
        pagingView.backgroundColor = .clear
        pagingView.mainTableView.backgroundColor = .clear
//        pagingView.pinSectionHeaderVerticalOffset = Int(WHHTopSafe)
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
        dataSource.titles = ["说梦", "分享", "赞过"]
        dataSource.isItemSpacingAverageEnabled = false
        return dataSource
    }()

    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.dataSource = segmentedDataSource
        view.indicators = [indicator]
        view.backgroundColor = .clear
        view.contentEdgeInsetLeft = 0
        return view
    }()

    lazy var indicator: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorWidth = 20
        view.indicatorColor = .white
        view.indicatorHeight = 1
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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.addSubview(pagingView)
        
        pagingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(WHHAllNavBarHeight)
            make.left.bottom.right.equalToSuperview()
        }
        segmentedView.listContainer = pagingView.listContainerView as? any JXSegmentedViewListContainer
    }

    @objc func setButtonClick() {
        let setCenterVC = WHHAIGallerySetCenterViewController()
        navigationController?.pushViewController(setCenterVC, animated: true)
    }

    private func jumpjifenCenter() {
        let vc = WHHAIIntegrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WHHAIIdentifyMineViewController: JXPagingViewDelegate {
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let vc = WHHNewMineItemViewViewController()

        return vc
    }

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 150
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 52
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segmentedDataSource.titles.count
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
    }
}
