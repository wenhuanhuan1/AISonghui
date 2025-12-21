//
//  WHHAIIntegrationViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import UIKit

class WHHAIIntegrationViewController: WHHBaseViewController {
    
    
    @IBOutlet weak var jifenTableView: UITableView!
    
    
    
    @IBOutlet var jifenyuer: UILabel!
    lazy var rightBtn: UIButton = {
        let a = UIButton(type: .custom)
        a.setTitle("说明", for: .normal)
        a.titleLabel?.font = pingfangRegular(size: 16)
        a.setTitleColor(.white.withAlphaComponent(0.9), for: .normal)
        a.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navigationBar.isHidden = false
        gk_navTitle = "积分中心"
        gk_statusBarStyle = .lightContent
        let att = NSMutableAttributedString(string: "我的积分", attributes: [.foregroundColor: UIColor.white, .font: pingfangMedium(size: 12)!])
        let jifen = NSAttributedString(string: "1244", attributes: [.foregroundColor: UIColor.white, .font: pingfangSemibold(size: 18)!])
        att.append(jifen)
        jifenyuer.attributedText = att
        
        jifenTableView.dataSource = self
        jifenTableView.delegate = self
        jifenTableView.register(UINib(nibName: "WHHJIfenListTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHJIfenListTableViewCell")
        
    }

    @objc func rightButtonClick() {
    }
    
    @IBAction func jumpVIPButtonClick(_ sender: UIButton) {
        
        jumpVIPController {
            
        }
    }
}

extension WHHAIIntegrationViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHJIfenListTableViewCell") as! WHHJIfenListTableViewCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
}
