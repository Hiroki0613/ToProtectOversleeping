//
//  SetInvitedTeamMateView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetInvitedTeamMateView: UIView {
    
    //招待IDを入力
    var invitedIDLabel = WUBodyLabel(fontSize: 20)
    var invitedIDTextField = WUTextFields()
    var invitedIDStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var registeredByQRCodeButton = WUButton(backgroundColor: .systemOrange, title: "QR読み取り")
    var registeredByQRCodeGoBackButton = WUButton(backgroundColor: .systemOrange, title: "戻る")
    var regsteredByQRCodeStackView = UIStackView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        invitedIDLabel.text = "招待IDを入力してください"
        invitedIDTextField.text = ""
    }
    
    
    private func configure() {
        invitedIDLabel.translatesAutoresizingMaskIntoConstraints = false
        invitedIDTextField.translatesAutoresizingMaskIntoConstraints = false
        invitedIDStackView.translatesAutoresizingMaskIntoConstraints = false
        
        registeredByQRCodeButton.translatesAutoresizingMaskIntoConstraints = false
        registeredByQRCodeGoBackButton.translatesAutoresizingMaskIntoConstraints = false
        regsteredByQRCodeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        invitedIDTextField.delegate = self
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // チーム名の入力をStack
        
        invitedIDStackView.addArrangedSubview(invitedIDLabel)
        invitedIDStackView.addArrangedSubview(invitedIDTextField)
        invitedIDStackView.axis = .vertical
        invitedIDStackView.alignment = .fill
        invitedIDStackView.spacing = 10
        addSubview(invitedIDStackView)
        
        // チャットチーム名をStack
        regsteredByQRCodeStackView.addArrangedSubview(registeredByQRCodeButton)
        regsteredByQRCodeStackView.addArrangedSubview(registeredByQRCodeGoBackButton)
        regsteredByQRCodeStackView.axis = .horizontal
        regsteredByQRCodeStackView.alignment = .fill
        regsteredByQRCodeStackView.distribution = .fillEqually
        regsteredByQRCodeStackView.spacing = 20
        addSubview(regsteredByQRCodeStackView)
        
        
        NSLayoutConstraint.activate([
            //起きる時間
            invitedIDStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            invitedIDStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            invitedIDStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            invitedIDStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム名
            regsteredByQRCodeStackView.topAnchor.constraint(equalTo: invitedIDStackView.bottomAnchor, constant:  spacePadding),
            regsteredByQRCodeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            regsteredByQRCodeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            regsteredByQRCodeStackView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}

extension SetInvitedTeamMateView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
