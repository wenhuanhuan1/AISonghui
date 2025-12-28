//
//  WHHAIGalleryGalleryItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import EmptyDataSet_Swift
import JXSegmentedView
import UIKit

class WHHAIGalleryGalleryItemViewController: WHHBaseViewController {
    lazy var dataArray: [WHHIntegralModel] = {
        let a = [WHHIntegralModel]()
        return a
    }()

    lazy var collectionView: UICollectionView = {
        let layout = WaterfallMutiSectionFlowLayout()
        layout.delegate = self
        layout.minimumLineSpacing = 4
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.register(UINib(nibName: "WHHNewMineItemViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WHHNewMineItemViewCollectionViewCell")
        collectionView.whhAddRefreshNormalHeader { [weak self] in
            self?.whhRefreshHeader()
        }
        collectionView.whhAddRefreshNormalFooter { [weak self] in
            self?.whhRefreshFooter()
        }
        collectionView.mj_footer?.isHidden = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        whhRefreshHeader()
    }

    override func whhRefreshHeader() {
        super.whhRefreshHeader()
        page = 1

        WHHIdetifyRequestModel.whhGetWorksListRequest(page: page) { [weak self] code, array, _ in
            self?.collectionView.mj_header?.endRefreshing()
            if code == 1 {
                self?.dataArray = array
                self?.collectionView.reloadData()
                self?.collectionView.mj_footer?.resetNoMoreData()
                if array.count > 3 {
                    self?.collectionView.mj_footer?.isHidden = false
                } else {
                    self?.collectionView.mj_footer?.isHidden = true
                }
            }
        }
    }

    override func whhRefreshFooter() {
        super.whhRefreshFooter()
        page += 1

        WHHIdetifyRequestModel.whhGetWorksListRequest(page: page) { [weak self] code, array, _ in
            self?.collectionView.mj_footer?.endRefreshing()
            if code == 1 {
                self?.dataArray.append(contentsOf: array)
                self?.collectionView.reloadData()
                if array.isEmpty {
                    self?.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        }
    }
}

extension WHHAIGalleryGalleryItemViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension WHHAIGalleryGalleryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WHHNewMineItemViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WHHNewMineItemViewCollectionViewCell", for: indexPath) as! WHHNewMineItemViewCollectionViewCell
        let model = self.dataArray[indexPath.row]
        cell.cellModel = model
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        debugPrint("详情页面")
    }
}

extension WHHAIGalleryGalleryItemViewController: WaterfallMutiSectionDelegate {
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 268
        } else {
            return 151
        }
    }

    func columnNumber(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> Int {
        return 2
    }

    func insetForSection(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }

    func spacingWithLastSection(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        return 5
    }
}

extension WHHAIGalleryGalleryItemViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "暂无内容"
        let attributes = [NSAttributedString.Key.font: pingfangRegular(size: 12), NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key: Any])
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "whhAIEmptPlacehdoleIcon")
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -80
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        whhRefreshHeader()
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
