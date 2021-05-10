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
        UITabBar.appearance().tintColor = .systemOrange
        viewControllers = [createWakeUpCardCollectionListVC(),createWakeUpSettingVC(),createWakeUpAndCutAlertBySlideVC()]
    }
    
    
    func createWakeUpCardCollectionListVC() -> UINavigationController {
        let wakeUpCardCollectionListVC = WakeUpCardCollectionListVC()
        wakeUpCardCollectionListVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "house", title: "Home", tag: 0)
        return UINavigationController(rootViewController: wakeUpCardCollectionListVC)
    }
    
    
    func createWakeUpSettingVC() -> UINavigationController {
        let wakeUpSettingVC = WakeUpSettingVC()
        wakeUpSettingVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "gear", title: "Setting", tag: 1)
        return UINavigationController(rootViewController: wakeUpSettingVC)
    }
    
    func createWakeUpAndCutAlertBySlideVC() -> UINavigationController {
        let wakeUpAndCutAlertBySlideVC = WakeUpAndCutAlertBySlideVC()
        wakeUpAndCutAlertBySlideVC.tabBarItem = setSFSymbolsToTabBar(symbolSystemName: "house", title: "GPS暫定", tag: 2)
        return UINavigationController(rootViewController: wakeUpAndCutAlertBySlideVC)
    }
    

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
