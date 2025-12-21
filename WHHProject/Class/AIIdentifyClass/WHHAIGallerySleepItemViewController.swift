//
//  WHHAIGallerySleepItemViewController.swift
//  WHHProject
//
//  Created by wenhuan on 2025/12/20.
//

import JXSegmentedView
import UIKit

class WHHAIGallerySleepItemViewController: WHHBaseViewController {
    lazy var listTaleView: UITableView = {
        let a = UITableView(frame: .zero, style: .grouped)
        a.backgroundColor = .clear
        a.separatorStyle = .none
        a.dataSource = self
        a.delegate = self
        a.register(UINib(nibName: "WHHAISleepOneTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAISleepOneTableViewCell")
        a.register(UINib(nibName: "WHHAISleepTwoTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAISleepTwoTableViewCell")
        a.register(UINib(nibName: "WHHAISleepThreeTableViewCell", bundle: nil), forCellReuseIdentifier: "WHHAISleepThreeTableViewCell")

        return a
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(listTaleView)
        listTaleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension WHHAIGallerySleepItemViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension WHHAIGallerySleepItemViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WHHAISleepOneTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WHHAISleepOneTableViewCell") as! WHHAISleepOneTableViewCell

            return cell
        } else if indexPath.section == 1 {
            let cell: WHHAISleepTwoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WHHAISleepTwoTableViewCell") as! WHHAISleepTwoTableViewCell

            return cell
        } else {
            let cell: WHHAISleepThreeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WHHAISleepThreeTableViewCell") as! WHHAISleepThreeTableViewCell

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return (WHHScreenW - 32) * 309 / 382
        } else {
            return (WHHScreenW - 32) * 200 / 382
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
        
            debugPrint("点击了说梦成画")
        }
    }
}
