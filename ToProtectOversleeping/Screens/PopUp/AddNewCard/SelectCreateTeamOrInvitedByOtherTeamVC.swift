//
//  SelectCreateTeamOrInvitedByOtherTeamVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/12/31.
//

import UIKit

class SelectCreateTeamOrInvitedByOtherTeamVC: UIViewController {
    let selectCreateTeamOrInvitedByOtherTeamView = SelectCreateTeamOrInvitedByOtherTeamView()
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground(name: "orange")
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
        selectCreateTeamOrInvitedByOtherTeamView.createTeamButton.addTarget(self, action: #selector(createTeam), for: .touchUpInside)
        selectCreateTeamOrInvitedByOtherTeamView.invitedByOtherTeamButton.addTarget(self, action: #selector(invitedByOtherTeam), for: .touchUpInside)
        selectCreateTeamOrInvitedByOtherTeamView.goBuckButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    @objc func createTeam() {
        let setNewTeamMateNameVC = SetNewTeamMateNameVC()
        self.navigationController?.pushViewController(setNewTeamMateNameVC, animated: true)
    }
    
    @objc func invitedByOtherTeam() {
        let setInvitedTeamMateVC = SetInvitedTeamMateVC()
        //userDataModel.nameを持ってくる
        setInvitedTeamMateVC.userName = userName
        
        self.present(setInvitedTeamMateVC, animated: true,completion: nil)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func configureView() {
        configureBlurView()
        configureCardView()
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    func configureCardView() {
        selectCreateTeamOrInvitedByOtherTeamView.translatesAutoresizingMaskIntoConstraints = false
        selectCreateTeamOrInvitedByOtherTeamView.layer.cornerRadius = 16
        view.addSubview(selectCreateTeamOrInvitedByOtherTeamView)
        
        NSLayoutConstraint.activate([
            selectCreateTeamOrInvitedByOtherTeamView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            selectCreateTeamOrInvitedByOtherTeamView.heightAnchor.constraint(equalToConstant: 400),
            selectCreateTeamOrInvitedByOtherTeamView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectCreateTeamOrInvitedByOtherTeamView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
