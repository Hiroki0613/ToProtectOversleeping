//
//  EditTheGoalSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/13.
//

import UIKit
import Firebase

class EditTheGoalSettingVC: UIViewController {
    
    var editTheGoalSettingView = EditTheGoalSettingView()
    
    let db = Firestore.firestore()
    
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
        editTheGoalSettingView.registerGoalSettingButton.addTarget(self, action: #selector(registerGoalSetting), for: .touchUpInside)
        editTheGoalSettingView.goBackButton.addTarget(self, action: #selector(skipGoalSetting), for: .touchUpInside)
    }
    
    @objc func registerGoalSetting() {
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
            "theGoalSetting": UserDefaults.standard.object(forKey: "theGoalSettingText") as! String
        ])
        navigationController?.popViewController(animated: true)
    }
    
    @objc func skipGoalSetting() {
        navigationController?.popViewController(animated: true)
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
        editTheGoalSettingView.translatesAutoresizingMaskIntoConstraints = false
        editTheGoalSettingView.layer.cornerRadius = 16
        view.addSubview(editTheGoalSettingView)
        
        NSLayoutConstraint.activate([
            editTheGoalSettingView.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            editTheGoalSettingView.heightAnchor.constraint(equalToConstant: 450),
            editTheGoalSettingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editTheGoalSettingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
