//
//  NewRegistrationUserGoalSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/13.
//

import UIKit

class NewRegistrationUserGoalSettingVC: UIViewController {
    
    
    var newUserName = ""
    var registrationGoalSettingView = RegistrationGoalSettingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func configureAddTarget() {
        registrationGoalSettingView.registerGoalSettingButton.addTarget(self, action: #selector(registerGoalSetting), for: .touchUpInside)
        registrationGoalSettingView.skipButton.addTarget(self, action: #selector(skipGoalSetting), for: .touchUpInside)
    }
    
    @objc func registerGoalSetting() {
        print("宏輝_ゴールセッティングの情報が登録")
        let newRegistrationGpsVC = NewRegistrationGpsVC()
        newRegistrationGpsVC.newUserName = self.newUserName
        newRegistrationGpsVC.theGoalSetting = UserDefaults.standard.object(forKey: "theGoalSettingText") as! String
        
        navigationController?.pushViewController(newRegistrationGpsVC, animated: true)
        
    }
    
    @objc func skipGoalSetting() {
        print("宏輝_ゴールセッティングの情報がスキップ")
        print("宏輝_ゴールセッティングの情報が登録")
        let newRegistrationGpsVC = NewRegistrationGpsVC()
        newRegistrationGpsVC.newUserName = self.newUserName
        newRegistrationGpsVC.theGoalSetting = ""
        navigationController?.pushViewController(newRegistrationGpsVC, animated: true)
    }
    
    private func configureView() {
        configureBlurView()
        configureUI()
    }
    
    private func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    private func configureUI() {
        registrationGoalSettingView.translatesAutoresizingMaskIntoConstraints = false
        registrationGoalSettingView.layer.cornerRadius = 16
        view.addSubview(registrationGoalSettingView)
        
        NSLayoutConstraint.activate([
            registrationGoalSettingView.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            registrationGoalSettingView.heightAnchor.constraint(equalToConstant: 450),
            registrationGoalSettingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationGoalSettingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
