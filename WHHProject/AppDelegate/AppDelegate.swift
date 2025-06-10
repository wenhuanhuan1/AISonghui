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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initLibs()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.backgroundColor = .white
        window?.rootViewController = WHHTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

