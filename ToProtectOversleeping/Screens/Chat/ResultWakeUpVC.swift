//
//  ResultWakeUpVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/16.
//

import UIKit
import Firebase

class ResultWakeUpVC: UIViewController {
    
    // 一旦ここでaddSnapをさせる
    let db = Firestore.firestore()
    var teamName = ""
    
    var chatRoomDocumentId: String?
    
    var wakeUpSuccessPersonList: [String] = []
    var wakeUpRainyDayPersonList: [String] = []
    
    var titleLabel = WUBodyLabel(fontSize: 35)
    var resultLabel = WUBodyLabel(fontSize: 30)
    var resultStackView = UIStackView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = PrimaryColor.primary
        
        guard let chatRoomDocumentId = chatRoomDocumentId else { return }
        loadMessage(toID: chatRoomDocumentId)
        print("宏輝_chatRoomDocumentId: ",chatRoomDocumentId)
        print("宏輝_wakeUpSuccessPersonListAtChat: ",wakeUpSuccessPersonList)
        configureUI()
        configureTextOutlineShapeView()
        self.view.layoutIfNeeded()
    }
    
    func configureTextOutlineShapeView() {
        let str = teamName
        guard let font = UIFont(name: "HiraKakuProN-W6", size: 30) else { return }
        
        let textOptions = TextOutlineShapeView.TextOptions(text: str,
                                                           font: font,
                                                           lineSpacing: 10,
                                                           textAlignment: .right)
        let shapeOptions = TextOutlineShapeView.ShapeOptions(lineJoin: .round,
                                                             fillColor: UIColor.white.cgColor,
                                                             strokeColor: UIColor.blue.cgColor,
                                                             lineWidth: 5,
                                                             shadowColor: UIColor.black.cgColor,
                                                             shadowOffset: CGSize(width: 3, height: 3),
                                                             shadowRadius: 5,
                                                             shadowOpacity: 0.6)
        let shapeView = TextOutlineShapeView(textOptions: textOptions, shapeOptions: shapeOptions)
        self.view.addSubview(shapeView)
        
        shapeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shapeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            shapeView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            shapeView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            shapeView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    //どこかのチャットルームで開かれているトークを日付順で並べている。
    func loadMessage(toID: String) {
        db.collection("Chats").document(toID).collection("Talk").order(by: "date").addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            
            // アプリバージョンごとにif letでunlapさせて
            if let snapShotDoc = snapshot?.documents {
                
                for doc in snapShotDoc {
                    let data = doc.data()
                    print("data: ",data)
                    
                    guard let messageAppVersion = data["messageAppVersion"] as? String else { return }
                    
                    if messageAppVersion == "1.0.0" {
                        if let _ = data["text"] as? String,
                           let _ = data["senderId"] as? String,
                           let displayName = data["displayName"] as? String,
                           let date = data["date"] as? Double,
                           let sendWUMessageType = data["sendWUMessageType"] as? String
                        {
                            // まず目が覚めた人をリストに上げる
                            if sendWUMessageType == SendWUMessageType.wakeUpSuccessMessage {
                                let calendar = Calendar(identifier: .gregorian)
                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
                                
                                let date = Date(timeIntervalSince1970: date)
                                
                                // 今日の日付ならappend
                                if calendar.isDateInToday(date) {
                                    print("宏輝_起きたresult: ",displayName)
                                    self.wakeUpSuccessPersonList.append(displayName)
                                    //                                    let label = UILabel()
                                    //                                    label.translatesAutoresizingMaskIntoConstraints = false
                                    //                                    self.labelArray.append(label)
                                    print("宏輝_起きたリストresult: ", self.wakeUpSuccessPersonList)
                                }
                                
                                if calendar.isDateInToday(date) {
                                    print("宏輝_雨の日リストresult: ", self.wakeUpRainyDayPersonList)
                                    self.wakeUpRainyDayPersonList.append(displayName)
                                }
                            }
                            
                            // まず目が覚めた人をリストに上げる
                            if sendWUMessageType == SendWUMessageType.rainyDay {
                                let calendar = Calendar(identifier: .gregorian)
                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
                                
                                let date = Date(timeIntervalSince1970: date)
                                
                                // 今日の日付ならappend
                                if calendar.isDateInToday(date) {
                                    print("宏輝_雨の日リストresult: ", self.wakeUpRainyDayPersonList)
                                    self.wakeUpRainyDayPersonList.append(displayName)
                                }
                            }
                        }
                    }
                }
                
                //                // 晴れの日、雨の日を分割して、一覧にしている
                //                let orderedSetSuccess: NSOrderedSet = NSOrderedSet(array:  self.wakeUpSuccessPersonList)
                //                self.wakeUpSuccessPersonList = orderedSetSuccess.array as! [String]
                //                    let text1 = self.wakeUpSuccessPersonList.joined(separator: "\n")
                //                let orderedSetRainyDay: NSOrderedSet = NSOrderedSet(array: self.wakeUpRainyDayPersonList)
                //                self.wakeUpRainyDayPersonList = orderedSetRainyDay.array as! [String]
                //                let text2 = self.wakeUpRainyDayPersonList.joined(separator: "\n")
                //                    self.resultLabel.text = "\(text1)\n\n☔️雨の日☔️\n\(text2)"
                
                // 起きた人を一括で管理している
                var wakeUpPeopleArray = self.wakeUpSuccessPersonList + self.wakeUpRainyDayPersonList
//                var wakeUpPeopleArray = ["レッド","ブルー","ピンク","グリーン","イエロー"]
                let orderedSetWakeUpPeople: NSOrderedSet = NSOrderedSet(array: wakeUpPeopleArray)
                wakeUpPeopleArray = orderedSetWakeUpPeople.array as! [String]
                let wakeUpText = wakeUpPeopleArray.joined(separator: "\n")
                self.resultLabel.text = wakeUpText
            }
        }
    }
    
    
    
    
    func configureUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        
        titleLabel.text = "早起きができた人"
        
        //        resultLabel.text = wakeUpSuccessPersonList.joined(separator: "\n")
        
        
        //        for wakeUpSuccessPerson in wakeUpSuccessPersonList777 {
        //            resultLabel.text = wakeUpSuccessPerson + "\n"
        //        }
        
        
        view.addSubview(titleLabel)
        view.addSubview(resultLabel)
        //        view.addSubview(resultStackView)
        
        //        for i in 0...(wakeUpSuccessPersonList.count - 1) {
        //            let resultLabelArray = [WUBodyLabel(fontSize: 16)]
        //            resultLabelArray[i].text = wakeUpSuccessPersonList[i]
        //            resultStackView.addArrangedSubview(resultLabelArray[i])
        //        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
            
            //            resultStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            //            resultStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            //            resultStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            ////            resultStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            resultStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            
        ])
    }
    
    
    
}
