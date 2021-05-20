//
//  WakeUpSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/15.
//

import UIKit

class WakeUpSettingVC: UIViewController {
    
    let scrollView = UIScrollView()
    var wakeUpSettingView = WakeUpSettingView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        configureView()
        configureAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureAddTarget() {
        wakeUpSettingView.setUserNameButton.addTarget(self, action: #selector(tapSetUserNameButton), for: .touchUpInside)
        wakeUpSettingView.getGPSAddressButton.addTarget(self, action: #selector(tapGetGPSAddressButton), for: .touchUpInside)
        wakeUpSettingView.setNotificationSwitch.addTarget(self, action: #selector(tapSetNotificationSwitch), for: .touchUpInside)
        
        wakeUpSettingView.licenseButton.addTarget(self, action: #selector(tapLicenseButton), for: .touchUpInside)
        wakeUpSettingView.opinionsAndRequestsButton.addTarget(self, action: #selector(tapOpinionsAndRequestsButton), for: .touchUpInside)
        wakeUpSettingView.evaluationButton.addTarget(self, action: #selector(tapEvaluationButton), for: .touchUpInside)
    }
    
    @objc func tapSetUserNameButton() {
        print("setUserNameButtonが押されました")
    }
    
    @objc func tapGetGPSAddressButton() {
        print("getGPSAddressButtonが押されました")
        let getGpsAddressVC = GetGpsAddressVC()
        navigationController?.pushViewController(getGpsAddressVC, animated: true)
    }
    
    //TODO: このままではUISwitchの機能が生かせない。
    @objc func tapSetNotificationSwitch() {
        print("setNotificationSwitchが押されました")
    }
    
    @objc func tapLicenseButton() {
        print("licenseButtonが押されました")
    }
    
    @objc func tapOpinionsAndRequestsButton() {
        print("opinionsAndRequestsButtonが押されました")
    }
    
    @objc func tapEvaluationButton() {
        print("evaluationButtonが押されました")
    }
    
    
    
    
    
    private func configureView() {
        view.addSubview(scrollView)
        wakeUpSettingView.frame = view.bounds
        scrollView.addSubview(wakeUpSettingView)
        wakeUpSettingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            wakeUpSettingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            wakeUpSettingView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wakeUpSettingView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wakeUpSettingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            wakeUpSettingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            wakeUpSettingView.heightAnchor.constraint(equalToConstant: 800)
        ])
    }


}
