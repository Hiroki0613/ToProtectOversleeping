//
//  SetNewTeamMateNameView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetNewTeamMateNameView: UIView {
    
    // キーボード出現によるスクロール量
    var scrollByKeyboard : CGFloat = 0
    
    //新しいチーム名を入力
    var newTeamMateLabel = WUBodyLabel(fontSize: 20)
    var newTeamMateTextField = WUTextFields()
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var chatTeamNewRegisterButton = WUButton(backgroundColor: .clear, title: "登録")
    var chatTeamGoBackButton = WUButton(backgroundColor: .clear, title: "戻る")
    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
        configureKeyBoardPlace()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: self.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: self.window)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        newTeamMateLabel.text = "チーム名を入力してください"
        newTeamMateTextField.text = ""
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
        self.scrollByKeyboard = keyboardFrame.size.height - (self.frame.height - self.newTeamMateTextField.frame.maxY)
        
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
        newTeamMateLabel.translatesAutoresizingMaskIntoConstraints = false
        newTeamMateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        chatTeamNewRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamGoBackButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        newTeamMateTextField.delegate = self
        
        backgroundColor = PrimaryColor.background
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // チーム名の入力をStack
        addSubview(newTeamMateLabel)
        addSubview(newTeamMateTextField)
        
        // チャットチーム名をStack
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamNewRegisterButton)
        chatTeamNameAndRegstrationStackView.addArrangedSubview(chatTeamGoBackButton)
        chatTeamNameAndRegstrationStackView.axis = .horizontal
        chatTeamNameAndRegstrationStackView.alignment = .fill
        chatTeamNameAndRegstrationStackView.distribution = .fillEqually
        chatTeamNameAndRegstrationStackView.spacing = 20
        addSubview(chatTeamNameAndRegstrationStackView)
        
        
        NSLayoutConstraint.activate([
            //起きる時間
            newTeamMateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            newTeamMateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newTeamMateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            newTeamMateLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            newTeamMateTextField.topAnchor.constraint(equalTo: newTeamMateLabel.bottomAnchor, constant: spacePadding),
            newTeamMateTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newTeamMateTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            newTeamMateTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // チャットチーム名
            chatTeamNameAndRegstrationStackView.topAnchor.constraint(equalTo: newTeamMateTextField.bottomAnchor, constant:  spacePadding),
            chatTeamNameAndRegstrationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameAndRegstrationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameAndRegstrationStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
}

extension SetNewTeamMateNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
