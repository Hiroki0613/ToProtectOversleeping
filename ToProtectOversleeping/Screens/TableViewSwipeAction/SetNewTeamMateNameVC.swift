//
//  SetNewTeamMateNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit
import Firebase
import FirebaseFirestore

class SetNewTeamMateNameVC: UIViewController {

//    var wakeUpTimeText = ""
//    var wakeUpTimeDate = Date()
    var newTeamMateString = ""

    // チームを新規登録
    var setNewTeamMateNameView = SetNewTeamMateNameView()

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

    func configureAddTarget() {
            setNewTeamMateNameView.chatTeamNewRegisterButton.addTarget(self, action: #selector(registerNewTeam), for: .touchUpInside)
            setNewTeamMateNameView.chatTeamGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    // ランダムStringを作成
    func randomString(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }

    // 新規登録
    @objc func registerNewTeam() {
        print("新規登録しました")
        let sendDBModel = SendDBModel()

        // アプリのバージョン
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

//        sendDBModel.doneCreateChatRoom = self

        // 無理矢理ログインしています
        Auth.auth().signInAnonymously { result, error in
            guard let _ = error else { return }
        }

        newTeamMateString = setNewTeamMateNameView.newTeamMateTextField.text ?? ""
        
        if newTeamMateString == "" {
            return
        } else {
            UserDefaults.standard.set(self.newTeamMateString,forKey: "teamChatName")
            let generatedHomeRoomRandomString = "WU\(randomString(length: 18))"
            
            // userDataModeltのteamChatRoomIdを変える。
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                "teamChatRoomId": generatedHomeRoomRandomString,
                "teamChatName": newTeamMateString
            ])
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            print("宏輝_randomString: ", generatedHomeRoomRandomString)
            
            // 新しいチャットルームを開く
            sendDBModel.createChatRoom(roomName: self.newTeamMateString, defaultWakeUpTimeDate: Date(), defaultWakeUpTimeText: "\(formatter.string(from: Date()))", chatRoomId: generatedHomeRoomRandomString, appVersion: version)
        }
//        navigationController?.popToRootViewController(animated: true)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }


    // 戻る
    @objc func goBack() {
        print("戻るボタン")
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNewTeamMateNameView.newTeamMateTextField.resignFirstResponder()
    }


    func configureView() {
        configureBlurView()
        configureCardView()
    }

    func configureCardView(){
        setNewTeamMateNameView.translatesAutoresizingMaskIntoConstraints = false
        setNewTeamMateNameView.layer.cornerRadius = 16
        view.addSubview(setNewTeamMateNameView)

        NSLayoutConstraint.activate([
            setNewTeamMateNameView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            setNewTeamMateNameView.heightAnchor.constraint(equalToConstant: 300),
            setNewTeamMateNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setNewTeamMateNameView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
}

//extension SetNewTeamMateNameVC: DoneCreateChatRoom {
//    func doneCreateChatRoom() {
//        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
//}
