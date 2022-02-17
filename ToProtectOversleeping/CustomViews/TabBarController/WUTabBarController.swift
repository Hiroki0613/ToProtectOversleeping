//
//  WUTabBarController.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/08.
//

import UIKit
import Firebase
import KeychainSwift

class WUTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = PrimaryColor.primary
        //iOS15からtabBarの背景が透明になったため実装
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.selectionIndicatorTintColor = PrimaryColor.background
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            tabBar.addBlurToView(alpha: 0.7)
        } else {
            // Fallback on earlier versions
            // 背景の透過
            UITabBar.appearance().backgroundImage = UIImage()
            // 境界線の透過
            UITabBar.appearance().shadowImage = UIImage()
        }
        
        viewControllers = [createWakeUpCardHomeVC(),createWakeUpSettingVC()]
    }
    
        
    func checkNeedIntroductionView(complition:() -> Void) {
        // UserDefaultの値で最初の画面を分岐させる
        if UserDefaults.standard.bool(forKey: "isFirstOpenApp") == true {
               //keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
            let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)
            // 開発時のログアウト(最初から)は、アプリを消して。ここのコメントを使ってkeychainを切る。
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("SignOutError: %@", signOutError)
            }
            
            keychain.clear()
            
            let walkThroughByEAIntroViewVC = WalkThroughByEAIntroViewVC()
            navigationController?.pushViewController(walkThroughByEAIntroViewVC, animated: true)
        } else {
            print("すでに新規登録しています")
        }
    }
    
    
    func createWakeUpCardHomeVC() -> UINavigationController {
        let wakeUpCardHomeVC = WakeUpCardHomeVC()
        wakeUpCardHomeVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "house", title: "タイトル", tag: 1)
        return UINavigationController(rootViewController: wakeUpCardHomeVC)
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
    
    func createNewRegistrationUserGoalSettingVC() -> UINavigationController {
        let setNewRegistrationUserGoalSettingVC = NewRegistrationUserGoalSettingVC()
        setNewRegistrationUserGoalSettingVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "cloud", title: "Goal", tag: 0)
        return UINavigationController(rootViewController: setNewRegistrationUserGoalSettingVC)
    }
    
    func createWalkThroughByPageByScrollViewVC() -> UINavigationController {
        let setWalkThroughByPageByScrollViewVC = WalkThroughByEAIntroViewVC()
        setWalkThroughByPageByScrollViewVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "sun", title: "歩く", tag: 0)
        return UINavigationController(rootViewController: setWalkThroughByPageByScrollViewVC)
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
