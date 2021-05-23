//
//  RegisterNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/22.
//

import UIKit

class RegisterNameVC: UIViewController {
    
    var registerNewNameView = RegisterNameView()
    
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
        registerNewNameView.registerNameButton.addTarget(self, action: #selector(registerName), for: .touchUpInside)
        registerNewNameView.registerNameGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func registerName() {
        print("ユーザー登録しました")
        registerNewNameView.newNameLabel.text = "ユーザー登録しました"
            
        if let newNameTextFieldText = registerNewNameView.newNameTextField.text {
            UserDefaults.standard.set(newNameTextFieldText, forKey: "userName")
        }
        

        print("UserDefaults_ユーザネーム",UserDefaults.standard.object(forKey: "userName") as! String )
    }
    
    @objc func goBack() {
        print("戻るボタンが押されました")
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        registerNewNameView.newNameTextField.resignFirstResponder()
    }
    
    func configureView() {
        configureBlurView()
        configuteCardView()
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    func configuteCardView() {
        registerNewNameView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 200)
        view.addSubview(registerNewNameView)
    }
    
    private func configureDecoration() {
        registerNewNameView.layer.shadowColor = UIColor.systemGray.cgColor
        registerNewNameView.layer.cornerRadius = 16
        registerNewNameView.layer.shadowOpacity = 0.1
        registerNewNameView.layer.shadowRadius = 10
        registerNewNameView.layer.shadowOffset = .init(width: 0.0, height: 10.0)
        registerNewNameView.layer.shouldRasterize = true
    }
}
