//
//  WHHConf.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import Combine
import Foundation
import GKNavigationBarSwift
import SnapKit
import UIKit

let whhPlaceholderIamge = UIImage(named: "")

let WHHScreenW = UIScreen.main.bounds.size.width

let WHHScreenH = UIScreen.main.bounds.size.height

func WHHScreenScale(scale: CGFloat) -> CGFloat {
    return scale * WHHScreenW / 375.0
}

let IsBangsScreen = WHHScreenH > 736.0

let WHHNoSafeTabBarHeight = 49.0

let WHHBottomSafe: CGFloat = {
    var diffH: CGFloat
    if IsBangsScreen {
        diffH = 34.0
    } else {
        diffH = 0
    }
    if let window = UIWindow.getKeyWindow {
        return window.safeAreaInsets.bottom
    }
    return diffH
}()

let WHHTabBarHeight = WHHNoSafeTabBarHeight + WHHBottomSafe

let WHHTopSafe: CGFloat = {
    var statusBarH: CGFloat = 0.0
    if let window = UIWindow.getKeyWindow, let statusBarManager = window.windowScene?.statusBarManager {
        statusBarH = statusBarManager.statusBarFrame.height
    }
    return statusBarH
}()

let WHHNavBarHeight = 44.0

let WHHAllNavBarHeight = WHHTopSafe + WHHNavBarHeight

func onMainThread(completion: @escaping () -> Void) {
    if isMainThread() {
        completion()
    } else {
        DispatchQueue.main.async {
            completion()
        }
    }
}

func isMainThread() -> Bool {
    return Thread.current.isMainThread
}

// 延迟操作
func dispatchAfter(delay: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        completion()
    }
}

/// swift的延迟操作
func swiftCombineAfter(delay: Double, completion: @escaping () -> Void) {
    var cancellables = Set<AnyCancellable>()

    Timer.publish(every: delay, on: .main, in: .common)
        .autoconnect()
        .sink { _ in
            completion()
        }
        .store(in: &cancellables)
}

/// 时间转换
func WHHAITransToHourMinSec(time: String) -> String {
    let allTime: Int = Int(time) ?? 0
    var hours = 0
    var minutes = 0
    var seconds = 0
    var hoursText = ""
    var minutesText = ""
    var secondsText = ""

    hours = allTime / 3600
    hoursText = hours > 9 ? "\(hours)" : "0\(hours)"

    minutes = allTime % 3600 / 60
    minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"

    seconds = allTime % 3600 % 60
    secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"

    if hours > 0 {
        return "\(hoursText):\(minutesText):\(secondsText)"
    } else {
        return "\(minutesText):\(secondsText)"
    }
}

extension UIView {
    /// 设置渐变
    func applyGradient(colours: [UIColor], startPoint: CGPoint = CGPointMake(0, 0), endPoint: CGPoint = CGPointMake(1, 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colours.map { $0.cgColor }
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func whhAddShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func whhAddSetRectConrner(corner: UIRectCorner, radile: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSizeMake(radile, radile))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

extension UIColor {
    func whhAlpha(alpha: CGFloat) -> UIColor {
        withAlphaComponent(alpha)
    }
}
