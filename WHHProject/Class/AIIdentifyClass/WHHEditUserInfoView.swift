//
//  WHHEditUserInfoView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/21.
//

import UIKit

class WHHEditUserInfoView: WHHBaseView {
    lazy var inputBgView: UIView = {
        let a = UIView()
        a.backgroundColor = Color414348
        a.layer.cornerRadius = 8
        return a
    }()

    var userInfo: FCMineModel? {
        didSet {
            guard let model = userInfo else { return }
            avatar.whhSetImageView(url: model.logo)
            logoFileId = model.logo
            inputTF.text = model.nickname
        }
    }

    private(set) var logoFileId: String?

    lazy var title: UILabel = {
        let a = UILabel()
        a.text = "编辑资料"
        a.textAlignment = .center
        a.font = pingfangSemibold(size: 18)
        a.textColor = .white
        return a
    }()

    lazy var inputTF: UITextField = {
        let a = UITextField()
        a.textColor = .white
        a.font = pingfangRegular(size: 14)
        a.attributedPlaceholder = NSAttributedString(
            string: "请输入昵称",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: pingfangRegular(size: 14)
            ]
        )
        return a
    }()

    lazy var avatar: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.layer.cornerRadius = 36
        a.layer.borderWidth = 1
        a.layer.borderColor = UIColor.white.cgColor
        a.layer.masksToBounds = true
        return a
    }()

    lazy var submit: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("保存", for: .normal)
        a.titleLabel?.font = pingfangMedium(size: 14)
        a.setTitleColor(Color1E2024, for: .normal)
        a.layer.cornerRadius = 26
        a.backgroundColor = .white
        a.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var closeButton: UIButton = {
        let a = UIButton(type: .custom)
        a.setImage(UIImage(named: "editButtonClose"), for: .normal)
        a.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return a
    }()

    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = Color2B2D33
        return bottomView
    }()

    lazy var cameraIcon: WHHBaseImageView = {
        let a = WHHBaseImageView()
        a.image = UIImage(named: "editCameraIcon")
        return a
    }()

    lazy var iconButton: UIButton = {
        let a = UIButton(type: .close)
        a.addTarget(self, action: #selector(selectIconButtonClick), for: .touchUpInside)
        return a
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = Color0F0F12.withAlphaComponent(0.6)
        addSubview(bottomView)
        bottomView.frame = CGRectMake(0, WHHScreenH - (314 + WHHBottomSafe), WHHScreenW, 314 + WHHBottomSafe)
        bottomView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        bottomView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        bottomView.addSubview(submit)
        submit.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-WHHBottomSafe - 10)
        }

        bottomView.addSubview(inputBgView)
        inputBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(53)
            make.bottom.equalTo(submit.snp.top).offset(-24)
        }

        inputBgView.addSubview(inputTF)
        inputTF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }

        bottomView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.size.equalTo(72)
            make.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(24)
        }
        bottomView.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.bottom.equalTo(avatar)
        }
        avatar.addSubview(iconButton)
        iconButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameChanged(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        addTapToDismissKeyboard()
    }

    private func addTapToDismissKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false // ⚠️ 不拦截按钮点击
        addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        inputTF.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bottomView.whhAddSetRectConrner(corner: [.topLeft, .topRight], radile: 12)
    }

    @objc func closeButtonClick() {
        removeFromSuperview()
    }

    @objc func selectIconButtonClick() {
        WHHMediaManager.whhGetAlbumOnlyOnePhoto { [weak self] image in

            if let imageData = image.pngData() {
                WHHHUD.whhShowLoadView()
                WHHHomeRequestViewModel.whhUploadSourceWithType(type: 4, data: imageData) { file in
                    WHHHUD.whhHidenLoadView()
                    if file.isEmpty == false {
                        self?.logoFileId = file
                        self?.avatar.whhSetKFWithImage(imageString: file)
                    } else {
                        dispatchAfter(delay: 0.5) {
                            WHHHUD.whhShowInfoText(text: "上传错误")
                        }
                    }
                }
            }
        }
    }

    @objc private func keyboardFrameChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        // 键盘最终 frame（屏幕坐标）
        let endFrame =
            (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                .cgRectValue ?? .zero

        // 动画时长
        let duration =
            userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

        // 动画曲线
        let curveRaw =
            userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)

        // 键盘高度（自动区分弹起 / 收起）
        let keyboardHeight = max(
            0,
            UIScreen.main.bounds.height - endFrame.origin.y
        )

        UIView.animate(withDuration: duration, delay: 0, options: curve) {
          
            self.bottomView.frame = CGRectMake(0, WHHScreenH - (314 + WHHBottomSafe + keyboardHeight), WHHScreenW, 314 + WHHBottomSafe)
            
            self.layoutIfNeeded()
        }
    }

    @objc func submitButtonClick() {
        guard let inputText = inputTF.text, inputText.isEmpty == false else {
            WHHHUD.whhShowInfoText(text: "请输入昵称")
            return
        }
        guard let infoAvatar = logoFileId else {
            WHHHUD.whhShowInfoText(text: "请选择图片")
            return
        }
        let dict = ["api-v": "1.0", "userId": WHHUserInfoManager.shared.userId, "logoFileId": infoAvatar, "nickname": inputText] as [String: Any]

        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhModificationPersonInfo(dict: dict) { [weak self] success, msg in
            WHHHUD.whhHidenLoadView()
            if success == 1 {
                NotificationCenter.default.post(name: NSNotification.Name("uploadUserInfo"), object: nil)
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: "修改成功")
                    self?.removeFromSuperview()
                }
            } else {
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: msg)
                }
            }
        }
    }
}
