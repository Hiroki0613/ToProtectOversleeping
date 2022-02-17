//
//  SelectCreateTeamOrInvitedByOtherTeam.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/12/31.
//

import UIKit

class SelectCreateTeamOrInvitedByOtherTeamView: UIView {
    var selectCreateTeamOrInvitedByOtherTeamLabel = WUBodyLabel(fontSize: 20)
    var createTeamButton = WUButton(backgroundColor: .clear, title: "チーム作成")
    var invitedByOtherTeamButton = WUButton(backgroundColor: .clear, title: "チームへ招待される")
    var goBuckButton = WUButton(backgroundColor: .clear, title: "戻る")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        selectCreateTeamOrInvitedByOtherTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        createTeamButton.translatesAutoresizingMaskIntoConstraints = false
        invitedByOtherTeamButton.translatesAutoresizingMaskIntoConstraints = false
        goBuckButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        addSubview(selectCreateTeamOrInvitedByOtherTeamLabel)
        addSubview(createTeamButton)
        addSubview(invitedByOtherTeamButton)
        addSubview(goBuckButton)
        
        selectCreateTeamOrInvitedByOtherTeamLabel.text = "選択してください"
        
        NSLayoutConstraint.activate([
            selectCreateTeamOrInvitedByOtherTeamLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            selectCreateTeamOrInvitedByOtherTeamLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            selectCreateTeamOrInvitedByOtherTeamLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            selectCreateTeamOrInvitedByOtherTeamLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            createTeamButton.topAnchor.constraint(equalTo: selectCreateTeamOrInvitedByOtherTeamLabel.bottomAnchor, constant: spacePadding),
            createTeamButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            createTeamButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            createTeamButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            invitedByOtherTeamButton.topAnchor.constraint(equalTo: createTeamButton.bottomAnchor, constant: spacePadding),
            invitedByOtherTeamButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            invitedByOtherTeamButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            invitedByOtherTeamButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            goBuckButton.topAnchor.constraint(equalTo: invitedByOtherTeamButton.bottomAnchor, constant: spacePadding),
            goBuckButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            goBuckButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            goBuckButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
    
    
}
