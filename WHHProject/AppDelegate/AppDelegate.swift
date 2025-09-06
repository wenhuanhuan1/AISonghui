//
//  AppDelegate.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var noNetAlertView: WHHNoNetAlertView = {
        let noNetAlertView = WHHNoNetAlertView()
        noNetAlertView.isHidden = true
        noNetAlertView.didSubmitBlock = { [weak self] _ in
            self?.jumpSetOpenNetJurisdiction()
        }
        noNetAlertView.againSubmitBlock = { [weak self] _ in
            self?.checkNetJurisdiction()
        }
        return noNetAlertView
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.backgroundColor = .white
        initLibs()

        window?.rootViewController = WHHRootViewController()
        switchRootViewController()
        window?.makeKeyAndVisible()
        window?.addSubview(noNetAlertView)
        checkNetJurisdiction()

        return true
    }

    func switchRootViewController() {
        if WHHUserInfoManager.shared.isLogin {
            window?.rootViewController = WHHNavigationController(rootVC: WHHHomeViewController())
        } else {
            WHHHUD.whhShowLoadView()

            WHHHomeRequestViewModel.whhGetSystemInfoRequestApi { _ in
                
                WHHHomeRequestViewModel.whhLoginRequest { [weak self] finish in
                    WHHHUD.whhHidenLoadView()
                    if finish {
                        if WHHUserInfoManager.shared.isShowpPrivacyAlert {
                            if WHHUserInfoManager.shared.isLogin {
                                self?.window?.rootViewController = WHHNavigationController(rootVC: WHHHomeViewController())
                            } else {
                                self?.window?.rootViewController = WHHNavigationController(rootVC: WHHRootViewController())
                            }
                        }
                    }
                }
            }
        }
    }
}

extension AppDelegate {
    private func checkNetJurisdiction() {
        let manager = AFNetworkReachabilityManager.shared()
        manager.startMonitoring()
        manager.setReachabilityStatusChange { [weak self] status in
            if status.rawValue == 1 || status.rawValue == 2 {
                // 已经授权
                self?.noNetAlertView.isHidden = true
            } else {
                self?.noNetAlertView.isHidden = false
            }
        }
    }

    private func jumpSetOpenNetJurisdiction() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:]) { success in
                print("跳转设置成功: \(success)")
            }
        }
    }
}
