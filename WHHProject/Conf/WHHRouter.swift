//
//  WHHRouter.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/2.
//

import Foundation

func routerSwitchRootViewController() {
    if WHHUserInfoManager.shared.isLogin {
        UIWindow.getKeyWindow?.rootViewController = WHHNavigationController(rootVC: WHHHomeViewController())
    } else {
        UIWindow.getKeyWindow?.rootViewController = WHHNavigationController(rootVC: WHHRootViewController())
    }
}

func jumpVIPController(callBlack: (() -> Void)?) {
    if let currentVC = UIViewController.currentViewController() {
        let vipViewController = WHHVIPCenterViewController()
        vipViewController.didPuyFinish = {
            callBlack?()
        }
        let nav = WHHNavigationController(rootVC: vipViewController)
        nav.modalPresentationStyle = .overFullScreen
        currentVC.present(nav, animated: true)
    }
}
