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
    var newInvitedTeamMateId = ""
        
    // チームから招待してもらって新規登録
    var setInvitedTeamMateNameView = SetInvitedTeamMateView()
    
    let db = Firestore.firestore()
    
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureAddTarget() {
        setInvitedTeamMateNameView.registeredByQRCodeButton.addTarget(self, action: #selector(registeredByQRCode), for: .touchUpInside)
        setInvitedTeamMateNameView.registeredByQRCodeGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    // QRコードで登録
    @objc func registeredByQRCode() {
        print("QR読み取り")

        
        let wakeUpQrCodeReaderVC = WakeUpQrCodeReaderVC()
        wakeUpQrCodeReaderVC.wakeUpTimeText = wakeUpTimeText
        wakeUpQrCodeReaderVC.wakeUpTimeDate = wakeUpTimeDate
        present(wakeUpQrCodeReaderVC, animated: true, completion: nil)

    }
    
    // 戻る
    //TODO: 暫定的に招待IDの承認ボタンに変更
    @objc func goBack() {
//        print("戻るボタン2")
//        dismiss(animated: true, completion: nil)
        print("招待して新規登録しました")
        let sendDBModel = SendDBModel()
        sendDBModel.doneInvitedChatRoom = self
        
        Auth.auth().signInAnonymously { result, error in
            guard let _ = error else { return }
        }
        
        newInvitedTeamMateId = setInvitedTeamMateNameView.invitedIDTextField.text ?? ""
        
        if newInvitedTeamMateId == "" {
            return
        } else {
            sendDBModel.invitedChatRoom(roomNameId: newInvitedTeamMateId, wakeUpTimeDate: wakeUpTimeDate, wakeUpTimeText: wakeUpTimeText)
        }
        
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
        setInvitedTeamMateNameView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 200)
        view.addSubview(setInvitedTeamMateNameView)
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    // セルを装飾
    private func configureDecoration() {
        setInvitedTeamMateNameView.layer.shadowColor = UIColor.systemGray.cgColor
        setInvitedTeamMateNameView.layer.cornerRadius = 16
        setInvitedTeamMateNameView.layer.shadowOpacity = 0.1
        setInvitedTeamMateNameView.layer.shadowRadius = 10
        setInvitedTeamMateNameView.layer.shadowOffset = .init(width: 0, height: 10)
        setInvitedTeamMateNameView.layer.shouldRasterize = true
    }
}

extension SetInvitedTeamMateVC: DoneInvitedChatRoom {
    func doneInvitedChatRoom() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
