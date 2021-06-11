//
//  EditWakeUpAlarmTimeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/11.
//

import UIKit

class EditWakeUpAlarmTimeVC: UIViewController {
    

    var editWakeUpAlarmTimeView = EditWakeUpAlarmTimeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDecoration()
        configureAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureAddTarget() {
        editWakeUpAlarmTimeView.changeWakeUpGoBuckButton.addTarget(self, action: #selector(tapToDismiss), for: .touchUpInside)
    }
    
    @objc func tapToDismiss() {
        
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func configureView() {
        configureBlurView()
        configureCardView()

    }
    
    func configureCardView() {
        editWakeUpAlarmTimeView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 300)
        view.addSubview(editWakeUpAlarmTimeView)
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    func configureDecoration() {
        editWakeUpAlarmTimeView.layer.shadowColor = UIColor.systemGray.cgColor
        editWakeUpAlarmTimeView.layer.cornerRadius = 16
        editWakeUpAlarmTimeView.layer.shadowOpacity = 0.1
        editWakeUpAlarmTimeView.layer.shadowRadius = 10
        editWakeUpAlarmTimeView.layer.shadowOffset = .init(width: 0, height: 10)
        editWakeUpAlarmTimeView.layer.shouldRasterize = true
    }
}
