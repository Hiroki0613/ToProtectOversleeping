//
//  ResultWakeUpVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/06/16.
//

import UIKit

class ResultWakeUpVC: UIViewController {
    
    var wakeUpSuccessPersonList = [String]()
//    var wakeUpSuccessPersonList777 = ["うにうに","うにょうにょ","うろうろ"]
    
    var titleLabel = WUBodyLabel(fontSize: 20)
    var resultLabel = WUBodyLabel(fontSize: 30)
    var resultStackView = UIStackView(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        configureUI()
    }
    
    func configureUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        resultStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "早起きができた人"
        
        resultLabel.text = wakeUpSuccessPersonList.joined(separator: "")


//        for wakeUpSuccessPerson in wakeUpSuccessPersonList777 {
//            resultLabel.text = wakeUpSuccessPerson + "\n"
//        }
        
        
        view.addSubview(titleLabel)
        view.addSubview(resultLabel)
        
//        for i in 0...(wakeUpSuccessPersonList.count - 1) {
//            let resultLabelArray = [WUBodyLabel(fontSize: 16)]
//            resultLabelArray[i].text = wakeUpSuccessPersonList[i]
//            resultStackView.addArrangedSubview(resultLabelArray[i])
//        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
  
            resultLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            
//            resultStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
//            resultStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            resultStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            
        ])
    }

    

}
