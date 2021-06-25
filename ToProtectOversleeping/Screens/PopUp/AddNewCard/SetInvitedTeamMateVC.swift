//
//  SetInvitedTeamMateVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit
import Firebase

class SetInvitedTeamMateVC: UIViewController {
    
    var wakeUpTimeText = ""
    var wakeUpTimeDate = Date()
    var userName = ""
    var newInvitedTeamMateId = ""
        
    // チームから招待してもらって新規登録
    var setInvitedTeamMateNameView = SetInvitedTeamMateView()
    
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureAddTarget() {
        setInvitedTeamMateNameView.registeredByQRCodeButton.addTarget(self, action: #selector(registeredByQRCode), for: .touchUpInside)
        setInvitedTeamMateNameView.registeredByQRCodeInvitedButton.addTarget(self, action: #selector(setInvitedCode), for: .touchUpInside)
        setInvitedTeamMateNameView.registeredByQRCodeGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    // QRコードで登録
    @objc func registeredByQRCode() {
        print("QR読み取り")

        let wakeUpQrCodeReaderVC = WakeUpQrCodeReaderVC()
        wakeUpQrCodeReaderVC.wakeUpTimeText = wakeUpTimeText
        wakeUpQrCodeReaderVC.wakeUpTimeDate = wakeUpTimeDate
        wakeUpQrCodeReaderVC.userName = userName
        
        present(wakeUpQrCodeReaderVC, animated: true, completion: nil)
    }
    
    // IDを打ち込んで招待
    @objc func setInvitedCode() {
        print("招待して新規登録しました")
        let sendDBModel = SendDBModel()
        sendDBModel.doneInvitedChatRoom = self
        
        Auth.auth().signInAnonymously { result, error in
            guard let _ = error else { return }
        }
        
        newInvitedTeamMateId = setInvitedTeamMateNameView.invitedIDTextField.text ?? ""
        
        // メッセージがアプリのバージョンアップで変更した時に使用
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        if (newInvitedTeamMateId.hasPrefix("WU")) {
            print("WUから始まる文字")
            sendDBModel.invitedChatRoom(
                roomNameId: newInvitedTeamMateId,
                wakeUpTimeDate: wakeUpTimeDate,
                wakeUpTimeText: wakeUpTimeText,
                isWakeUpBool: true,
                isWakeUpRoop: false,
                appVersion: version
            )
        } else {
            setInvitedTeamMateNameView.invitedIDLabel.text = "招待IDが違います"
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let messageModel = MessageModel()
            messageModel.newInvitedToTeam(documentID: self.newInvitedTeamMateId, displayName: self.userName, wakeUpTimeText: self.wakeUpTimeText)
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setInvitedTeamMateNameView.invitedIDTextField.resignFirstResponder()
    }
    
    
    func configureView() {
        configureBlurView()
        configureCardView()
    }
    
    func configureCardView(){
        setInvitedTeamMateNameView.translatesAutoresizingMaskIntoConstraints = false
        setInvitedTeamMateNameView.layer.cornerRadius = 16
        view.addSubview(setInvitedTeamMateNameView)
        
        NSLayoutConstraint.activate([
            setInvitedTeamMateNameView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            setInvitedTeamMateNameView.heightAnchor.constraint(equalToConstant: 400),
            setInvitedTeamMateNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setInvitedTeamMateNameView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
}

extension SetInvitedTeamMateVC: DoneInvitedChatRoom {
    func doneInvitedChatRoom() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
