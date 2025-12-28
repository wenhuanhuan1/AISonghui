//
//  WHHIShareAndDeletAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/28.
//

import UIKit

class WHHIShareAndDeletAlertView: UIView {
    var didShareButtonBlock: (() -> Void)?
    var didDeleteButtonBlock: (() -> Void)?
    @IBOutlet var bgView: UIView!

    
    
    func whhLoadXib() -> WHHIShareAndDeletAlertView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! WHHIShareAndDeletAlertView
        view.frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
       
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.whhAddSetRectConrner(corner: [.topLeft, .topRight], radile: 16)
    }

    @IBAction func deleteButtonClick(_ sender: UIButton) {
        didDeleteButtonBlock?()
        removeFromSuperview()
    }

    @IBAction func shareButtonClick(_ sender: UIButton) {
        didShareButtonBlock?()
        removeFromSuperview()
    }

    @IBAction func cancleButtonClick(_ sender: UIButton) {
        removeFromSuperview()
    }
}
