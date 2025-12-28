//
//  WHHIdetifyDetailReportView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/27.
//

import UIKit

class WHHIdetifyDetailReportView: UIView {
    
    var didReportButtonClick:((WHHIdetifyDetailReportView)->Void)?
    
    @IBOutlet weak var bgView: UIView!
    
 
   
    
    func whhLoadXib() -> WHHIdetifyDetailReportView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! WHHIdetifyDetailReportView
        view.frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
       
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.whhAddSetRectConrner(corner: [.topLeft,.topRight], radile: 8)
    }
    

    @IBAction func cancleButtonClick(_ sender: UIButton) {
        
        closeView()
    }
    
    @IBAction func reportButtonClick(_ sender: UIButton) {
        
        didReportButtonClick?(self)
    }
    
    func closeView()  {
        
        removeFromSuperview()
    }
}
