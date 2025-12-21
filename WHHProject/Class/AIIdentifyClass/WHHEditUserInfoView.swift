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
    
    var userInfo:FCMineModel? {
        
        didSet{
            guard let model = userInfo else { return }
            avatar.whhSetImageView(url: model.logo)
        }
        
    }
    
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
        a.placeholder = "请输入昵称"
        a.textColor = .white
        a.font = pingfangRegular(size: 14)
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
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(314+WHHBottomSafe)
        }
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
            make.bottom.equalToSuperview().offset(-WHHBottomSafe-10)
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomView.whhAddSetRectConrner(corner: [.topLeft,.topRight], radile: 12)
    }
    
    @objc func closeButtonClick() {
        
        removeFromSuperview()
    }
    
    @objc func selectIconButtonClick() {
        
        WHHMediaManager.shared.whhGetOnePhoto {[weak self] image in
            self?.avatar.image = image
        }
        
    }
    
    @objc func submitButtonClick() {
        
        guard let inputText = inputTF.text,inputText.isEmpty == false else {
            WHHHUD.whhShowInfoText(text: "请输入昵称")
            return }
        guard let infoAvatar = avatar.image else {
            WHHHUD.whhShowInfoText(text: "请选择图片")
            return }
        WHHHUD.whhShowLoadView()
        
        
//        
//        WHHHomeRequestViewModel.whhModificationPersonInfo(dict: <#T##[String : Any]#>) { <#Int#>, <#String#> in
//            <#code#>
//        }
    }
}
