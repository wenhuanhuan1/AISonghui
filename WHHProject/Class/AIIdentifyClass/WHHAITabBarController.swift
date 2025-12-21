//
//  WHHAITabBarController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class WHHAITabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color0F0F12

       
        
        let shibieVC = WHHAIIdentifyHomeViewController()

        addChildViewController(vc: shibieVC, navTitle: "说梦", normalImage: "tabbarHomeNormal", seletImage: "tabbarHomeSelect")

        let shibieVC1 = WHHAIFlowerbedViewController()

        addChildViewController(vc: shibieVC1, navTitle: "画廊", normalImage: "tabbarPNormal", seletImage: "tabbarPSelect")

        let recordVC = WHHAIIdentifyMineViewController()

        addChildViewController(vc: recordVC, navTitle: "我的", normalImage: "tabbarRecordNormal", seletImage: "tabbarRecordSelect")
        tabBar.isTranslucent = false
        tabBar.backgroundColor = Color0F0F12
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.3)
        tabBar.backgroundImage = nil
        tabBar.tintColor = .white
        
        
    }

    private func addChildViewController(vc: UIViewController, navTitle: String, normalImage: String, seletImage: String) {
        vc.title = navTitle
        vc.tabBarItem.image = UIImage(named: normalImage)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: seletImage)?.withRenderingMode(.alwaysOriginal)

        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.3), .font: pingfangMedium(size: 10)!], for: .normal)

        vc.tabBarItem.setTitleTextAttributes([.foregroundColor:
                                                UIColor.white, .font: pingfangMedium(size: 10)!], for: .selected)
        let navViewController = WHHNavigationController(rootViewController: vc)
        addChild(navViewController)
    }

}
