//
//  WHHSetView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/28.
//

import UIKit

class WHHAgeItemView: WHHBaseView {
    lazy var leftTitle: UILabel = {
        let leftTitle = UILabel()
        leftTitle.whhSetLabel(textContent: "".localized, color: Color2C2B2D, numberLine: 0, textFont: pingfangRegular(size: 14)!, textContentAlignment: .center)
        return leftTitle
    }()

    lazy var rightTitle: UILabel = {
        let rightTitle = UILabel()
        rightTitle.whhSetLabel(textContent: "".localized, color: Color6A6A6B, numberLine: 0, textFont: pingfangRegular(size: 14)!, textContentAlignment: .center)
        return rightTitle
    }()

    override func setupViews() {
        super.setupViews()
        addSubview(rightTitle)
        rightTitle.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        addSubview(leftTitle)
        leftTitle.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(rightTitle.snp.left).offset(10)
        }
    }
}

class WHHCustomButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(colours: [Color67A9FF, Color6D64FF], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 1))
    }
}

class WHHCustomButtonView: WHHBaseView {
    var didWHHButtonBlock: (() -> Void)?

    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(whhButtonClick), for: .touchUpInside)
        return button
    }()

    lazy var icon: WHHBaseImageView = {
        let icon = WHHBaseImageView()
        icon.image = UIImage(named: "whhSetDefaultIcon")
        return icon
    }()

    override func setupViews() {
        super.setupViews()
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }

    @objc func whhButtonClick() {
        didWHHButtonBlock?()
    }
}

class WHHSetView: WHHBaseView {
    var logoFileId = ""

    var gender = 1

    var birthday = ""

    lazy var centrView: UIView = {
        let centrView = UIView()
        centrView.backgroundColor = .clear
        return centrView
    }()

    lazy var avatarIcon: WHHCustomButtonView = {
        let avatarIcon = WHHCustomButtonView()
        avatarIcon.didWHHButtonBlock = {
        }
        return avatarIcon
    }()

    lazy var whhContentView: UIView = {
        let whhContentView = UIView()
        whhContentView.backgroundColor = .white
        whhContentView.layer.cornerRadius = 24
        whhContentView.layer.masksToBounds = true
        return whhContentView
    }()

    lazy var titleLabel: WHHLabel = {
        let titleLabel = WHHLabel()
        titleLabel.whhSetLabel(textContent: "whhSetBigTitleKey".localized, color: Color746CF7, numberLine: 0, textFont: pingfangRegular(size: 12)!, textContentAlignment: .center)
        return titleLabel
    }()

    lazy var sexLabel: WHHLabel = {
        let sexLabel = WHHLabel()
        sexLabel.whhSetLabel(textContent: "whhSetSexDesTitleKey".localized, color: Color746CF7, numberLine: 0, textFont: pingfangRegular(size: 12)!, textContentAlignment: .center)
        return sexLabel
    }()

    lazy var editButton: UIButton = {
        let editButton = UIButton(type: .custom)
        editButton.setTitle("whhSetChangeButtonTitleKey".localized, for: .normal)
        editButton.backgroundColor = Color746CF7
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = pingfangRegular(size: 15)
        editButton.layer.cornerRadius = 18
        editButton.layer.masksToBounds = true
        editButton.addTarget(self, action: #selector(changeAvatarButtonClick), for: .touchUpInside)
        return editButton
    }()

    lazy var headLabel: WHHLabel = {
        let headLabel = WHHLabel()
        headLabel.whhSetLabel(textContent: "whhSetAvatarTitleKey".localized, color: Color2C2B2D, numberLine: 0, textFont: pingfangMedium(size: 18)!, textContentAlignment: .center)
        return headLabel
    }()

    lazy var desLabel: WHHLabel = {
        let desLabel = WHHLabel()
        desLabel.whhSetLabel(textContent: "whhSetAvatarDesTitleKey".localized, color: Color2C2B2D, numberLine: 0, textFont: pingfangRegular(size: 12)!, textContentAlignment: .center)
        return desLabel
    }()

    lazy var topIcon: UIImageView = {
        let topIcon = UIImageView()
        topIcon.image = UIImage(named: "whhSetTopIcon")
        return topIcon
    }()

    lazy var sexButton: UIButton = {
        let sexButton = UIButton()
        sexButton.backgroundColor = ColorF2F4FE
        sexButton.layer.cornerRadius = 22
        sexButton.layer.borderWidth = 1
        sexButton.layer.borderColor = Color66666.cgColor
        sexButton.layer.masksToBounds = true
        sexButton.setTitle("whhSetSexMaleTitleKey".localized, for: .normal)
        sexButton.setTitle("whhSetFemaleMaleTitleKey".localized, for: .selected)
        sexButton.titleLabel?.font = pingfangRegular(size: 16)
        sexButton.setTitleColor(Color2C2B2D, for: .normal)
        sexButton.setImage(UIImage(named: "whhBlueMaleIcon"), for: .normal)
        sexButton.setImage(UIImage(named: "whhSetFemaleIcon"), for: .selected)
        return sexButton
    }()

    lazy var sexBgButton: UIButton = {
        let sexBgButton = UIButton()
        sexBgButton.addTarget(self, action: #selector(changeSexButtonClick), for: .touchUpInside)
        return sexBgButton
    }()

    lazy var ageTipsLabel: WHHLabel = {
        let ageTipsLabel = WHHLabel()
        ageTipsLabel.whhSetLabel(textContent: "whhSetTipsTitleKey".localized, color: Color6A6A6B, numberLine: 0, textFont: pingfangRegular(size: 10)!, textContentAlignment: .center)
        return ageTipsLabel
    }()

    lazy var ageDesLabel: WHHLabel = {
        let ageDesLabel = WHHLabel()
        ageDesLabel.whhSetLabel(textContent: "whhSetAgeDesTitleKey".localized, color: Color2C2B2D, numberLine: 0, textFont: pingfangRegular(size: 12)!, textContentAlignment: .center)
        return ageDesLabel
    }()

    lazy var ageBgView: UIView = {
        let ageBgView = UIView()
        ageBgView.backgroundColor = ColorF2F4FE
        ageBgView.layer.cornerRadius = 22
        ageBgView.layer.borderWidth = 1
        ageBgView.layer.borderColor = Color6C73FF.cgColor
        ageBgView.layer.masksToBounds = true
        return ageBgView
    }()

    lazy var cancleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("whhCancleTitleKey".localized, for: .normal)
        button.titleLabel?.font = pingfangRegular(size: 14)
        button.setTitleColor(Color2C2B2D, for: .normal)
        button.backgroundColor = ColorEDEBEF
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        return button
    }()

    lazy var submitButton: WHHCustomButton = {
        let submitButton = WHHCustomButton(type: .custom)
        submitButton.setTitle("whhSaveTitleKey".localized, for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        return submitButton
    }()

    lazy var yearView: WHHAgeItemView = {
        let yearView = WHHAgeItemView()
        yearView.rightTitle.text = "whhYearKey".localized
        return yearView
    }()

    lazy var monthView: WHHAgeItemView = {
        let monthView = WHHAgeItemView()
        monthView.rightTitle.text = "whhMonthKey".localized
        return monthView
    }()

    lazy var dayView: WHHAgeItemView = {
        let dayView = WHHAgeItemView()
        dayView.rightTitle.text = "whhDayKey".localized
        return dayView
    }()

    override func setupViews() {
        super.setupViews()
        frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        backgroundColor = .black.whhAlpha(alpha: 0.6)
        addSubview(centrView)
        centrView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(325)
            make.height.equalTo(648)
        }
        centrView.addSubview(topIcon)
        topIcon.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(140)
        }
        centrView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(62)
        }
        centrView.addSubview(whhContentView)
        whhContentView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(102)
        }
        whhContentView.addSubview(headLabel)
        headLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(16)
        }
        whhContentView.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(headLabel.snp.bottom).offset(6)
        }
        whhContentView.addSubview(avatarIcon)
        avatarIcon.snp.makeConstraints { make in
            make.size.equalTo(94)
            make.centerX.equalToSuperview()
            make.top.equalTo(desLabel.snp.bottom).offset(10)
        }
        whhContentView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(74)
            make.height.equalTo(36)
            make.top.equalTo(avatarIcon.snp.bottom).offset(10)
        }
        whhContentView.addSubview(sexLabel)
        sexLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(editButton.snp.bottom).offset(34)
        }

        whhContentView.addSubview(sexButton)
        sexButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
            make.top.equalTo(sexLabel.snp.bottom).offset(12)
        }
        whhContentView.addSubview(sexBgButton)
        sexBgButton.snp.makeConstraints { make in
            make.edges.equalTo(sexButton)
        }

        whhContentView.addSubview(ageDesLabel)
        ageDesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(sexButton.snp.bottom).offset(16)
        }
        whhContentView.addSubview(ageBgView)
        ageBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
            make.top.equalTo(ageDesLabel.snp.bottom).offset(16)
        }

        ageBgView.addSubview(yearView)
        yearView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.top.bottom.equalToSuperview()
        }

        ageBgView.addSubview(monthView)
        monthView.snp.makeConstraints { make in
            make.left.equalTo(yearView.snp.right)
            make.width.equalTo(yearView)
            make.top.bottom.equalToSuperview()
        }
        ageBgView.addSubview(dayView)
        dayView.snp.makeConstraints { make in
            make.left.equalTo(monthView.snp.right)
            make.width.equalTo(monthView)
            make.right.equalToSuperview().offset(-19)
            make.top.bottom.equalToSuperview()
        }
        let ageButton = UIButton(type: .custom)
        ageButton.addTarget(self, action: #selector(ageButtonClick), for: .touchUpInside)

        ageBgView.addSubview(ageButton)
        ageButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        whhContentView.addSubview(ageTipsLabel)
        ageTipsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(ageBgView.snp.bottom).offset(16)
        }
        whhContentView.addSubview(cancleButton)
        whhContentView.addSubview(submitButton)
        cancleButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        submitButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.left.equalTo(cancleButton.snp.right).offset(20)
            make.bottom.width.height.equalTo(cancleButton)
        }

        setDefauleValue()
    }

    private func setDefauleValue() {
        let currentDate = getCurrentDate()
        let segmentationStr = segmentationCharacter(needString: currentDate)
        let year = segmentationStr[0]
        let month = segmentationStr[1]
        let day = segmentationStr[2]

        yearView.leftTitle.text = year
        monthView.leftTitle.text = month
        dayView.leftTitle.text = day
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @objc func changeSexButtonClick() {
        let chooseView = WHHChooseSexView()
        if gender == 1 {
            chooseView.maleItemView.isSelect = true
        } else if gender == 2 {
            chooseView.femaleItemView.isSelect = true
        }
        chooseView.didWHHChooseSexView = { [weak self] sexType in

            self?.gender = sexType
            if sexType == 1 {
                self?.sexButton.isSelected = false
            } else if sexType == 2 {
                self?.sexButton.isSelected = true
            }
        }
        addSubview(chooseView)
    }

    @objc func ageButtonClick() {
        let pickerView = WHHDatePicker { [weak self] date, dateString in

            debugPrint("当前选择的日期\(date),\(dateString)")
            let segmentationStr = self?.segmentationCharacter(needString: dateString)
            let year = segmentationStr?[0]
            let month = segmentationStr?[1]
            let day = segmentationStr?[2]

            self?.yearView.leftTitle.text = year
            self?.monthView.leftTitle.text = month
            self?.dayView.leftTitle.text = day
            self?.birthday = dateString
        }
        pickerView.show()
    }

    @objc func cancleButtonClick() {
        removeFromSuperview()
    }

    @objc func saveButtonClick() {
        let dict = ["api-v": "1.0", "userId": WHHUserInfoManager.shared.userId, "logoFileId": logoFileId, "gender": gender, "birthday": birthday, "starSign": ""] as [String: Any]
        WHHHUD.whhShowLoadView()
        WHHHomeRequestViewModel.whhModificationPersonInfo(dict: dict) { [weak self] success in
            if success == 1 {
                dispatchAfter(delay: 0.5) {
                    WHHHUD.whhShowInfoText(text: "修改成功")
                    self?.removeFromSuperview()
                }
            }
        }
    }

    private func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)

        return dateString
    }

    private func segmentationCharacter(needString: String) -> [String] {
        let result = needString.components(separatedBy: "-")

        return result
    }

    @objc func changeAvatarButtonClick() {
        WHHMediaManager.shared.whhGetOnePhoto { [weak self] image in

            if let imageData = image.pngData() {
                WHHHUD.whhShowLoadView()
                WHHHomeRequestViewModel.whhUploadSourceWithType(type: 1, data: imageData) { file in
                    WHHHUD.whhHidenLoadView()
                    if file.isEmpty == false {
                        self?.logoFileId = file
                        self?.avatarIcon.icon.whhSetKFWithImage(imageString: file)
                    } else {
                        dispatchAfter(delay: 0.5) {
                            WHHHUD.whhShowInfoText(text: "上传错误")
                        }
                    }
                }
            }
        }
    }
}
