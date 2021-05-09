//
//  SetNewTeamMateNameView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetNewTeamMateNameView: UIView {
    
    //新しいチーム名を入力
    var newTeamMateLabel = WUBodyLabel(fontSize: 20)
    var newTeamMateTextField = WUTextFields()
//    var wakeUpTimeTextFieldAndSwitchStackView = UIStackView(frame: .zero)
    var newTeamMateStackView = UIStackView(frame: .zero)
    
    // チャットのチーム名、ワンタイムトークンにて招待制
    var chatTeamNewRegisterButton = WUButton(backgroundColor: .systemOrange, title: "登録")
    var chatTeamGoBackButton = WUButton(backgroundColor: .systemOrange, title: "戻る")
    var chatTeamNameAndRegstrationStackView = UIStackView(frame: .zero)
    
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
        newTeamMateLabel.text = "チーム名を入力してください"
        newTeamMateTextField.text = ""
    }
    
    
    private func configure() {
        newTeamMateLabel.translatesAutoresizingMaskIntoConstraints = false
        newTeamMateTextField.translatesAutoresizingMaskIntoConstraints = false
        newTeamMateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        chatTeamNewRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamGoBackButton.translatesAutoresizingMaskIntoConstraints = false
        chatTeamNameAndRegstrationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // チーム名の入力をStack
        
        newTeamMateStackView.addArrangedSubview(newTeamMateLabel)
        newTeamMateStackView.addArrangedSubview(newTeamMateTextField)
        newTeamMateStackView.axis = .vertical
        newTeamMateStackView.alignment = .fill
        newTeamMateStackView.spacing = 10
        addSubview(newTeamMateStackView)
        
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
            newTeamMateStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            newTeamMateStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            newTeamMateStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            newTeamMateStackView.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            // チャットチーム名
            chatTeamNameAndRegstrationStackView.topAnchor.constraint(equalTo: newTeamMateStackView.bottomAnchor, constant:  spacePadding),
            chatTeamNameAndRegstrationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            chatTeamNameAndRegstrationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            chatTeamNameAndRegstrationStackView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
}
