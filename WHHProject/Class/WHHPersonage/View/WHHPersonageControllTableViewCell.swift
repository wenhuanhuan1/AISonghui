//
//  WHHPersonageControllTableViewCell.swift
//  WHHProject
//
//  Created by wenhuan on 2025/7/31.
//

import UIKit

class WHHPersonageControllTableViewCell: UITableViewCell {
    var dataArray: [[String: Any]]?
    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "WHHControllTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHControllTableViewCell")
        tableView.register(UINib(nibName: "WHHPersonageControllTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHPersonageControllTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension WHHPersonageControllTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WHHControllTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WHHControllTableViewCell") as! WHHControllTableViewCell
        if let tempArray = dataArray {
            cell.dict = tempArray[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray?.count ?? 0 >= 3 {
            switch indexPath.row {
            case 0:
                if let currentVC = UIViewController.currentViewController() {
                    let contactUsVC = WHHContactUsViewController()
                    currentVC.navigationController?.pushViewController(contactUsVC, animated: true)
                }

            case 1:
                WHHHUD.whhShowInfoText(text: "恢复购买成功")
            case 2:
                debugPrint("sasa")
                if let currentVC = UIViewController.currentViewController() {
                    let contactUsVC = WHHAboutUsViewController()
                    currentVC.navigationController?.pushViewController(contactUsVC, animated: true)
                }

            case 3:
                debugPrint("sasa")
            default:
                debugPrint("sasa")
            }

        } else {
        }
    }
}
