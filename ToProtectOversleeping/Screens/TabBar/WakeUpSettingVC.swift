//
//  WakeUpSettingVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/15.
//

import UIKit

class WakeUpSettingVC: UIViewController {
    
    var settingDataModel: SettingDataModel?
    
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
        setUserInformation()
        
        let loadDBModel = LoadDBModel()
        loadDBModel.getSettingDataDelegate = self
        loadDBModel.loadSettingMode()
    }
    
    private func setUserInformation() {
        
        let checkUserNameLabel = UserDefaults.standard.object(forKey: "userName") as! String
        
        if checkUserNameLabel == "NoName777" {
            wakeUpSettingView.setUserNameLabel.text = "ユーザーネームが未登録です"
        } else {
            wakeUpSettingView.setUserNameLabel.text = "ユーザネーム\n\(checkUserNameLabel)"
        }
        
        let checkAddress = UserDefaults.standard.object(forKey: "myAddress") as! String
        
        if checkAddress == "未登録" {
            wakeUpSettingView.getGPSAddressLabel.text = "自宅の住所が未登録です"
        } else {
            wakeUpSettingView.getGPSAddressLabel.text = "住所\n\(checkAddress)"
        }
    }
    
    func configureAddTarget() {
        wakeUpSettingView.setUserNameButton.addTarget(self, action: #selector(tapSetUserNameButton), for: .touchUpInside)
        wakeUpSettingView.getGPSAddressButton.addTarget(self, action: #selector(tapGetGPSAddressButton), for: .touchUpInside)
        wakeUpSettingView.licenseButton.addTarget(self, action: #selector(tapLicenseButton), for: .touchUpInside)
        wakeUpSettingView.opinionsAndRequestsButton.addTarget(self, action: #selector(tapOpinionsAndRequestsButton), for: .touchUpInside)
        wakeUpSettingView.evaluationButton.addTarget(self, action: #selector(tapEvaluationButton), for: .touchUpInside)
    }
    
    @objc func tapSetUserNameButton() {
        print("setUserNameButtonが押されました")
        let registerNameVC = RegisterNameVC()
        navigationController?.pushViewController(registerNameVC, animated: true)
    }
    
    @objc func tapGetGPSAddressButton() {
        print("getGPSAddressButtonが押されました")
        let getGpsAddressVC = GetGpsAddressVC()
        navigationController?.pushViewController(getGpsAddressVC, animated: true)
    }
    
    // 設定画面へ遷移
    @objc func tapLicenseButton() {
        print("licenseButtonが押されました")
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
        }
        if UIApplication.shared.canOpenURL(settingsUrl)  {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            })
          }
          else  {
            UIApplication.shared.openURL(settingsUrl)
          }
        }
    }
    
    @objc func tapOpinionsAndRequestsButton() {
        
        guard let urlString = settingDataModel?.contact else { return }
        guard let url = URL(string: urlString) else { return }
        self.presentSafariVC(with: url)
        
//        let loadDBModel = LoadDBModel()
//        loadDBModel.loadSettingMode { url in
//            guard let url = URL(string: url) else { return }
//            self.presentSafariVC(with: url)
//        }
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
            wakeUpSettingView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}

extension WakeUpSettingVC: GetSettingDataDelegate {
    func getSettingData(settingDataModel: SettingDataModel) {
        self.settingDataModel = settingDataModel
    }
}
