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

//protocol DoneCreateChatRoom {
//    func doneCreateChatRoom()
//}

protocol DoneInvitedChatRoom {
    func doneInvitedChatRoom()
}

class SendDBModel {
    let db = Firestore.firestore()
    
    var loadDBModel = LoadDBModel()
    
    var doneCreateUser: DoneCreateUser?
//    var doneCreateChatRoom: DoneCreateChatRoom?
    var doneInvitedChatRoom: DoneInvitedChatRoom?
    
    /// 新規作成の時は、ユーザー登録画面に画面遷移させる。
    /// ユーザー作成
    /// - Parameters:
    ///   - name: ユーザー名
    ///   - uid: FirebaseのAuth.auth()
    ///   - appVersion: アプリのバージョン
    ///   - isWakeUpBool: 起きた時に使われるBool
    func createUser(name: String,uid: String,appVersion: String, isBilling: Bool, homeRoomId: String, teamChatRoomId: String, teamChatName: String, theGoalSetting: String) {
        // ここでUserModelを作成。
        //TODO: 不正防止にFirebaseが用意している、時刻を使うこと。
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
            ["name": name as Any,
             "uid": uid as Any,
             "appVersion": appVersion as Any,
             "isBilling": isBilling as Any,
             "date": Date().timeIntervalSince1970 as Any,
             "displayAdvertise": true as Any,
             "developerMode": false as Any,
             "homeRoomId": homeRoomId as Any,
             "teamChatRoomId": teamChatRoomId as Any,
             "teamChatName": teamChatName as Any,
             "theGoalSetting": theGoalSetting as Any
            ]
        )
        self.doneCreateUser?.doneCreateUser()
    }
    
    
    // ランダムStringを作成
    func randomString(length: Int) -> String {
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    
    /// チャットルーム作成
    /// - Parameters:
    ///   - roomName: チャットルームの名前
    ///   - wakeUpTime: 起きる時間
    ///   - isWakeUpBool: 起きた時に使われるBool
    ///   - dayOfTheWeek: 曜日を規定
    func createHomeRoom(roomName: String, wakeUpTimeDate: Date, wakeUpTimeText: String, isWakeUpBool: Bool, dayOfTheWeek: String, appVersion: String) {
        //"Home"のdocumentIDのために、ランダムStringを作成
        let generatedHomeRoomRandomString = "WU\(randomString(length: 18))"
//        let generatedRandomString = "WU123456789123456789"
        print("SendDB_generatedRandomString: ", generatedHomeRoomRandomString)
        
        // Userでチャットルームを作成。こちらでカード一覧を表示。chatRoomIdで部屋を分別。
        // 招待されたら、chatRoomIdを変更する。
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(generatedHomeRoomRandomString).setData(
            [
                "roomName": roomName as Any,
                "uid": Auth.auth().currentUser!.uid as Any,
                "wakeUpTimeText": wakeUpTimeText as Any,
                "wakeUpTimeDate": Double( wakeUpTimeDate.timeIntervalSince1970) as Any,
                "registerDate": Date().timeIntervalSince1970 as
                Any,
                "isWakeUpBool": isWakeUpBool as Any,
                "homeChatRoomId": generatedHomeRoomRandomString as Any,
//                "chatRoomId": chatRoomId as Any,
                "dayOfTheWeek": dayOfTheWeek as Any,
                "appVersion": appVersion as Any
            ]
        )
    }
    
    func createChatRoom(roomName: String, defaultWakeUpTimeDate: Date, defaultWakeUpTimeText: String, chatRoomId: String, appVersion: String) {
        // Chatルームは別に作成
        self.db.collection("Chats").document(chatRoomId).setData(
            [
                "roomName": roomName as Any,
//                "chatRoomId": generatedRandomString,
                "uid": Auth.auth().currentUser!.uid as Any,
                "defaultWakeUpTimeDate": Double( defaultWakeUpTimeDate.timeIntervalSince1970) as Any,
                "defaultWakeUpTimeText": defaultWakeUpTimeText as Any,
                "registerDate": Date().timeIntervalSince1970 as
                Any,
                "chatRoomId": chatRoomId as Any,
                "appVersion": appVersion as
                Any
            ]
        )
//         同時にUNNotificationCenterにも通知登録identifier付きで行う。
//        alarmSet(identifierString: generatedRandomString)
//        self.doneCreateChatRoom?.doneCreateChatRoom()
    }

    
    //TODO: チャットルーム招待時に、チーム名を新規で決めて、そこに招待することにする。
    
    /// チャットルーム招待
    /// - Parameters:
    ///   - roomNameID: チャットルームのID
    ///   - wakeUpTime: 起きる時間
    func invitedChatRoom(roomNameId: String, wakeUpTimeDate: Date, wakeUpTimeText: String, isWakeUpBool: Bool, dayOfTheWeek: String, appVersion: String) {
        
        let loadDBModel = LoadDBModel()
        loadDBModel.loadChatRoomDocumentId(roomNameId: roomNameId) { roomNameString in
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(roomNameId).setData(
                ["roomName": roomNameString as Any,
                 "uid": Auth.auth().currentUser!.uid as Any,
                 "wakeUpTimeText": wakeUpTimeText as Any,
                 "wakeUpTimeDate": Double( wakeUpTimeDate.timeIntervalSince1970) as Any,
                 "registerDate": Date().timeIntervalSince1970 as Any,
                "isWakeUpBool": isWakeUpBool as Any,
                "dayOfTheWeek": dayOfTheWeek as Any,
                "appVersion": appVersion as Any
                ]
            )
//            self.alarmSet(identifierString: roomNameId)
        }
    }
    
    // アラームをセットした時に論理の反転をfireStoreに記録させる。
    func switchedChatRoomWakeUpAlarm(roomNameId: String, isWakeUpBool: Bool) {
        let loadDBModel = LoadDBModel()
        loadDBModel.loadChatRoomDocumentId(roomNameId: roomNameId) { _ in
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(roomNameId).updateData(
                ["isWakeUpBool": isWakeUpBool as Any]
            )
        }
    }
    
    // アラームの時間を変更した時に、時間をfireStoreに記録させる
    func changedChatRoomWakeUpAlarmTime(roomNameId: String, wakeUpTimeDate: Date,wakeUpTimeText: String ) {
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(roomNameId).updateData(
            [
                "wakeUpTimeText": wakeUpTimeText as Any,
                "wakeUpTimeDate": Double( wakeUpTimeDate.timeIntervalSince1970) as Any
            ]
        )
    }
    
    
    func sendMessage(senderId: String, toID: String, text: String, displayName: String, messageAppVersion: String, sendWUMessageType: String) {
        
        self.db.collection("Chats").document(toID).collection("Talk").document().setData(
            [
                "text":text as Any,
                "senderId": senderId as Any,
                "displayName": displayName as Any,
                "date": Date().timeIntervalSince1970,
                "messageAppVersion": messageAppVersion as Any,
                "sendWUMessageType": sendWUMessageType as Any
            ]
        )
    }
    
    
    //アラート設定
//    func alarmSet(identifierString: String){
//        // identifierは一位にするため、Auth.auth()+roomIdにする
//        let identifier = Auth.auth().currentUser!.uid + identifierString
//        removeAlarm(identifiers: identifier)
//
//        //通知設定
//        let content = UNMutableNotificationContent()
//        content.title = "みんなの結果を見てみよう♪"
//
//        content.categoryIdentifier = identifier
//        var dateComponents = DateComponents()
//
//        //近藤　カレンダー形式で通知
//        dateComponents.hour = 12
//        dateComponents.minute = 00
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        //identifierは一意にするため、Auth.auth()+roomIdにする。
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
    //アラート設定削除
//    func removeAlarm(identifiers:String){
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifiers])
//    }
}
