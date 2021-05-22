//
//  RegisterNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/22.
//

import UIKit

class RegisterNameVC: UIViewController {
    
    var setNewNameView = RegisterNameView()
    
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
        setNewNameView.registerNameButton.addTarget(self, action: #selector(registerName), for: .touchUpInside)
        setNewNameView.registerNameGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func registerName() {
        print("ユーザー登録しました")
        setNewNameView.newNameLabel.text = "ユーザー登録しました"
    }
    
    @objc func goBack() {
        print("戻るボタンが押されました")
        dismiss(animated: true, completion: nil)
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
        setNewNameView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 200)
        view.addSubview(setNewNameView)
    }
    
    private func configureDecoration() {
        setNewNameView.layer.shadowColor = UIColor.systemGray.cgColor
        setNewNameView.layer.cornerRadius = 16
        setNewNameView.layer.shadowOpacity = 0.1
        setNewNameView.layer.shadowRadius = 10
        setNewNameView.layer.shadowOffset = .init(width: 0.0, height: 10.0)
        setNewNameView.layer.shouldRasterize = true
    }
}
