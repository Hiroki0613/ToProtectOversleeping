//
//  WakeUpCardHomeVC.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/08/21.
//

import UIKit

class WakeUpCardHomeVC: UIViewController {
    
    var outlineFrameView = UIView()
    
    var teamMateNameLabel = WUBodyLabel(fontSize: 24)
    
    var wakeUpTimeOutlineFrameView = UIView()
    var wakeUpTimeMainDeclarationLabel = WUBodyLabel(fontSize: 20)
    //TODO: (#1)起床時間の変更は、鉛筆マークボタンを起きる時間の右側に置くことで認識させる。
    var wakeUpTimeEditButton = WUButton(backgroundColor: .clear, sfSymbolString: "pencil", fontSize: 20)
    var wakeUpTimeWeekDayStackView = UIStackView(frame: .zero)
    var wakeUpTimeWeekDayDeclarationLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeWeekDayTimeLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeWeekEndStackView = UIStackView(frame: .zero)
    var wakeUpTimeWeekEndDeclarationLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeWeekEndTimeLabel = WUBodyLabel(fontSize: 20)
    
    
    //TODO: (#1) チームで使っていることを前提としたいので、チームに参加した時点で、このボタンは消してしまう。チーム脱退は編集画面で行えるようにする。脱退したい場合については、チャット画面に誘導ボタンを置いても良いかもしれない。正直な感想、基本的にチームから抜けることは、そうそう無いと思うので、ボタンは押しづらいところにおいておくほうが良いかも。
    var editTeamMateButton = WUButton(backgroundColor: .clear, title: "チームへ招待")
    
    //TODO: (#4)通知一覧のチャット画面へ画面遷移
    var notificationRecordButton = WUButton(backgroundColor: PrimaryColor.primary, title: "通知記録")
    //TODO: (#5)起きたことを通知するQRスキャンViewへ画面遷移。平日、休日は、この先で分岐させる。
    var notificationWhenWakeUpButton = WUButton(backgroundColor: PrimaryColor.primary, title: "起きたことを通知")
    
    var advertiseSpaceFrameView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)

//        view.backgroundColor = PrimaryColor.primary
        self.view.addBackground(name: "orange")
        configureUI()
        
        //TODO: (#1)チーム参加型になっているか、そうではないかでボタンを表示、非表示に分岐させる。
        editTeamMateButton.isHidden = false

    }
    
    func configureUI() {
        
        //外枠と広告枠
        outlineFrameView.translatesAutoresizingMaskIntoConstraints = false
        advertiseSpaceFrameView.translatesAutoresizingMaskIntoConstraints = false
        outlineFrameView.layer.cornerRadius = 16
        outlineFrameView.clipsToBounds = true
        
        view.addSubview(outlineFrameView)
        view.addSubview(advertiseSpaceFrameView)
        
        outlineFrameView.addBlurToView(alpha: 0.7)
        advertiseSpaceFrameView.addBlurToView(alpha: 0.5)
        
        let padding: CGFloat = 20
        let labelPadding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            advertiseSpaceFrameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            advertiseSpaceFrameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            advertiseSpaceFrameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            advertiseSpaceFrameView.heightAnchor.constraint(equalToConstant: 50),
            
            outlineFrameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            outlineFrameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            outlineFrameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            outlineFrameView.bottomAnchor.constraint(equalTo: advertiseSpaceFrameView.topAnchor, constant: -padding),
        ])
        
        // チーム名
        teamMateNameLabel.translatesAutoresizingMaskIntoConstraints = false

        outlineFrameView.addSubview(teamMateNameLabel)
        teamMateNameLabel.text = "チーム名"
        
        NSLayoutConstraint.activate([
            teamMateNameLabel.topAnchor.constraint(equalTo: outlineFrameView.topAnchor, constant: labelPadding),
            teamMateNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            teamMateNameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        //起床時間
        wakeUpTimeOutlineFrameView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeMainDeclarationLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeEditButton.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekDayStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekDayDeclarationLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekDayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekEndStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekEndDeclarationLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekEndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        outlineFrameView.addSubview(wakeUpTimeOutlineFrameView)
        
        outlineFrameView.addSubview(wakeUpTimeMainDeclarationLabel)
        outlineFrameView.addSubview(wakeUpTimeEditButton)
        
        wakeUpTimeWeekDayStackView.addArrangedSubview(wakeUpTimeWeekDayDeclarationLabel)
        wakeUpTimeWeekDayStackView.addArrangedSubview(wakeUpTimeWeekDayTimeLabel)
        outlineFrameView.addSubview(wakeUpTimeWeekDayStackView)
        
        wakeUpTimeWeekDayStackView.axis = .horizontal
        wakeUpTimeWeekDayStackView.alignment = .fill
        wakeUpTimeWeekDayStackView.distribution = .fillEqually
        
        wakeUpTimeWeekEndStackView.addArrangedSubview(wakeUpTimeWeekEndDeclarationLabel)
        wakeUpTimeWeekEndStackView.addArrangedSubview(wakeUpTimeWeekEndTimeLabel)
        outlineFrameView.addSubview(wakeUpTimeWeekEndStackView)
        
        wakeUpTimeWeekEndStackView.axis = .horizontal
        wakeUpTimeWeekEndStackView.alignment = .fill
        wakeUpTimeWeekEndStackView.distribution = .fillEqually
                
        wakeUpTimeOutlineFrameView.addBlurToView(alpha: 0.5, style: .regular)
        wakeUpTimeOutlineFrameView.layer.cornerRadius = 16
        wakeUpTimeOutlineFrameView.clipsToBounds = true
        
        //TODO: (#1) 起きる時間の右に鉛筆ボタンを用意して、時間を編集できるようにする。アラーム時間は平日、休日を同時に編集できるようにする。
        //TODO: (#8)起きる時間の編集画面へのつなぎこみ、#1、#2が完了した後に行う。
        

        
        wakeUpTimeMainDeclarationLabel.text = "起きる時間"
        wakeUpTimeMainDeclarationLabel.textAlignment = .center
        wakeUpTimeEditButton.tintColor = .label
        
        wakeUpTimeWeekDayDeclarationLabel.text = "平日"
        wakeUpTimeWeekDayDeclarationLabel.textAlignment = .center
        wakeUpTimeWeekDayTimeLabel.text = "7:00"
        wakeUpTimeWeekDayTimeLabel.textAlignment = .center
        
        //TODO: (#2)休日については、日本の祝日を含むようにする。
        wakeUpTimeWeekEndDeclarationLabel.text = "休日(祝日)"
        wakeUpTimeWeekEndDeclarationLabel.textAlignment = .center
        wakeUpTimeWeekEndTimeLabel.text = "8:00"
        wakeUpTimeWeekEndTimeLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            wakeUpTimeOutlineFrameView.topAnchor.constraint(equalTo: teamMateNameLabel.bottomAnchor, constant: labelPadding),
            wakeUpTimeOutlineFrameView.leadingAnchor.constraint(equalTo: outlineFrameView.leadingAnchor, constant: padding * 2),
            wakeUpTimeOutlineFrameView.trailingAnchor.constraint(equalTo: outlineFrameView.trailingAnchor, constant: -padding * 2),
            wakeUpTimeOutlineFrameView.heightAnchor.constraint(equalToConstant: view.frame.height / 6),
            
            wakeUpTimeMainDeclarationLabel.topAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.topAnchor, constant: labelPadding),
            wakeUpTimeMainDeclarationLabel.centerXAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.centerXAnchor),
            wakeUpTimeMainDeclarationLabel.heightAnchor.constraint(equalToConstant: 24),
            
            wakeUpTimeEditButton.topAnchor.constraint(equalTo: wakeUpTimeMainDeclarationLabel.topAnchor),
            wakeUpTimeEditButton.leadingAnchor.constraint(equalTo: wakeUpTimeMainDeclarationLabel.trailingAnchor, constant: padding),
            wakeUpTimeEditButton.heightAnchor.constraint(equalToConstant: 24),
            
            wakeUpTimeWeekDayStackView.topAnchor.constraint(equalTo: wakeUpTimeMainDeclarationLabel.bottomAnchor, constant: labelPadding),
            wakeUpTimeWeekDayStackView.leadingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.leadingAnchor, constant: padding),
            wakeUpTimeWeekDayStackView.trailingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.trailingAnchor, constant: -padding),
            wakeUpTimeWeekDayStackView.heightAnchor.constraint(equalToConstant: 20),
            
//            wakeUpTimeWeekDayStackView.topAnchor.constraint(equalTo: wakeUpTimeMainDeclarationLabel.bottomAnchor, constant: labelPadding),
//            wakeUpTimeWeekDayStackView.leadingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.leadingAnchor, constant: padding),
//            wakeUpTimeWeekDayStackView.trailingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.trailingAnchor, constant: -padding),
//            wakeUpTimeWeekDayStackView.heightAnchor.constraint(equalToConstant: 20),
            
            wakeUpTimeWeekEndStackView.topAnchor.constraint(equalTo: wakeUpTimeWeekDayStackView.bottomAnchor, constant: labelPadding),
            wakeUpTimeWeekEndStackView.leadingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.leadingAnchor, constant: padding),
            wakeUpTimeWeekEndStackView.trailingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.trailingAnchor, constant: -padding),
            wakeUpTimeWeekEndStackView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        //チーム招待ボタン
        editTeamMateButton.translatesAutoresizingMaskIntoConstraints = false
        
        editTeamMateButton.layer.borderWidth = 1
        editTeamMateButton.layer.borderColor = PrimaryColor.background.cgColor
        editTeamMateButton.addBlurToButton(alpha: 0.5, cornerRadius: 10, view: editTeamMateButton)
        
        outlineFrameView.addSubview(editTeamMateButton)
    
        
        NSLayoutConstraint.activate([
            editTeamMateButton.topAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.bottomAnchor, constant: padding),
            editTeamMateButton.leadingAnchor.constraint(equalTo: outlineFrameView.leadingAnchor, constant: padding),
            editTeamMateButton.trailingAnchor.constraint(equalTo: outlineFrameView.trailingAnchor, constant: -padding),
            editTeamMateButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // 通知記録、起きたことを通知
        notificationRecordButton.translatesAutoresizingMaskIntoConstraints = false
        notificationWhenWakeUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        notificationRecordButton.layer.borderWidth = 1
        notificationRecordButton.layer.borderColor = PrimaryColor.background.cgColor
        notificationWhenWakeUpButton.layer.borderWidth = 1
        notificationWhenWakeUpButton.layer.borderColor = PrimaryColor.background.cgColor
        
        outlineFrameView.addSubview(notificationRecordButton)
        outlineFrameView.addSubview(notificationWhenWakeUpButton)
        
        NSLayoutConstraint.activate([
            notificationWhenWakeUpButton.bottomAnchor.constraint(equalTo: outlineFrameView.bottomAnchor, constant: -padding),
            notificationWhenWakeUpButton.leadingAnchor.constraint(equalTo: outlineFrameView.leadingAnchor, constant: padding),
            notificationWhenWakeUpButton.trailingAnchor.constraint(equalTo: outlineFrameView.trailingAnchor, constant: -padding),
            notificationWhenWakeUpButton.heightAnchor.constraint(equalToConstant: 60),
            
            notificationRecordButton.bottomAnchor.constraint(equalTo: notificationWhenWakeUpButton.topAnchor, constant: -padding),
            notificationRecordButton.leadingAnchor.constraint(equalTo: outlineFrameView.leadingAnchor, constant: padding),
            notificationRecordButton.trailingAnchor.constraint(equalTo: outlineFrameView.trailingAnchor, constant: -padding),
            notificationRecordButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
