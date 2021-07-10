//
//  LoadDBModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/30.
//

import Foundation
import Firebase

protocol GetChatRoomNameDelegate {
    func getChatRoomName(chatRoomNameModel:[ChatRoomNameModel])
    func getChatDocumentId(chatRoomDocumentId:[String])
}

protocol GetUserDataDelegate {
    func getUserData(userDataModel: UserDataModel)
}

protocol GetSettingDataDelegate {
    func getSettingData(settingDataModel: SettingDataModel)
}

class LoadDBModel {
    var db = Firestore.firestore()
    var getChatRoomNameDelegate: GetChatRoomNameDelegate?
    var getUserDataDelegate: GetUserDataDelegate?
    var getSettingDataDelegate: GetSettingDataDelegate?
    var chatRoomNameArray = [ChatRoomNameModel]()
    var chatDocumentIdArray = [""]
    
    // プロフィールの呼び出し
    func loadProfileData() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let data = snapShot?.data() {
                if let name = data["name"] as? String,
                    let uid = data["uid"] as? String,
                    let appVersion = data["appVersion"] as? String,
                    let isBilling = data["isBilling"] as? Bool,
                    let date = data["date"] as? Double,
                    let _ = data["displayAdvertise"] as? Bool,
                    let _ = data["developerMode"] as? Bool,
                    let homeRoomId = data["homeRoomId"] as? String,
                    let teamChatRoomId = data["teamChatRoomId"] as? String,
                    let teamChatName = data["teamChatName"] as? String,
                    let theGoalSetting = data["theGoalSetting"] as? String
                {
                    let userDataModel = UserDataModel(name: name, uid: uid, appVersion: appVersion, isBilling: isBilling, date: date, homeRoomId: homeRoomId, teamChatRoomId: teamChatRoomId, teamChatName: teamChatName, theGoalSetting: theGoalSetting)
                    self.getUserDataDelegate?.getUserData(userDataModel: userDataModel)
                }
            }
        }
    }
    

    
    // セッティングの呼び出し
    func loadSettingMode() {
        db.collection("Setting").document("setting").addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let data = snapShot?.data() {
                if let contact = data["contact"] as? String
                {
                    let settingDataModel = SettingDataModel(contact: contact)
                    self.getSettingDataDelegate?.getSettingData(settingDataModel: settingDataModel)
                }
            }
        }
    }
    
    
    // チャットルームの呼び出し
    func loadChatRoomNameData() {
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").order(by: "dayOfTheWeek",descending: false).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents {
                self.chatRoomNameArray = []
                self.chatDocumentIdArray = []
                for doc in snapShotDoc {
                    
                    // chatRoomNameArray
                    let data = doc.data()
                    print("dataだぜ: ",data)
                    if
                    let roomName = data["roomName"] as? String,
                       let uid = data["uid"] as? String,
                       let wakeUpTimeText = data["wakeUpTimeText"] as? String,
                       let wakeUpTimeDate = data["wakeUpTimeDate"] as? Double,
                       let registerDate = data["registerDate"] as? Double,
                       let isWakeUpBool = data["isWakeUpBool"] as? Bool,
                       let homeChatRoomId = data["homeChatRoomId"] as? String,
                       let dayOfTheWeek = data["dayOfTheWeek"] as? String,
                       let appVersion = data["appVersion"] as? String
                       {
                        let chatRoomNameModel = ChatRoomNameModel(
                            roomName: roomName,
                            uid: uid,
                            wakeUpTimeText: wakeUpTimeText,
                            wakeUpTimeDate:wakeUpTimeDate,
                            registerDate: registerDate,
                            isWakeUpBool: isWakeUpBool,
                            homeChatRoomId: homeChatRoomId,
                            dayOfTheWeek: dayOfTheWeek,
                            appVersion: appVersion)
                        
                        self.chatRoomNameArray.append(chatRoomNameModel)
                        self.chatDocumentIdArray.append(homeChatRoomId)
                    }
                    
                    // chatDocumentIDArray
                    self.chatDocumentIdArray.append(doc.documentID)
                }
                print(self.chatRoomNameArray)
                self.getChatRoomNameDelegate?.getChatRoomName(chatRoomNameModel: self.chatRoomNameArray)
                self.getChatRoomNameDelegate?.getChatDocumentId(chatRoomDocumentId: self.chatDocumentIdArray)
            }
        }
    }
    
    
    func loadChatRoomDocumentId(roomNameId: String, complition:(@escaping(String) -> Void)) {
        var roomNameString = "空白"
        db.collection("Chats").document(roomNameId).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let data = snapShot?.data() {
                roomNameString = data["roomName"] as! String
                print("data.roomName: ", roomNameString)
            }
            complition(roomNameString)
        }
    }
}

