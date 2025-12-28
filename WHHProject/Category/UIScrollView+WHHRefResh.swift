//
//  UIScrollView+WHHRefResh.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import Foundation
import MJRefresh
typealias WHHRefreshComponent = (() -> Void)?

class WHHRefreshNormalHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()
        stateLabel?.font = pingfangSemibold(size: 13)
        stateLabel?.textColor = .white.withAlphaComponent(0.5)
        lastUpdatedTimeLabel?.textColor = .white.withAlphaComponent(0.5)
        lastUpdatedTimeLabel?.font = pingfangSemibold(size: 12)
        loadingView?.color = .white.withAlphaComponent(0.7)
    }
}

class WHHRefreshAutoFooter: MJRefreshAutoNormalFooter {
    override func prepare() {
        super.prepare()

        stateLabel?.font = pingfangSemibold(size: 13)
        stateLabel?.textColor = .white.withAlphaComponent(0.5)
        setTitle("已经到底了", for: .noMoreData)
        triggerAutomaticallyRefreshPercent = 0
        setAnimationDisabled()
    }
}

extension UIScrollView {
    func whhAddRefreshNormalHeader(headerCallBlack: WHHRefreshComponent) {
        let header = WHHRefreshNormalHeader {
            headerCallBlack?()
        }
        mj_header = header
    }

    func whhAddRefreshNormalFooter(footerCallBlack: WHHRefreshComponent) {
        let footer = WHHRefreshAutoFooter {
            footerCallBlack?()
        }
        mj_footer = footer
    }
}
