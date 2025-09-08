//
//  WHHAboutUsViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import UIKit

class WHHAboutUsViewController: WHHBaseViewController {
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var whiteBgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gk_navTitle = ""
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: "WHHAboutUsTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAboutUsTableViewCell")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        whiteBgView.whhAddSetRectConrner(corner: [.topLeft,.topRight], radile: 22)
    }
}

extension WHHAboutUsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WHHAboutUsTableViewCell") as! WHHAboutUsTableViewCell
        switch indexPath.row {
        case 0:
            cell.leftTitle.text = "当前版本"
            cell.leftIcon.image = UIImage(named: "whhAboutCurrentVersionIcon")
            cell.rightTitle.isHidden = false
            cell.rightTitle.text = "V\(WHHDeviceManager.whhGetCurrentVersion())"
            cell.arraw.isHidden = true
            cell.lineView.isHidden = false
        case 1:
            cell.leftTitle.text = "用户协议"
            cell.leftIcon.image = UIImage(named: "whhAboutXinyiIcon")
            cell.rightTitle.isHidden = true
            cell.arraw.isHidden = false
            cell.lineView.isHidden = false
        case 2:
            cell.leftTitle.text = "隐私政策"
            cell.leftIcon.image = UIImage(named: "whhAboutyinsiIcon")
            cell.rightTitle.isHidden = true
            cell.arraw.isHidden = false
            cell.lineView.isHidden = false
//        case 3:
//            cell.leftTitle.text = "Apple账号"
//            cell.leftIcon.image = UIImage(named: "whhAboutAppleIcon")
//            cell.rightTitle.isHidden = true
//            cell.arraw.isHidden = true
//            cell.lineView.isHidden = false
//        case 3:
           
        default:

            cell.leftTitle.text = "注销账号"
            cell.leftIcon.image = UIImage(named: "whhAboutzhuxiaoIcon")
            cell.rightTitle.isHidden = true
            cell.arraw.isHidden = false
            cell.lineView.isHidden = false
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            
            break
        case 1:
            let webView = WHHWKWebViewViewController(url: WHHUserInfoManager.shared.confModel.config.privacyAgreementUrl)
            navigationController?.pushViewController(webView, animated: true)
            break
        case 2:
            let webView = WHHWKWebViewViewController(url: WHHUserInfoManager.shared.confModel.config.registerAgreementUrl)
            navigationController?.pushViewController(webView, animated: true)
            break
//        case 3:
//            debugPrint("苹果登录")
//            let alert = WHHAppleAccountExplainView()
//            view.addSubview(alert)
//            break
        case 3:
            debugPrint("注销账号")
            let accountVC = WHHlogoutAccoutViewController()
            navigationController?.pushViewController(accountVC, animated: true)
            break
        default:
            debugPrint("hhhh")
//            debugPrint("退出登陆")
//            let alert = WHHAppleAccountRegisterView(type: .logOut)
//            view.addSubview(alert)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
