////
////  AppSettings.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/05/16.
////
//
//import Foundation
//
//final class AppSettings {
//  
//  private enum SettingKey: String {
//    case displayName
//  }
//  
//  // ここで登録した名前が入る。ユーザー名を決める
//  static var displayName: String! {
//    get {
//      return UserDefaults.standard.string(forKey: SettingKey.displayName.rawValue)
//    }
//    set {
//      let defaults = UserDefaults.standard
//      let key = SettingKey.displayName.rawValue
//      
//      if let name = newValue {
//        defaults.set(name, forKey: key)
//      } else {
//        defaults.removeObject(forKey: key)
//      }
//    }
//  }
//  
//}
