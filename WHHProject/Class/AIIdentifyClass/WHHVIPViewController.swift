//
//  WHHVIPViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/21.
//

import UIKit

class WHHVIPViewController: WHHBaseViewController {
    @IBOutlet var collectionViewBg: UIView!

    var didPuyFinish: (() -> Void)?

    var dataArray = [WHHVIPCenterModel]()

    lazy var itemCollectionViw: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let w = (WHHScreenW - 48) / 3
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: w, height: w * 120 / 122)
        let itemCollectionViw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        itemCollectionViw.delegate = self
        itemCollectionViw.dataSource = self
        itemCollectionViw.backgroundColor = .clear
        itemCollectionViw.showsHorizontalScrollIndicator = false
        itemCollectionViw.showsVerticalScrollIndicator = false
        itemCollectionViw.register(UINib(nibName: "WHHVIPCenterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WHHVIPCenterCollectionViewCell")

        return itemCollectionViw
    }()

    @IBOutlet var closeTopCon: NSLayoutConstraint!
    @IBOutlet var bgMaskView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        closeTopCon.constant = WHHTopSafe
        collectionViewBg.addSubview(itemCollectionViw)
        itemCollectionViw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        locationSelectOneData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bgMaskView.addGradientBackground(colors: [Color0F0F12.withAlphaComponent(0), Color0F0F12], startPoint: CGPointMake(0, 0), endPoint: CGPointMake(1, 1))
    }

    private func locationSelectOneData() {
        let selectModel = dataArray.first(where: { $0.code == "com.abb.AIProjectWeek" })
        selectModel?.isSelect = true
        itemCollectionViw.reloadData()
    }

    @IBAction func closeButtonClick(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func submitButtonClick(_ sender: UIButton) {
        if let model = dataArray.first(where: { $0.isSelect }) {
            WHHApplePurchaseManager.shared.whhCreateOrderRequest(goodsId: model.shopId, payPage: "")
            WHHApplePurchaseManager.shared.purchaseHandle = { [weak self] status in

                if status == .success {
                    self?.dismiss(animated: true)
                } else {
                }
            }
        }
    }
}

extension WHHVIPViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
