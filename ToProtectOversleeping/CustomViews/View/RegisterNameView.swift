//
//  RegisterNameView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/22.
//

import UIKit

class RegisterNameView: UIView {
    var newNameLabel = WUBodyLabel(fontSize: 20)
    var newNameTextField = WUTextFields()
    
    var newNameStackView = UIStackView(frame: .zero)
    
    
    var registerNameButton = WUButton(backgroundColor: .systemOrange, title: "登録")
    var registerNameGoBackButton = WUButton(backgroundColor: .systemOrange, title: "戻る")
    var registerNameStackView = UIStackView(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingInformation() {
        newNameLabel.text = "ユーザーネームを入力してください"
        newNameTextField.text = ""
    }
    
    private func configure() {
        newNameLabel.translatesAutoresizingMaskIntoConstraints = false
        newNameTextField.translatesAutoresizingMaskIntoConstraints = false
        newNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        registerNameButton.translatesAutoresizingMaskIntoConstraints = false
        registerNameGoBackButton.translatesAutoresizingMaskIntoConstraints = false
        registerNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        newNameTextField.delegate = self
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // ユーザー名をStack
        newNameStackView.addArrangedSubview(newNameLabel)
        newNameStackView.addArrangedSubview(newNameTextField)
        newNameStackView.axis = .vertical
        newNameStackView.alignment = .fill
        newNameStackView.spacing = 10
        addSubview(newNameStackView)
        
        registerNameStackView.addArrangedSubview(registerNameButton)
        registerNameStackView.addArrangedSubview(registerNameGoBackButton)
        registerNameStackView.axis = .horizontal
        registerNameStackView.alignment = .fill
        registerNameStackView.distribution = .fillEqually
        registerNameStackView.spacing = 20
        addSubview(registerNameStackView)
        
        NSLayoutConstraint.activate([
            newNameStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            newNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            newNameStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            registerNameStackView.topAnchor.constraint(equalTo: newNameStackView.bottomAnchor, constant: spacePadding),
            registerNameStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            registerNameStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            registerNameStackView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}

extension RegisterNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


