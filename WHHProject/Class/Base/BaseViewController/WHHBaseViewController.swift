//
//  WHHBaseViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit
import EmptyDataSet_Swift
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
    
    func addEmptyDataSet(tableView:UITableView) {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
}
extension WHHBaseViewController:EmptyDataSetSource,EmptyDataSetDelegate {
    
    
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
