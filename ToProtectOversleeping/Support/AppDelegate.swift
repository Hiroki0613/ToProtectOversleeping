//
//  AppDelegate.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/03.
//

import UIKit
import Firebase
import KeychainSwift

struct Keys {
    static let prefixKeychain = "WUKeychain_"
    static let myAddress = "myAddress"
    static let myAddressLatitude = "myAddressLatitude"
    static let myAddressLongitude = "myAddressLongitude"
}


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    //keychainのデフォルトセッティング。見つけやすいように共通のprefixを実装。
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKeychain)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        
        // 開発時のログアウト(最初から)は、アプリを消して。ここのコメントを使ってkeychainを切る。
        // アプリを閉じて、２回目を開く時にはここを再びコメントアウトしておくこと
//        do {
//            try Auth.auth().signOut()
//        } catch let signOutError as NSError {
//            print("SignOutError: %@", signOutError)
//        }
        
        
        
        setUserPlaceholderData()
        return true
    }
    
    
    func setUserPlaceholderData() {
//        keychain.set("\(PrimaryPlace.primaryAddressLatitude)", forKey: Keys.myAddressLatitude)
//        keychain.set("\(PrimaryPlace.primaryAddressLongitude)", forKey: Keys.myAddressLongitude)
        
        
        // 開発時のログアウト(最初から)は、アプリを消して。ここのコメントを使ってkeychainを切る。
        // アプリを閉じて、２回目を開く時にはここを再びコメントアウトしておくこと
        
        // 最初にログイン、ログアウトボタンを一つ入れておいた方が操作性が良さそうだ。
        // ただし、アニノマスログインでアプリに対する障壁は低くしたほうが良いと思う。
        
        // ログアウト時には、データは全消去という形だと楽かも。
//        keychain.clear()
        
        
        
        let userDefaults = UserDefaults.standard
        //ユーザネーム
        //新規登録時かどうかのBool
        //chat画面を開いた日付けをチェック
        userDefaults.register(defaults: [
            //ユーザー名
            "userName" : "NoName777",
            "isFirstOpenApp": true,
            "wakeUpResultDate": 10.0,
            "teamChatName": "NoName777",
            "theGoalSettingText": "",
            "isFirstDownloadInstructions": true
//            "myAddressLatitude" : 35.637375,
//            "myAddressLongitude" : 139.756308,
//            "myAddress": "未登録",
        ])
        
        //値を取り出す
        let userName = userDefaults.object(forKey: "userName") as! String
//        let myAddressLatitude = userDefaults.double(forKey: "myAddressLatitude")
//        let myAddressLongitude = userDefaults.double(forKey: "myAddressLongitude")
//        let myAddressLongLongtiude = userDefaults.double(forKey: "myAddressLongLongtitude")
//        let myAddress = userDefaults.object(forKey: "myAddress") as! String
        
        print("UserDefaluts_name:",userName)
//        print("UserDefaluts_myAddressLatitude:",myAddressLatitude)
//        print("UserDefaluts_myAddressLongitude:",myAddressLongitude)
////        print("UserDefaults_myAddressLongLongTitude: ",  myAddressLongLongtiude)
//        print("UserDefaluts_myAddress", myAddress)
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

