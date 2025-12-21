//
//  WHHIdAlertView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class WHHIdAlertView: UIView {

    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var didSubmitBtnBlock:((WHHIdAlertView)->Void)?
    
    @IBOutlet weak var desTitle: UILabel!
    func whhLoadXib() -> WHHIdAlertView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! WHHIdAlertView
        view.frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        view.cancleBtn.layer.borderColor = UIColor.white.cgColor
        view.cancleBtn.layer.borderWidth = 1
        view.cancleBtn.layer.cornerRadius = 20
        view.cancleBtn.layer.masksToBounds = true
        return view
    }
    
    @IBAction func submitButtonClick(_ sender: UIButton) {
        
        didSubmitBtnBlock?(self)
    }
    
    func closeMethod() {
        
        removeFromSuperview()
    }
    
    @IBAction func cancleButtonClick(_ sender: UIButton) {
        
        closeMethod()
    }
}
