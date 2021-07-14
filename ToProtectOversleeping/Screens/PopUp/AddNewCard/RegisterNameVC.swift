//
//  RegisterNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/22.
//

import UIKit
import Firebase

class RegisterNameVC: UIViewController {
    
    var registerNameView = ChangeNameView()
    let db = Firestore.firestore()
    var userDataModel: UserDataModel?
    
    // ユーザ名を一時的に保管
    var userName = ""
    
    var isJoinedTeam: Bool = false
    
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
    
    func configureAddTarget() {
        registerNameView.registerNameButton.addTarget(self, action: #selector(registerName), for: .touchUpInside)
        registerNameView.registerNameGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func registerName() {
        let sendDBModel = SendDBModel()
        // アプリのバージョン
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        userName = registerNameView.newNameTextField.text ?? ""
        
        isJoinedTeam = userDataModel?.homeRoomId != userDataModel?.teamChatRoomId
        
        if userName == "" {
            return
        } else {
            print("ユーザー登録しました")
            
            registerNameView.newNameLabel.text = "ユーザー登録しました"
            UserDefaults.standard.set(userName, forKey: "userName")
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "name": self.userName
            ])
            
            
            
//            if isJoinedTeam == true {
//                registerNameView.newNameLabel.text = "ユーザー登録しました"
//                UserDefaults.standard.set(userName, forKey: "userName")
//
//                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
//                    "name": self.userName
//                ])
//            } else {
//                registerNameView.newNameLabel.text = "ユーザー登録しました"
//                UserDefaults.standard.set(userName, forKey: "userName")
//
//                self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
//                    "name": self.userName,
//                    "teamChatName": self.userName
//                ])
//            }
            
            
//            sendDBModel.createUser(name: userName, uid: Auth.auth().currentUser!.uid, appVersion: version, isBilling: false)

            print("UserDefaults_ユーザネーム",UserDefaults.standard.object(forKey: "userName") as! String )
            registerNameView.newNameTextField.resignFirstResponder()
        }
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
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
        registerNameView.translatesAutoresizingMaskIntoConstraints = false
        registerNameView.layer.cornerRadius = 16
        view.addSubview(registerNameView)
        
        NSLayoutConstraint.activate([
            registerNameView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            registerNameView.heightAnchor.constraint(equalToConstant: 400),
            registerNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerNameView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
