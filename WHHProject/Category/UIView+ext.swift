//
//  UIView+ext.swift
//  WHHProject
//
//  Created by wenhuan on 2025/9/29.
//

import Foundation

import GPUImage
extension UIView {
    /// 给任意 UIView 添加 GPUImage 毛玻璃效果
    /// - Parameter radius: 模糊半径 (推荐 5 ~ 20)
    func addGPUImageBlur(radius: CGFloat) {
        // 先截取当前 View 的快照
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let inputImage = snapshot else { return }
        
        // GPUImage 毛玻璃滤镜
        let blurFilter = GPUImageGaussianBlurFilter()
        blurFilter.blurRadiusInPixels = 10.0 // 模糊半径
        blurFilter.texelSpacingMultiplier = 2.0 // 纹理间距
        blurFilter.blurRadiusInPixels = radius
        blurFilter.texelSpacingMultiplier = 2.0 // 纹理间距
        // 生成模糊图像
        let blurredImage = blurFilter.image(byFilteringImage: inputImage)
        
        // 创建 UIImageView 显示模糊效果
        let blurView = UIImageView(frame: self.bounds)
        blurView.image = blurredImage
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 9999   // 方便以后移除
        self.addSubview(blurView)
        self.bringSubviewToFront(blurView)
    }
    
    /// 移除 GPUImage 毛玻璃效果
    func removeGPUImageBlur() {
        if let blurView = self.viewWithTag(9999) {
            blurView.removeFromSuperview()
        }
    }
    
    func addShadow(color: UIColor = .black,
                      opacity: Float = 0.3,
                      offset: CGSize = .zero,
                      radius: CGFloat = 6) {
           self.layer.shadowColor = color.cgColor
           self.layer.shadowOpacity = opacity
           self.layer.shadowOffset = offset
           self.layer.shadowRadius = radius
           self.layer.masksToBounds = false
       }
    
    func addGradientBackground(colors: [UIColor],
                               startPoint: CGPoint = CGPoint(x: 0, y: 0),
                               endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        // 移除旧的渐变层，避免重复叠加
        layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
