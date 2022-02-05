//
//  SetInvitedTeamMateView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetInvitedTeamMateView: UIView {
    
    // キーボード出現によるスクロール量
    var scrollByKeyboard : CGFloat = 0
    
    //招待IDを入力
    var invitedIDLabel = WUBodyLabel(fontSize: 20)
    var invitedIDTextField = WUTextFields()
    //    var invitedIDStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var registeredByQRCodeButton = WUButton(backgroundColor: PrimaryColor.primary, title: "QR読み取り")
    var registeredByQRCodeInvitedButton = WUButton(backgroundColor: PrimaryColor.primary, title: "招待")
    var regsteredByQRCodeStackView = UIStackView(frame: .zero)
    var registeredByQRCodeGoBackButton = WUButton(backgroundColor: PrimaryColor.primary, title: "戻る")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
        configureKeyBoardPlace()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        invitedIDLabel.text = "招待IDを入力してください\n詳しい手順は\"招待する\"の\nSettingタブ → \"チームへ招待する\"ボタン\nで確認出来ます。"
        invitedIDTextField.text = ""
    }
    
    
    private func configureKeyBoardPlace() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボードが現れたときに実行
    @objc func keyboardWillShow(notification: Notification?) {
        print("キーボードが表示された")
        // キーボードの大きさを取得
        let keyboardFrame : CGRect = (notification?.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // キーボードのすぐ上にテキストフィールドが来るように調整する
        self.scrollByKeyboard = keyboardFrame.size.height - (self.frame.height - self.invitedIDTextField.frame.maxY)
        
        // 画面をスクロールさせる
        let affine = CGAffineTransform.init(translationX: 0.0, y: -self.scrollByKeyboard)
        // 画面のスクロールをアニメーションさせる
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.transform = affine
                       },
                       completion: nil)
    }
    
    // キーボードが消えたときに実行
    @objc func keyboardWillHide(notification: Notification?) {
        print("キーボードが消された")
        
        // 画面のスクロールを元に戻す
        let affine = CGAffineTransform.init(translationX: 0.0, y: 0.0)
        // 画面のスクロールをアニメーションさせる
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.transform = affine
                       },
                       completion: { (true) in
                        self.scrollByKeyboard = 0.0
                       })
    }
    
    private func configure() {
        invitedIDLabel.translatesAutoresizingMaskIntoConstraints = false
        invitedIDTextField.translatesAutoresizingMaskIntoConstraints = false
        
        invitedIDLabel.numberOfLines = 0
        
        registeredByQRCodeButton.translatesAutoresizingMaskIntoConstraints = false
        registeredByQRCodeInvitedButton.translatesAutoresizingMaskIntoConstraints = false
        regsteredByQRCodeStackView.translatesAutoresizingMaskIntoConstraints = false
        registeredByQRCodeGoBackButton.translatesAutoresizingMaskIntoConstraints = false
        
        invitedIDTextField.delegate = self
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // チーム名の入力をStack
        addSubview(invitedIDLabel)
        addSubview(invitedIDTextField)
        
        // チャットチーム名をStack
        regsteredByQRCodeStackView.addArrangedSubview(registeredByQRCodeButton)
        regsteredByQRCodeStackView.addArrangedSubview(registeredByQRCodeInvitedButton)
        regsteredByQRCodeStackView.axis = .horizontal
        regsteredByQRCodeStackView.alignment = .fill
        regsteredByQRCodeStackView.distribution = .fillEqually
        regsteredByQRCodeStackView.spacing = 20
        addSubview(regsteredByQRCodeStackView)
        
        addSubview(registeredByQRCodeGoBackButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            invitedIDLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            invitedIDLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            invitedIDLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            invitedIDLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding * 3),
            invitedIDTextField.topAnchor.constraint(equalTo: invitedIDLabel.bottomAnchor, constant: spacePadding),
            invitedIDTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            invitedIDTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            invitedIDTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // チャットチーム名
            regsteredByQRCodeStackView.topAnchor.constraint(equalTo: invitedIDTextField.bottomAnchor, constant:  spacePadding),
            regsteredByQRCodeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            regsteredByQRCodeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            regsteredByQRCodeStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            registeredByQRCodeGoBackButton.topAnchor.constraint(equalTo: regsteredByQRCodeStackView.bottomAnchor, constant: spacePadding),
            registeredByQRCodeGoBackButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            registeredByQRCodeGoBackButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            registeredByQRCodeGoBackButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
}

extension SetInvitedTeamMateView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
