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
        configureDecoration()
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
        registerNewNameView.registerNameGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func registerName() {
        print("新規ユーザー登録開始")
        
        // ここでGPS画面に画面遷移する。
        let newRegistrationGpsVC = NewRegistrationGpsVC()
        guard let newNameTextFieldText = registerNewNameView.newNameTextField.text else { return }
        newRegistrationGpsVC.newUserName = newNameTextFieldText
        newRegistrationGpsVC.modalPresentationStyle = .overFullScreen
        newRegistrationGpsVC.modalTransitionStyle = .crossDissolve
        
        //TODO: 1秒後に画面遷移するようにする
        self.present(newRegistrationGpsVC, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        print("戻るボタンが押されました")
        self.navigationController?.popViewController(animated: true)
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
        registerNewNameView.frame = CGRect(x: 10, y: view.frame.size.height / 2, width: view.frame.size.width - 20, height: 200)
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
