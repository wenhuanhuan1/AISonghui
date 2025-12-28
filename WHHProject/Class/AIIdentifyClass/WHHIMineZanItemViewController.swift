//
//  WHHIMineZanItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/28.
//

import UIKit
import JXPagingView
import EmptyDataSet_Swift

class WHHIMineZanItemViewController: WHHBaseViewController {
        
    lazy var itemCollectionViw: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let w = (WHHScreenW - 12) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: w, height: w)
        let itemCollectionViw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        itemCollectionViw.delegate = self
        itemCollectionViw.dataSource = self
        itemCollectionViw.backgroundColor = .clear
        itemCollectionViw.showsHorizontalScrollIndicator = false
        itemCollectionViw.showsVerticalScrollIndicator = false
        itemCollectionViw.emptyDataSetSource = self
        itemCollectionViw.emptyDataSetDelegate = self
        itemCollectionViw.register(UINib(nibName: "WHHNewMineItemViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WHHNewMineItemViewCollectionViewCell")
        itemCollectionViw.whhAddRefreshNormalHeader {[weak self] in
            self?.whhRefreshHeader()
        }
        itemCollectionViw.whhAddRefreshNormalFooter {[weak self] in
            self?.whhRefreshFooter()
        }
        itemCollectionViw.mj_footer?.isHidden = true
        return itemCollectionViw
    }()
    
    lazy var dataArray: [WHHIntegralModel] = {
        let a = [WHHIntegralModel]()
        return a
    }()
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(itemCollectionViw)
        itemCollectionViw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        whhRefreshHeader()
    }
    
    override func whhRefreshHeader() {
        super.whhRefreshHeader()
        page = 1
        
        WHHIdetifyRequestModel.whhGetLikingLikeListRequest(page: page) {[weak self] code, array, msg in
            self?.itemCollectionViw.mj_header?.endRefreshing()
            if code == 1 {
                self?.dataArray = array
                self?.itemCollectionViw.reloadData()
                self?.itemCollectionViw.mj_footer?.resetNoMoreData()
                if array.count > 3 {
                    self?.itemCollectionViw.mj_footer?.isHidden = false
                }else{
                    self?.itemCollectionViw.mj_footer?.isHidden = true
                }
            }
            
        }
    }
    
    override func whhRefreshFooter() {
        super.whhRefreshFooter()
        page += 1
        
        WHHIdetifyRequestModel.whhGetLikingLikeListRequest(page: page) {[weak self] code, array, msg in
            self?.itemCollectionViw.mj_footer?.endRefreshing()
            if code == 1 {
                self?.dataArray.append(contentsOf: array)
                self?.itemCollectionViw.reloadData()
                if array.isEmpty {
                    self?.itemCollectionViw.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
            
        }
        
    }

}
extension WHHIMineZanItemViewController: JXPagingViewListViewDelegate {
   
    func listView() -> UIView {
        return view
    }
    
    func listScrollView() -> UIScrollView {
        return itemCollectionViw
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
extension WHHIMineZanItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WHHNewMineItemViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WHHNewMineItemViewCollectionViewCell", for: indexPath) as! WHHNewMineItemViewCollectionViewCell

        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}
extension WHHIMineZanItemViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "暂无点赞"
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
