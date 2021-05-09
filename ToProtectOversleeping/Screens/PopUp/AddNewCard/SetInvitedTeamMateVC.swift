//
//  SetInvitedTeamMateVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/09.
//

import UIKit

class SetInvitedTeamMateVC: UIViewController {
    // チームを新規登録
    var setInvitedTeamMateNameView = SetInvitedTeamMateView()
    
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
    }
    
    // 戻る
    @objc func goBack() {
        print("戻るボタン2")
        dismiss(animated: true, completion: nil)
        
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
