//
//  DeleteDBModel.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/12.
//

import Foundation
import Firebase

class DeleteDBModel {
    let db = Firestore.firestore()
    
    func deleteChatRoomDocumentId(roomNameId: String) {
        //ユーザー側のチャット情報を削除
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Chats").document(roomNameId).delete()
        //ここのチャットルームは削除したら参照情報が消えてしまうので削除しない。
//        self.db.collection("Chats").document(roomNameId).delete()
    }
}
