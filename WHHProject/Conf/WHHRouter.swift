//
//  WHHRouter.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/2.
//

import Foundation

func routerSwitchRootViewController() {
   
}

func jumpVIPController(callBlack: (() -> Void)?) {
    
    WHHHUD.whhShowLoadView()
    FCVIPRequestApiViewModel.whhRequestProductList { dataArray in
        WHHHUD.whhHidenLoadView()
        if let currentVC = UIViewController.currentViewController() {
            let vipViewController = WHHVIPViewController()
            vipViewController.dataArray = dataArray
            vipViewController.didPuyFinish = {
                callBlack?()
            }
            let nav = WHHNavigationController(rootVC: vipViewController)
            nav.modalPresentationStyle = .overFullScreen
            currentVC.present(nav, animated: true)
        }
    }
    
}
