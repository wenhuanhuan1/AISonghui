//
//  WHHIMineShareItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/28.
//

import UIKit
import JXPagingView

class WHHIMineShareItemViewController: WHHBaseViewController {
    
    
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
        itemCollectionViw.register(UINib(nibName: "WHHNewMineItemViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WHHNewMineItemViewCollectionViewCell")

        return itemCollectionViw
    }()
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(itemCollectionViw)
        itemCollectionViw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    


}
extension WHHIMineShareItemViewController: JXPagingViewListViewDelegate {
   
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
extension WHHIMineShareItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WHHNewMineItemViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WHHNewMineItemViewCollectionViewCell", for: indexPath) as! WHHNewMineItemViewCollectionViewCell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}
