//
//  WHHLookPhotoViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHLookPhotoViewController: WHHBaseViewController {
    var deletePhoto: (() -> Void)?
    lazy var bigImageView: WHHBaseImageView = {
        let bigImageView = WHHBaseImageView()
        return bigImageView
    }()

    private(set) var image: UIImage?

    init(photo: UIImage) {
        super.init(nibName: nil, bundle: nil)
        image = photo
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("删除".localized, for: .normal)
        backButton.titleLabel?.font = pingfangRegular(size: 14)
        backButton.setTitleColor(Color2C2B2D, for: .normal)
        backButton.backgroundColor = ColorEDEBEF
        backButton.layer.cornerRadius = 22
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return backButton
    }()

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("更换", for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        gk_backStyle = .white
        view.backgroundColor = .black
        view.addSubview(bigImageView)
        bigImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(WHHAllNavBarHeight)
            make.height.equalTo(WHHScreenW)
        }
        bigImageView.image = image
        view.addSubview(backButton)

        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 10)
        }
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(12)
            make.right.equalToSuperview().offset(-26)
            make.height.width.bottom.equalTo(backButton)
        }
    }

    @objc func backButtonClick() {
        deletePhoto?()
        navigationController?.popViewController(animated: true)
    }

    @objc func submitButtonClick() {
        WHHMediaManager.whhGetAlbumOnlyOnePhoto(viewController: self) { [weak self] image in
            self?.bigImageView.image = image
            // 更新上一个数据
            NotificationCenter.default.post(name: NSNotification.Name("whhUploadPhotoKey"), object: self, userInfo: ["image": image])
        }
    }
}
