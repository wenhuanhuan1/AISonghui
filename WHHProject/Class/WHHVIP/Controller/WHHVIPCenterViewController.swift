//
//  WHHVIPCenterViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/3.
//

import UIKit

class WHHVIPCenterViewController: WHHBaseViewController {
    lazy var bgView: WHHVIPCenterBgView = {
        let bgView = WHHVIPCenterBgView()
        return bgView
    }()

    var didPuyFinish: (() -> Void)?

    var dataArray = [WHHVIPCenterModel]()

    lazy var submitButton: WHHGradientButton = {
        let submitButton = WHHGradientButton(type: .custom)
        submitButton.setTitle("解锁", for: .normal)
        submitButton.titleLabel?.font = pingfangRegular(size: 14)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 22
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        return submitButton
    }()

    @IBOutlet var closeButtonConf: NSLayoutConstraint!

    lazy var itemCollectionViw: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let paddig = (360 - 91 * 3 - 16 - 48) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 24)
        layout.minimumLineSpacing = CGFloat(paddig)
        layout.minimumInteritemSpacing = CGFloat(paddig)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 91, height: 100)
        let itemCollectionViw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        itemCollectionViw.delegate = self
        itemCollectionViw.dataSource = self
        itemCollectionViw.backgroundColor = .clear
        itemCollectionViw.showsHorizontalScrollIndicator = false
        itemCollectionViw.showsVerticalScrollIndicator = false
        itemCollectionViw.register(UINib(nibName: "WHHVIPCenterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WHHVIPCenterCollectionViewCell")

        return itemCollectionViw
    }()

    @IBOutlet var submitBgView: UIView!
    @IBOutlet var collectionBgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color5B5B8A
        gk_navigationBar.isHidden = true
//        gk_navTitle = ""
//        gk_backImage = UIImage(named: "back_grey copy")
//        view.addSubview(bgView)
//        bgView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        closeButtonConf.constant = WHHTopSafe
        submitBgView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionBgView.addSubview(itemCollectionViw)
        itemCollectionViw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        locationSelectOneData()
    }
    
    private func locationSelectOneData() {
        
        let selectModel = dataArray.first(where: {$0.code == "com.abb.AIProjectWeek"})
        selectModel?.isSelect = true
         itemCollectionViw.reloadData()
    }

    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc func submitButtonClick() {
        if let model = dataArray.first(where: { $0.isSelect }) {
            WHHApplePurchaseManager.shared.whhCreateOrderRequest(goodsId: model.productId, payPage: "不知道是啥")
            WHHApplePurchaseManager.shared.purchaseHandle = { [weak self] status in

                if status == .success {
                    self?.dismiss(animated: true)
                } else {
                }
            }
        }
    }
}

extension WHHVIPCenterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WHHVIPCenterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WHHVIPCenterCollectionViewCell", for: indexPath) as! WHHVIPCenterCollectionViewCell

        let model = dataArray[indexPath.row]

        cell.cellModel = model

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in dataArray {
            item.isSelect = false
        }
        let currentModel = dataArray[indexPath.row]
        currentModel.isSelect = true
        collectionView.reloadData()
    }
}
