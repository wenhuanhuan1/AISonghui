//
//  WHHAboutUsViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/8/1.
//

import UIKit
import Kingfisher
class WHHAboutUsViewController: WHHBaseViewController {
    @IBOutlet var tableview: UITableView!
    
    lazy var bigIconImageView: AnimatedImageView = {
        let view = AnimatedImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    @IBOutlet weak var webpBgView: UIView!
    
    @IBOutlet weak var whiteBgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        gk_backStyle = .black
        gk_navTitle = ""
        gk_navTitleColor = .black
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: "WHHAboutUsTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAboutUsTableViewCell")
        webpBgView.addSubview(bigIconImageView)
        bigIconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let path = Bundle.main.path(forResource: "aboutUsAbb", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            bigIconImageView.kf.setImage(with: url)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        whiteBgView.whhAddShadow(ofColor: Color6C73FF, radius: 22, offset: CGSize(width: 0, height: -2), opacity: 0.4)
        whiteBgView.layer.cornerRadius = 22
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
            cell.lineView.isHidden = true
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
            let webView = WHHWKWebViewViewController(url: WHHUserInfoManager.shared.confModel.config.registerAgreementUrl)
            navigationController?.pushViewController(webView, animated: true)
            break
        case 2:
            let webView = WHHWKWebViewViewController(url: WHHUserInfoManager.shared.confModel.config.privacyAgreementUrl)
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
