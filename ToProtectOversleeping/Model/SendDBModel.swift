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
    /// ユーザー作成
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
    
    
    /// チャットルーム作成
    /// - Parameters:
    ///   - roomName: チャットルームの名前
    ///   - wakeUpTime: 起きる時間
    func createChatRoom(roomName: String, wakeUpTime: Date) {
        self.db.collection("Chats").document().setData(
            ["roomName": roomName as Any, "wakeUpTime": wakeUpTime as Any, "uid": Auth.auth().currentUser!.uid as Any, "registerDate": Date().timeIntervalSince1970]
        )
    }
    
    
    func sendMessage(senderId: String, toID: String, text: String, displayName: String) {
        self.db.collection("Chats").document(senderId).collection("Talk").document(toID).setData(
            ["text": text as Any, "senderId": senderId as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
        self.db.collection("Chats").document(toID).collection("Talk").document(senderId).setData(
            ["text": text as Any, "senderId": Auth.auth().currentUser!.uid as Any, "displayName": displayName as Any, "date": Date().timeIntervalSince1970]
        )
    }
}
