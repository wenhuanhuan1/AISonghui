//
//  WHHBaseViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import EmptyDataSet_Swift
import GKNavigationBarSwift
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import UIKit

class WHHBaseViewController: UIViewController {
    var isIQKeyboardManagerIsEnabled: Bool = false {
        didSet {
            IQKeyboardManager.shared.isEnabled = isIQKeyboardManagerIsEnabled
            IQKeyboardToolbarManager.shared.isEnabled = isIQKeyboardManagerIsEnabled
        }
    }

    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorF2F4FE
    }

    func whhRefreshHeader() {
        debugPrint("下拉刷新要求子类实现")
    }

    func whhRefreshFooter() {
        debugPrint("上拉加载要求子类实现")
    }

    func addEmptyDataSet(tableView: UITableView) {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    func iQKeyboardManagerIsEnabled() {
    }
    
    override func backItemClick(_ sender: Any) {
        
    }
}

extension WHHBaseViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "暂无内容"
        let attributes = [NSAttributedString.Key.font: pingfangRegular(size: 16), NSAttributedString.Key.foregroundColor: ColorFF4746]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key: Any])
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "dataFileIcon")
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -50
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        whhRefreshHeader()
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
