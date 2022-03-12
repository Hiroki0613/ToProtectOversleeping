//
//  RegisterNameView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/12.
//

import UIKit

class RegisterNameView: UIView {
    
    // キーボード出現によるスクロール量
    var scrollByKeyboard : CGFloat = 0
    
    var newNameLabel = WUBodyLabel(fontSize: 20)
    var newNameTextField = WUTextFields()
    var registerNameButton = WUButton(backgroundColor: .clear, title: "登録")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
        configureKeyBoardPlace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingInformation() {
        newNameLabel.text = "ユーザーネームを入力してください"
        newNameTextField.text = ""
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
        self.scrollByKeyboard = keyboardFrame.size.height - (self.frame.height - self.newNameTextField.frame.maxY)
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
        newNameLabel.translatesAutoresizingMaskIntoConstraints = false
        newNameTextField.translatesAutoresizingMaskIntoConstraints = false
        registerNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        newNameTextField.delegate = self
        
        backgroundColor = PrimaryColor.background
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // ユーザー名をStack
        addSubview(newNameLabel)
        addSubview(newNameTextField)
        
        addSubview(registerNameButton)
        
        NSLayoutConstraint.activate([
            newNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            newNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            newNameLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            newNameTextField.topAnchor.constraint(equalTo: newNameLabel.bottomAnchor, constant: spacePadding),
            newNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            newNameTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            registerNameButton.topAnchor.constraint(equalTo: newNameTextField.bottomAnchor, constant: spacePadding),
            registerNameButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            registerNameButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            registerNameButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
}

extension RegisterNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let newNameTextFieldText = textField.text {
            newNameTextField.text = newNameTextFieldText
        }
        textField.resignFirstResponder()
        return true
    }
}
