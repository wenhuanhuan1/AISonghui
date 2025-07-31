//
//  WHHTabBarController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit

class WHHTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = self

        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = ColorFF4746
        viewControllers?.forEach {
            $0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        let homeVC = WHHHomeViewController()
        addChildViewController(vc: homeVC, navTitle: "whhHomeKey".localized, normalImage: "homeTabbarNormal", seletImage: "homeTabbarSelect")
        
//        let abbVC = WHHABBViewController()
//        addChildViewController(vc: abbVC, navTitle: "whhTabbarAbbKey".localized, normalImage: "homeTabbarNormal", seletImage: "homeTabbarSelect")
        
        let mineVC = WHHMineViewController()
        addChildViewController(vc: mineVC, navTitle: "whhTabbarMineKey".localized, normalImage: "homeTabbarNormal", seletImage: "homeTabbarSelect")
        
    }

    private func addChildViewController(vc: UIViewController, navTitle: String, normalImage: String, seletImage: String) {
        vc.title = navTitle
        vc.tabBarItem.image = UIImage(named: normalImage)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: seletImage)?.withRenderingMode(.alwaysOriginal)

        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: pingfangRegular(size: 11)!], for: .normal)

        vc.tabBarItem.setTitleTextAttributes([.foregroundColor:
                ColorFF4746, .font: pingfangRegular(size: 11)!], for: .selected)
        let navViewController = WHHNavigationController(rootVC: vc)
        addChild(navViewController)
    }
}

extension WHHTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
