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
    var wakeUpTimeWeekDayStackView = UIStackView(frame: .zero)
    var wakeUpTimeWeekDayDeclarationLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeWeekDayTimeLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeWeekEndStackView = UIStackView(frame: .zero)
    var wakeUpTimeWeekEndDeclarationLabel = WUBodyLabel(fontSize: 20)
    var wakeUpTimeWeekEndTimeLabel = WUBodyLabel(fontSize: 20)
    
    var editMainDeclarationLabel = WUBodyLabel(fontSize: 24)
    var editButtonStackView = UIStackView(frame: .zero)
    var editTeamMateButton = WUButton(backgroundColor: PrimaryColor.primary, title: "チーム")
    var editWakeUpTimeButton = WUButton(backgroundColor: PrimaryColor.primary, title: "起床時間")
    
    var notificationRecordButton = WUButton(backgroundColor: PrimaryColor.primary, title: "通知記録")
    var notificationWhenWakeUpButton = WUButton(backgroundColor: PrimaryColor.primary, title: "起きたことを通知")
    
    var advertiseSpaceFrameView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)

        view.backgroundColor = PrimaryColor.primary
        configureUI()

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
        wakeUpTimeWeekDayStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekDayDeclarationLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekDayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekEndStackView.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekEndDeclarationLabel.translatesAutoresizingMaskIntoConstraints = false
        wakeUpTimeWeekEndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        outlineFrameView.addSubview(wakeUpTimeOutlineFrameView)
        
        outlineFrameView.addSubview(wakeUpTimeMainDeclarationLabel)
        
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
                
        wakeUpTimeOutlineFrameView.addBlurToView(alpha: 0.5)
        wakeUpTimeOutlineFrameView.layer.cornerRadius = 16
        wakeUpTimeOutlineFrameView.clipsToBounds = true
        wakeUpTimeMainDeclarationLabel.text = "起きる時間"
        wakeUpTimeWeekDayDeclarationLabel.text = "平日"
        wakeUpTimeWeekDayTimeLabel.text = "7:00"
        wakeUpTimeWeekEndDeclarationLabel.text = "休日"
        wakeUpTimeWeekEndTimeLabel.text = "8:00"
        
        NSLayoutConstraint.activate([
            wakeUpTimeOutlineFrameView.topAnchor.constraint(equalTo: teamMateNameLabel.bottomAnchor, constant: labelPadding),
            wakeUpTimeOutlineFrameView.leadingAnchor.constraint(equalTo: outlineFrameView.leadingAnchor, constant: padding * 2),
            wakeUpTimeOutlineFrameView.trailingAnchor.constraint(equalTo: outlineFrameView.trailingAnchor, constant: -padding * 2),
            wakeUpTimeOutlineFrameView.heightAnchor.constraint(equalToConstant: view.frame.height / 6),
            
            wakeUpTimeMainDeclarationLabel.topAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.topAnchor, constant: labelPadding),
            wakeUpTimeMainDeclarationLabel.centerXAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.centerXAnchor),
            wakeUpTimeMainDeclarationLabel.heightAnchor.constraint(equalToConstant: 24),
            
            wakeUpTimeWeekDayStackView.topAnchor.constraint(equalTo: wakeUpTimeMainDeclarationLabel.bottomAnchor, constant: labelPadding),
            wakeUpTimeWeekDayStackView.leadingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.leadingAnchor, constant: padding),
            wakeUpTimeWeekDayStackView.trailingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.trailingAnchor, constant: -padding),
            wakeUpTimeWeekDayStackView.heightAnchor.constraint(equalToConstant: 20),
            
            wakeUpTimeWeekEndStackView.topAnchor.constraint(equalTo: wakeUpTimeWeekDayStackView.bottomAnchor, constant: padding),
            wakeUpTimeWeekEndStackView.leadingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.leadingAnchor, constant: padding),
            wakeUpTimeWeekEndStackView.trailingAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.trailingAnchor, constant: -padding),
            wakeUpTimeWeekEndStackView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        //編集ボタン
        editMainDeclarationLabel.translatesAutoresizingMaskIntoConstraints = false
        editButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        editTeamMateButton.translatesAutoresizingMaskIntoConstraints = false
        editWakeUpTimeButton.translatesAutoresizingMaskIntoConstraints = false
        
        editMainDeclarationLabel.text = "編集"
        editTeamMateButton.layer.borderWidth = 1
        editTeamMateButton.layer.borderColor = PrimaryColor.background.cgColor
        editWakeUpTimeButton.layer.borderWidth = 1
        editWakeUpTimeButton.layer.borderColor = PrimaryColor.background.cgColor
        
        
        outlineFrameView.addSubview(editMainDeclarationLabel)
        editButtonStackView.addArrangedSubview(editTeamMateButton)
        editButtonStackView.addArrangedSubview(editWakeUpTimeButton)
        outlineFrameView.addSubview(editButtonStackView)
        
        editButtonStackView.axis = .horizontal
        editButtonStackView.alignment = .fill
        editButtonStackView.distribution = .fillEqually
        editButtonStackView.spacing = 30
        
        NSLayoutConstraint.activate([
            editMainDeclarationLabel.topAnchor.constraint(equalTo: wakeUpTimeOutlineFrameView.bottomAnchor, constant: labelPadding),
            editMainDeclarationLabel.centerXAnchor.constraint(equalTo: outlineFrameView.centerXAnchor),
            editMainDeclarationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            editButtonStackView.topAnchor.constraint(equalTo: editMainDeclarationLabel.bottomAnchor, constant: labelPadding),
            editButtonStackView.leadingAnchor.constraint(equalTo: outlineFrameView.leadingAnchor, constant: padding),
            editButtonStackView.trailingAnchor.constraint(equalTo: outlineFrameView.trailingAnchor, constant: -padding),
            editButtonStackView.heightAnchor.constraint(equalToConstant: 60)
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
