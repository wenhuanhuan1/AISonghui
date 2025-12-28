//
//  WHHAIGallerySetCenterViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class WHHAIGallerySetCenterViewController: WHHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navigationBar.isHidden = false
        gk_navTitle = "设置中心"
        stayle = .lightContent

    }

    @IBAction func buttonClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 1000:
            WHHHUD.whhShowInfoText(text: "恢复购买成功")
        case 2000:
            
            let pad = UIPasteboard.general
            pad.string = "MySecret_Home@163.com"
            
            WHHHUD.whhShowInfoText(text: "邮箱已复制 您对「阿贝贝」有任何疑问，请通过邮箱：MySecret_Home@163.com 与我们联系，非常感谢您对我们的支持")
        case 3000:
            let webView = WHHWKWebViewViewController(url: "https://abeibei.vip/terms.html")
            navigationController?.pushViewController(webView, animated: true)
        default:
            let webView = WHHWKWebViewViewController(url: "https://abeibei.vip/privacy.html")
            navigationController?.pushViewController(webView, animated: true)
        }
        
    }
    
}
