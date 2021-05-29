//
//  RegisterNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/22.
//

import UIKit
import Firebase

class RegisterNameVC: UIViewController {
    
    var registerNameView = RegisterNameView()
    
    // ユーザ名を一時的に保管
    var userName = ""
    
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
        registerNameView.registerNameButton.addTarget(self, action: #selector(registerName), for: .touchUpInside)
        registerNameView.registerNameGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func registerName() {
        let sendDBModel = SendDBModel()
        
        // アプリのバージョン
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        userName = registerNameView.newNameTextField.text ?? ""
        
        if userName == "" {
            return
        } else {
            print("ユーザー登録しました")
            registerNameView.newNameLabel.text = "ユーザー登録しました"
            
            
            UserDefaults.standard.set(userName, forKey: "userName")
            
            sendDBModel.createUser(name: userName, uid: Auth.auth().currentUser!.uid, appVersion: version, isWakeUpBool: false)

            print("UserDefaults_ユーザネーム",UserDefaults.standard.object(forKey: "userName") as! String )
        }
    }
    
    @objc func goBack() {
        print("戻るボタンが押されました")
        //        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        registerNameView.newNameTextField.resignFirstResponder()
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
        registerNameView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 200)
        view.addSubview(registerNameView)
    }
    
    private func configureDecoration() {
        registerNameView.layer.shadowColor = UIColor.systemGray.cgColor
        registerNameView.layer.cornerRadius = 16
        registerNameView.layer.shadowOpacity = 0.1
        registerNameView.layer.shadowRadius = 10
        registerNameView.layer.shadowOffset = .init(width: 0.0, height: 10.0)
        registerNameView.layer.shouldRasterize = true
    }
}
