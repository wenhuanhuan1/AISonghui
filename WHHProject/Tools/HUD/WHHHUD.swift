//
//  WHHHUD.swift
//  WHHProject
//
//  Created by wenhuan on 2025/6/10.
//

import UIKit
import MBProgressHUD
@objcMembers
class WHHHUD: NSObject {

    class func whhShowInfoText(text: String) {
        DispatchQueue.main.async {
            guard let window = UIWindow.getKeyWindow else { return }

            let progressHUD = MBProgressHUD(view: window)
            window.addSubview(progressHUD)
            progressHUD.removeFromSuperViewOnHide = true
            progressHUD.mode = .text
            progressHUD.bezelView.style = .solidColor
            progressHUD.detailsLabel.text = text
            progressHUD.bezelView.backgroundColor = .black.withAlphaComponent(0.8)
            progressHUD.detailsLabel.textColor = .white
            progressHUD.detailsLabel.font = UIFont.boldSystemFont(ofSize: 18)
            progressHUD.isUserInteractionEnabled = false
            progressHUD.animationType = .fade
            progressHUD.show(animated: true)
            progressHUD.hide(animated: true, afterDelay: 1)
        }
    }

    /// 加载转圈圈的
    /// - Parameter text: 参数
    class func whhShowLoadView(text: String? = nil) {
        DispatchQueue.main.async {
            guard let window = UIWindow.getKeyWindow else { return }

            let progressHUD = MBProgressHUD(view: window)
            window.addSubview(progressHUD)
            progressHUD.removeFromSuperViewOnHide = true
            progressHUD.mode = .indeterminate
            progressHUD.bezelView.style = .solidColor
            progressHUD.detailsLabel.text = text
            progressHUD.bezelView.backgroundColor = .black.withAlphaComponent(0.8)
            progressHUD.bezelView.color = .white
            progressHUD.detailsLabel.textColor = .white
            progressHUD.detailsLabel.font = UIFont.boldSystemFont(ofSize: 18)
            progressHUD.isUserInteractionEnabled = false
            progressHUD.animationType = .fade
            progressHUD.show(animated: true)
        }
    }

    class func whhHidenLoadView() {
        DispatchQueue.main.async {
            guard let window = UIWindow.getKeyWindow else { return }
            MBProgressHUD.hide(for: window, animated: true)
        }
    }
    
}
