//
//  WHHAISubscriptionView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/11/18.
//

import UIKit

class WHHAISubscriptionView: UIView {
    var didCancleButtonBlock: (() -> Void)?

    var didSubmitButtonBlock: (() -> Void)?

    @IBOutlet var tipsLabel: UILabel!
    @IBOutlet var twoView: UIView!

    @IBOutlet var oneView: UIView!

    @IBOutlet var fourView: UIView!

    @IBOutlet var threeView: UIView!

    @IBOutlet var oneLabel: UILabel!

    @IBOutlet var threeLabel: UILabel!

    @IBOutlet var fourLabel: UILabel!
    @IBOutlet var twoLabel: UILabel!
    @IBOutlet var cancleButton: UIButton!
    @IBOutlet var bgView: UIView!

    @IBOutlet var submit: UIButton!
    @IBOutlet var cancleButtonClick: UIButton!

    @IBOutlet var submitButtonClick: UIButton!

    func loadXib() -> WHHAISubscriptionView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! WHHAISubscriptionView

        view.cancleButton.layer.cornerRadius = 22
        view.cancleButton.layer.masksToBounds = true

        view.twoView.layer.cornerRadius = 12
        view.twoView.layer.masksToBounds = true

        view.oneView.layer.cornerRadius = 12
        view.oneView.layer.masksToBounds = true

        view.threeView.layer.cornerRadius = 12
        view.threeView.layer.masksToBounds = true

        view.fourView.layer.cornerRadius = 12
        view.fourView.layer.masksToBounds = true

        view.submit.layer.cornerRadius = 22
        view.submit.layer.masksToBounds = true

        view.bgView.layer.cornerRadius = 12
        view.bgView.layer.masksToBounds = true

        return view
    }

    @IBAction func cancleBttonClick(_ sender: UIButton) {
        didCancleButtonBlock?()
        removeFromSuperview()
    }

    @IBAction func submitButtonClick(_ sender: Any) {
        didSubmitButtonBlock?()
        removeFromSuperview()
    }
}
