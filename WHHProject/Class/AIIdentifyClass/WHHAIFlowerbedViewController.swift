//
//  WHHAIFlowerbedHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit
import JXSegmentedView

class WHHAIFlowerbedViewController: WHHBaseViewController {

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = ["噩梦惊醒","梦境画廊"]
        segmentedDataSource.itemSpacing = 0
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleNormalFont = pingfangSemibold(size: 20)!
        segmentedDataSource.titleSelectedFont = pingfangSemibold(size: 20)
        segmentedDataSource.titleNormalColor = .white.withAlphaComponent(0.3)
        segmentedDataSource.itemSpacing = 20
        segmentedDataSource.titleSelectedColor = .white
        return segmentedDataSource
    }()

    lazy var listContainerView: JXSegmentedListContainerView! = JXSegmentedListContainerView(dataSource: self)

    lazy var indicator: JXSegmentedIndicatorImageView = {
        let indicator = JXSegmentedIndicatorImageView()
        indicator.indicatorWidth = 48
        indicator.indicatorHeight = 5
        indicator.image = UIImage(named: "whhAIItemLineView")
        return indicator
    }()

    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.indicators = [indicator]
        segmentedView.dataSource = segmentedDataSource
        segmentedView.backgroundColor = .black
        segmentedView.contentEdgeInsetLeft = 10
        segmentedView.listContainer = listContainerView
        return segmentedView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(WHHTopSafe)
            make.width.equalTo(220)
            make.height.equalTo(44)
        }
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
            make.bottom.equalToSuperview().offset(-WHHTabBarHeight)
        }
    }
}
extension WHHAIFlowerbedViewController: JXSegmentedListContainerViewListDelegate, JXSegmentedListContainerViewDataSource {
    func listView() -> UIView {
        return view
    }

    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
           let vc = WHHAIGallerySleepItemViewController()
            return vc
        }else {
            let vc = WHHAIGalleryGalleryItemViewController()
             return vc
            
        }
    }
}
