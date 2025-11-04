//
//  WHHAIChooseAnimationView.swift
//  WHHProject
//
//  Created by wenhuan on 2025/10/27.
//

import UIKit

class WHHAIChooseAnimationView: UIView {

    var timer:Timer?
    
    var count = 0
    
    var witchId = 0
    
    lazy var amaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    
    lazy var bigImageView: WHHBaseImageView = {
        let view = WHHBaseImageView()
        return view
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: WHHScreenW, height: WHHScreenH))
        addSubview(bigImageView)
        addSubview(amaskView)
        amaskView.snp.makeConstraints { make in
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        bigImageView.frame = CGRectMake(0, 0, 0, 0)
        bigImageView.center = center
        UIView.animate(withDuration: 0.5) {
            self.bigImageView.frame = CGRectMake(0, 0, WHHScreenW, WHHScreenH)
        }
        startTimer()
        requestss()
    }
    
    func startTimer() {
        count = 10
        stopTimer()
           timer = Timer.scheduledTimer(timeInterval: 1.0,
                                        target: self,
                                        selector: #selector(updateTimer),
                                        userInfo: nil,
                                        repeats: true)
       }

       @objc func updateTimer() {
           
           count -= 1
           if count <= 0 {
               stopTimer()
               WHHHUD.whhShowInfoText(text: "生成失败，重新选择")
               dismessView()
           }
       }

       deinit {
           // 记得销毁定时器
           timer?.invalidate()
       }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
    }
    
    func dismessView() {
        
        removeFromSuperview()
    }
    
    private func requestss() {
        WHHHomeRequestViewModel.whhHomeGetWHHHomeappUserWitchGetFortuneRequest(witchId: witchId) {[weak self] code, model, msg in
            if code == 1 {
                self?.stopTimer()
                
            }else {
                WHHHUD.whhShowInfoText(text: msg)
                self?.stopTimer()
                self?.dismessView()
            }
        }
    }
    
//    func loadWrid() {
//        
//        WHHHUD.whhShowLoadView()
//        WHHHomeRequestViewModel.whhHomeGetWHHHomeappUserWitchGetFortuneRequest(witchId: 1) { [weak self] success, dataModel, _ in
//            WHHHUD.whhHidenLoadView()
//            if success == 1, dataModel.fortune.items.isEmpty == false {
//                let detailVC = WHHHomeSubscribedDetailViewController()
//                self?.navigationController?.pushViewController(detailVC, animated: true)
//            } else {
//                let divinationVC = WHHDivinationViewController()
//                self?.navigationController?.pushViewController(divinationVC, animated: true)
//            }
//        }
//
//    }
}
