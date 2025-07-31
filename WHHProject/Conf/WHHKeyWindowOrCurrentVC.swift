//
//  WHHKeyWindowOrCurrentVC.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import Foundation
import UIKit
extension UIViewController {
    static func currentViewController(base: UIViewController? = UIWindow.getKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

extension UIWindow {
    /// 获取当前的keywindow
    static var getKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({ $0 is UIWindowScene })
                .map({ ($0 as! UIWindowScene).windows })
                .first?.filter({ $0.isKeyWindow }).first
            return keyWindow
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
extension UIScrollView {
    func whhSetDefault() {
        contentInsetAdjustmentBehavior = .never
        automaticallyAdjustsScrollIndicatorInsets = false
    }
}

extension UITableView {
    func whhSetTableViewDefault() {
        contentInsetAdjustmentBehavior = .never
        automaticallyAdjustsScrollIndicatorInsets = false
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
    }
}
