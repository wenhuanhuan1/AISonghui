//
//  WHHABBHomeViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHABBHomeViewController: WHHBaseViewController {
    @IBOutlet var inputBgView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var textLabel: UILabel!

    lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: .custom)
        rightButton.setBackgroundImage(UIImage(named: "whhAbbHomeRightIcon"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return rightButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        inputBgView.layer.borderWidth = 1
        inputBgView.layer.borderColor = Color6C73FF.cgColor
        gk_navRightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }

    @IBAction func didInputeBarButtonClick(_ sender: UIButton) {
        let inputBarView = WHHABBInputBarView(frame: CGRectMake(0, 0, WHHScreenW, WHHScreenH))
        inputBarView.didInputeSendMsg = { msg in

            debugPrint("哈哈哈这是输入的内容\(msg)")
        }
        view.addSubview(inputBarView)
    }

    @objc func rightButtonClick() {
        
    }
}
