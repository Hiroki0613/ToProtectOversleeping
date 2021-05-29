//
//  AppDelegate.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/03.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setUserDefaults()
        return true
    }
    
    
    func setUserDefaults() {
        let userDefaults = UserDefaults.standard
        //ディクショナリ形式で初期値を指定できる。
        //ユーザネーム
        //お住まいのGPS
        //新規登録時かどうかのBool
        userDefaults.register(defaults: [
            "userName" : "NoName777",
            "myAddressLatitude" : 35.637375,
            "myAddressLongitude" : 139.756308,
            "myAddress": "未登録",
            "isFirstOpenApp": true
        ])
        
        //値を取り出す
        let userName = userDefaults.object(forKey: "userName") as! String
        let myAddressLatitude = userDefaults.double(forKey: "myAddressLatitude")
        let myAddressLongitude = userDefaults.double(forKey: "myAddressLongitude")
        let myAddress = userDefaults.object(forKey: "myAddress") as! String
        
        print("UserDefaluts_name:",userName)
        print("UserDefaluts_myAddressLatitude:",myAddressLatitude)
        print("UserDefaluts_myAddressLongitude:",myAddressLongitude)
        print("UserDefaluts_myAddress", myAddress)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

