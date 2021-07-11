//
//  WUTabBarController.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit

class WUTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = PrimaryColor.primary
        viewControllers = [createWakeUpCardTableListVC(),createWakeUpSettingVC()]
    }
    
    
    func createWakeUpCardTableListVC() -> UINavigationController {
        let wakeUpCardTableListVC = WakeUpCardTableListVC()
        wakeUpCardTableListVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "house", title: "Home", tag: 1)
        return UINavigationController(rootViewController: wakeUpCardTableListVC)
    }
    
    
    func createWakeUpSettingVC() -> UINavigationController {
        let wakeUpSettingVC = WakeUpSettingVC()
        wakeUpSettingVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "gear", title: "Setting", tag: 2)
        return UINavigationController(rootViewController: wakeUpSettingVC)
    }
    
    func createSetAlarmTimeAndNewRegistrationVC() -> UINavigationController {
        let setAlarmTimeAndNewRegistrationVC = SetAlarmTimeAndNewRegistrationVC()
        setAlarmTimeAndNewRegistrationVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "gear", title: "Setting", tag: 3)
        return UINavigationController(rootViewController: setAlarmTimeAndNewRegistrationVC)
    }
    
    func createSetNewTeamMateNameVC() -> UINavigationController {
        let setNewTeamMateNameVC = SetNewTeamMateNameVC()
        setNewTeamMateNameVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "gear", title: "Setting", tag: 3)
        return UINavigationController(rootViewController: setNewTeamMateNameVC)
    }
    
    func createSetInvitedTeamMateVC() -> UINavigationController {
        let setInvitedTeamMateVC = SetInvitedTeamMateVC()
        setInvitedTeamMateVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "gear", title: "Setting", tag: 3)
        return UINavigationController(rootViewController: setInvitedTeamMateVC)
    }
    
    
    func createQRCodeReaderVC() -> UINavigationController {
        let qRCodeReaderVC = WakeUpQrCodeReaderVC()
        qRCodeReaderVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "gear", title: "Setting", tag: 2)
        return UINavigationController(rootViewController: qRCodeReaderVC)
    }
    //    QRCodeReaderVC
    
//    func createCheckVendingMachineVC() -> UINavigationController {
//        let checkVendingMachineVC = CheckVendingMachineVC()
//        checkVendingMachineVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "cloud", title: "Machine", tag: 2)
//        return UINavigationController(rootViewController: checkVendingMachineVC)
//    }
    
//    CheckVendingMachineVC
    
    /// SFSymbolsをTabBarにいれる
    /// - Parameters:
    ///   - symbolSystemName: SFSymbolsの名前
    ///   - title: Tabに表示したい名前
    ///   - tag: タブのタグ
    /// - Returns: 
    func setSFSymbolsToTabBar(symbolSystemName: String, title: String, tag: Int) -> UITabBarItem {
        let iconConfig = UIImage.SymbolConfiguration(scale: .large)
        let icon = UIImage(systemName: symbolSystemName, withConfiguration: iconConfig)
        let settingsTabBarItem = UITabBarItem(title: title, image: icon, tag: tag)
        return settingsTabBarItem
    }
    
}
