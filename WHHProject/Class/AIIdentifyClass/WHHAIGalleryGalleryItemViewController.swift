//
//  WHHAIGalleryGalleryItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit
import JXSegmentedView

class WHHAIGalleryGalleryItemViewController: WHHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
extension WHHAIGalleryGalleryItemViewController: JXSegmentedListContainerViewListDelegate {
   
    func listView() -> UIView {
        return view
    }
}
