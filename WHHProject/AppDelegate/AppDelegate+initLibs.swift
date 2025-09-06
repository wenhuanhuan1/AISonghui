//
//  AppDelegate+initLibs.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import Foundation
import GKNavigationBarSwift

extension AppDelegate {
    /// 初始化三方库
    func initLibs() {
        WHHLanguageManager.shared.initNeedLanguage()
        initMMKV()
        initGkNav()
        ///设备安装和启动
        WHHHomeRequestViewModel.whhDeviceInstallRequest()

    }

    private func initMMKV() {
        WHHUserInfoManager.initMMKV()
    }

    func initGkNav() {
        GKNavigationBarConfigure.shared.setupCustom { configure in

            configure.backgroundColor = .clear
            // 导航栏标题颜色
            configure.titleColor = .white
            configure.lineHidden = true
            // 导航栏标题字体
            configure.titleFont = pingfangSemibold(size: 18)!
            // 导航栏返回按钮样式
            configure.backStyle = .white
//            configure.backImage = UIImage(named: "navBackIcon")
            // 导航栏左右item间距
            configure.gk_disableFixSpace = true
            configure.gk_navItemRightSpace = 10
            configure.gk_hidesBottomBarWhenPushed = true
            configure.gk_openScrollViewGestureHandle = true
        }
    }


}
