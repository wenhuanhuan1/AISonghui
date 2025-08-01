//
//  WHHContactUsViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//


import UIKit
class WHHContactUsViewController: WHHBaseViewController {
    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("提交", for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    @IBOutlet var smallIcon: UIImageView!
    @IBOutlet var placeHodelLabel: UILabel!

    @IBOutlet var bigIconImageView: UIImageView!
    @IBOutlet var smallLabel: UILabel!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var submitView: UIView!
    @IBOutlet var feedBackBgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_backStyle = .white
        gk_navTitle = ""
        feedBackBgView.layer.borderWidth = 1
        feedBackBgView.layer.borderColor = ColorBDBCC1.cgColor
        submitView.addSubview(submitButton)
        inputTextView.delegate = self
        submitButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(whhUploadPhoto(obj:)), name: NSNotification.Name("whhUploadPhotoKey"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isIQKeyboardManagerIsEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isIQKeyboardManagerIsEnabled = false
    }

    @objc func whhUploadPhoto(obj: NSNotification) {
        if let userInfo = obj.userInfo,
           let image = userInfo["image"] as? UIImage {
            bigIconImageView.image = image
            smallIcon.isHidden = true
            smallLabel.isHidden = true
        }
    }

    @IBAction func backButtonClick(_ sender: UIButton) {
    }

    @IBAction func selectPhotoButtonClick(_ sender: UIButton) {
       

        if bigIconImageView.image != nil {
            let lookVC = WHHLookPhotoViewController(photo: bigIconImageView.image!)
            lookVC.deletePhoto = { [weak self] in

                self?.bigIconImageView.image = nil
                self?.smallIcon.isHidden = false
                self?.smallLabel.isHidden = false
            }
            navigationController?.pushViewController(lookVC, animated: true)
        }else{
            WHHMediaManager.whhGetAlbumOnlyOnePhoto(viewController: self) { [weak self] image in
                self?.smallIcon.isHidden = true
                self?.smallLabel.isHidden = true
                self?.bigIconImageView.image = image
            }
        }
    }

    @objc func submitButtonClick() {
        if let inputText = inputTextView.text, inputText.isEmpty == false {
            debugPrint("哈哈哈提交了")
            
            let alertView = WHHAgainAlertView()
            view.addSubview(alertView)
            
        } else {
            WHHHUD.whhShowInfoText(text: "请输入建议")
        }
    }
}

extension WHHContactUsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHodelLabel.isHidden = !textView.text.isEmpty
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 200 // 限制100字符
    }
}
