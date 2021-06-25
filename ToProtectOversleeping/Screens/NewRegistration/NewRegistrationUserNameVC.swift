//
//  NewRegistrationUserNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/29.
//

import UIKit

class NewRegistrationUserNameVC: UIViewController {
    
    var registerNewNameView = RegisterNameView()
    
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
        registerNewNameView.registerNameButton.addTarget(self, action: #selector(registerName), for: .touchUpInside)
    }
    
    @objc func registerName() {
        print("新規ユーザー登録開始")
        
        // ここでGPS画面に画面遷移する。
        let newRegistrationGpsVC = NewRegistrationGpsVC()
        newRegistrationGpsVC.newUserName = registerNewNameView.newNameTextField.text ?? ""
        
        if newRegistrationGpsVC.newUserName == "" {
            return
        } else {
            //TODO: 1秒後に画面遷移するようにする
            navigationController?.pushViewController(newRegistrationGpsVC, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        registerNewNameView.newNameTextField.resignFirstResponder()
    }
    
    private func configureView() {
        configureBlurView()
        configureCardView()
    }
    
    private func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    private func configureCardView() {
        registerNewNameView.translatesAutoresizingMaskIntoConstraints = false
        registerNewNameView.layer.cornerRadius = 16
        view.addSubview(registerNewNameView)
        
        NSLayoutConstraint.activate([
            registerNewNameView.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            registerNewNameView.heightAnchor.constraint(equalToConstant: 300),
            registerNewNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerNewNameView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
