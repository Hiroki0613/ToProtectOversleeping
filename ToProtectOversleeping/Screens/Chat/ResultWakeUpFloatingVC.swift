////
////  ResultWakeUpFloatingVC.swift
////  ToProtectOversleeping
////
////  Created by 近藤宏輝 on 2021/06/14.
////
//
//import UIKit
//import FloatingPanel
//import Firebase
//import FirebaseFirestore
//
//class ResultWakeUpFloatingVC: UIViewController {
//
//    // 一旦ここでaddSnapをさせる
//    let db = Firestore.firestore()
//    var chatRoomDocumentId: String?
//    
//    var wakeUpSuccessPersonList = [String]()
//    
//    var titleLabel = WUBodyLabel(fontSize: 20)
//    var resultLabel = WUBodyLabel(fontSize: 30)
//    var resultStackView = UIStackView(frame: .zero)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemOrange
//        print("宏輝_documentID_floating: ", chatRoomDocumentId)
//        guard let chatRoomDocumentId = chatRoomDocumentId else { return }
//        
//        loadMessage(toID: chatRoomDocumentId)
//        print("宏輝_chatRoomDocumentId: ",chatRoomDocumentId)
//        print("宏輝_wakeUpSuccessPersonListAtChat: ",wakeUpSuccessPersonList)
//        configureUI()
//        self.view.layoutIfNeeded()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        //グラデーションをつける
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        //グラデーションさせるカラーの設定
//        let color1 = UIColor.systemOrange.withAlphaComponent(0.0).cgColor
//        let color2 = UIColor.systemOrange.cgColor
//
//        gradientLayer.colors = [color1, color2]
//        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint.init(x: 0.0 , y: 0.07)
//        self.view.layer.insertSublayer(gradientLayer,at:0)
//    }
//    
//    //どこかのチャットルームで開かれているトークを日付順で並べている。
//    func loadMessage(toID: String) {
//        db.collection("Chats").document(toID).collection("Talk").order(by: "date").addSnapshotListener { snapshot, error in
//            if error != nil {
//                return
//            }
//            
//            // アプリバージョンごとにif letでunlapさせて
//            if let snapShotDoc = snapshot?.documents {
//                
//                
//                
//                for doc in snapShotDoc {
//                    let data = doc.data()
//                    print("data: ",data)
//                    
//                    guard let messageAppVersion = data["messageAppVersion"] as? String else { return }
//                    
//                    if messageAppVersion == "1.0.0" {
//                        if let _ = data["text"] as? String,
//                           let _ = data["senderId"] as? String,
//                           let displayName = data["displayName"] as? String,
//                           let date = data["date"] as? Double,
//                           let sendWUMessageType = data["sendWUMessageType"] as? String
//                           {
//                            // まず目が覚めた人をリストに上げる
//                            if sendWUMessageType == SendWUMessageType.wakeUpSuccessMessage {
//                                let calendar = Calendar(identifier: .gregorian)
//                                print("宏輝_起きた時間: ", Date(timeIntervalSince1970: date))
//                                
//                                let date = Date(timeIntervalSince1970: date)
//                                
//                                // 今日の日付ならappend
//                                if calendar.isDateInToday(date) {
//                                    print("宏輝_起きたresult: ",displayName)
//                                    self.wakeUpSuccessPersonList.append(displayName)
//                                    print("宏輝_起きたリストresult: ", self.wakeUpSuccessPersonList)
//                                }
//                            }
//                        }
//                    }
//                }
//                self.resultLabel.text = self.wakeUpSuccessPersonList.joined(separator: "\n")
//            }
//        }
//    }
//    
//    
//    func configureUI() {
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        resultLabel.translatesAutoresizingMaskIntoConstraints = false
//        resultLabel.numberOfLines = 0
//        
//        titleLabel.text = "早起きができた人"
//        
//        view.addSubview(titleLabel)
//        view.addSubview(resultLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.heightAnchor.constraint(equalToConstant: 40),
//  
//            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
//            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
//        ])
//    }
//}
//
//
//
//class CustomFloatingPanelLayout: FloatingPanelLayout {
//
//    let position: FloatingPanelPosition = .bottom
//        let initialState: FloatingPanelState = .tip
//        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
//            return [
//                .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
//                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
//                .tip: FloatingPanelLayoutAnchor(absoluteInset: 90.0, edge: .bottom, referenceGuide: .safeArea),
//            ]
//        }
//}
//
