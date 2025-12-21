//
//  WHHAIGallerySleepItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit
import JXSegmentedView

class WHHAIGallerySleepItemViewController: WHHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
extension WHHAIGallerySleepItemViewController: JXSegmentedListContainerViewListDelegate {
   
    func listView() -> UIView {
        return view
    }
}
