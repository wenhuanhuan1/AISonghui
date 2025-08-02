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
