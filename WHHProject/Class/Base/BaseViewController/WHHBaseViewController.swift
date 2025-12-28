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
    
    
    var emptTitle = "暂无内容"
    var isPopOnGesture = true
    
    var stayle:UIStatusBarStyle = .darkContent
    
    var isIQKeyboardManagerIsEnabled: Bool = false {
        didSet {
            IQKeyboardManager.shared.isEnabled = isIQKeyboardManagerIsEnabled
            IQKeyboardToolbarManager.shared.isEnabled = isIQKeyboardManagerIsEnabled
        }
    }

    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navigationBar.isHidden = true
        stayle = .lightContent
        view.backgroundColor = Color0F0F12
    }

    func whhRefreshHeader() {
        debugPrint("下拉刷新要求子类实现")
    }

    func whhRefreshFooter() {
        debugPrint("上拉加载要求子类实现")
    }

//    func addEmptyDataSet(tableView: UITableView) {
//        tableView.emptyDataSetSource = self
//        tableView.emptyDataSetDelegate = self
//    }

    func iQKeyboardManagerIsEnabled() {
    }
    
    override func backItemClick(_ sender: Any) {
        super.backItemClick(sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return stayle
    }
    
    func navigationShouldPopOnGesture() -> Bool {
        return isPopOnGesture
    }
}


