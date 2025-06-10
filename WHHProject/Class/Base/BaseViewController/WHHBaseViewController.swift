//
//  WHHBaseViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit

class WHHBaseViewController: UIViewController {
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func whhRefreshHeader() {
        debugPrint("下拉刷新要求子类实现")
    }

    func whhRefreshFooter() {
        debugPrint("上拉加载要求子类实现")
    }
}
