//
//  SetNewTeamMateNameVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetNewTeamMateNameVC: UIViewController {
    
    // チームを新規登録
    var setNewTeamMateNameView = SetNewTeamMateNameView()
    
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
            setNewTeamMateNameView.chatTeamNewRegisterButton.addTarget(self, action: #selector(registerNewTeam), for: .touchUpInside)
            setNewTeamMateNameView.chatTeamGoBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    // 新規登録
    @objc func registerNewTeam() {
        print("新規登録しました")
    }
    
    // 招待してもらう
    @objc func goBack() {
        print("戻るボタン")
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func configureView() {
        configureBlurView()
        configureCardView()
    }
    
    func configureCardView(){
        setNewTeamMateNameView.frame = CGRect(x: 10, y: view.frame.size.height / 2 - 60, width: view.frame.size.width - 20, height: 200)
        view.addSubview(setNewTeamMateNameView)
    }
    
    func configureBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
    }
    
    // セルを装飾
    private func configureDecoration() {
        setNewTeamMateNameView.layer.shadowColor = UIColor.systemGray.cgColor
        setNewTeamMateNameView.layer.cornerRadius = 16
        setNewTeamMateNameView.layer.shadowOpacity = 0.1
        setNewTeamMateNameView.layer.shadowRadius = 10
        setNewTeamMateNameView.layer.shadowOffset = .init(width: 0, height: 10)
        setNewTeamMateNameView.layer.shouldRasterize = true
    }
}


extension SetNewTeamMateNameVC: UITableViewDelegate {
//    override func resignFirstResponder() -> Bool {
//        <#code#>
//    }
    
}