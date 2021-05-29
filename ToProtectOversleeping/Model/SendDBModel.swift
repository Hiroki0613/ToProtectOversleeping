//
//  SendDBModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/29.
//

import Foundation
import Firebase

protocol DoneCreateUser {
    func doneCreateUser()
}

class SendDBModel {
    let db = Firestore.firestore()
    
    var doneCreateUser:DoneCreateUser?
    
//    var senderID: String = ""
//    var toID: String = ""
//    var text: String = ""
//    var displayName: String = ""
    
    
    // 新規作成の時は、ユーザー登録画面に画面遷移させる。
    /// 新規ユーザー作成
    /// - Parameters:
    ///   - name: ユーザー名
    ///   - uid: FirebaseのAuth.auth()
    ///   - appVersion: アプリのバージョン
    ///   - isWakeUpBool: 起きた時に使われるBool(暫定的に用意)
    func createUser(name: String,uid: String,appVersion: String, isWakeUpBool: Bool) {
        // ここでUserModelを作成。
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
            ["name": name as Any,"uid": uid as Any, "appVersion": appVersion as Any,
             "isWakeUpBool": isWakeUpBool as Any,"date": Date().timeIntervalSince1970]
        )
        self.doneCreateUser?.doneCreateUser()
    }
    
        
//    func sendMessage(senderID: String, toID: String, text: String, displayName: String) {
//        self.db.collection("Chats").document(senderID).collection("talk").document(toID).setData([
//            "text": text as Any,"senderID": senderID as Any,"displayName": displayName as Any, "date": Date().timeIntervalSince1970]
//        )
//        self.db.collection("Chats").document(toID).collection("talk").document(senderID).setData(
//            ["text": text as Any, "senderID": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
//        )
//    }
    
    
    
}
