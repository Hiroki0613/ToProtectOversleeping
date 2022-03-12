//
//  EditWakeUpAlarmTimeViewByWeekDayWeekEnd.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2022/01/03.
//

import UIKit

class EditWakeUpAlarmTimeViewByWeekDayWeekEnd: UIView {
    // アラーム時間を一時的に格納する
    //平日
    var changeWakeUpTimeWeekDayText = ""
    var changeWakeUpTimeWeekDayDate = Date()
    //休日
    var changeWakeUpTimeWeekEndText = ""
    var changeWakeUpTimeWeekEndDate = Date()
    
    // チャットのdocumentID
    var chatRoomDocumentID = ""
    var userName = ""
    
    var changeWakeUpTimeLabel = WUBodyLabel(fontSize: 24)
    //平日の起きる時間
    let changeDatePickerWeekDay: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .wheels
        dp.timeZone = NSTimeZone.local
        dp.locale = Locale.current
        dp.addTarget(self, action: #selector(dateChangeWeekDay), for: .valueChanged)
        return dp
    }()
    //休日の起きる時間
    let changeDatePickerWeekEnd: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .wheels
        dp.timeZone = NSTimeZone.local
        dp.locale = Locale.current
        dp.addTarget(self, action: #selector(dateChangeWeekEnd), for: .valueChanged)
        return dp
    }()
    
    //平日
    var changeWakeUpTimeWeekDayLabel = WUBodyLabel(fontSize: 20)
    var changeWakeUpTimeWeekDayTextField = WUTextFields()
    //休日
    var changeWakeUpTimeWeekEndLabel = WUBodyLabel(fontSize: 20)
    var changeWakeUpTimeWeekEndTextField = WUTextFields()
    
    // 戻るボタン
    let changeWakeUpGoBuckButton = WUButton(backgroundColor: .clear, title: "戻る")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
  
    
    // 目覚まし、チャット名、GPS、市区町村のプレースホルダーをここでセットしておく
    private func settingInformation() {
        changeWakeUpTimeLabel.text = "起きる時間の変更"
        
        changeWakeUpTimeWeekDayLabel.text = "平日"
        changeWakeUpTimeWeekDayTextField.inputView = changeDatePickerWeekDay
        print("datePickerWeekDay: ", changeDatePickerWeekDay)
        changeWakeUpTimeWeekDayTextField.delegate = self
        
        changeWakeUpTimeWeekEndLabel.text = "休日"
        changeWakeUpTimeWeekEndTextField.inputView = changeDatePickerWeekEnd
        print("datePickerWeekEnd: ", changeDatePickerWeekEnd)
        changeWakeUpTimeWeekEndTextField.delegate = self
        
    }
    
    @objc func dateChangeWeekDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        changeWakeUpTimeWeekDayTextField.text = "\(formatter.string(from: changeDatePickerWeekDay.date))"
        changeWakeUpTimeWeekDayText = "\(formatter.string(from: changeDatePickerWeekDay.date))"
        changeWakeUpTimeWeekDayDate = changeDatePickerWeekDay.date
        print("wakeUpTimeText: ", changeWakeUpTimeWeekDayText)
        changeWakeUpTimeLabel.text = "時間が変更されました"
        print("宏輝_アラーム: edit change changeWakeUpTimeText:  ", changeWakeUpTimeWeekDayText)
        print("宏輝_アラーム: edit change changeWakeUpTimeDate:  ", changeWakeUpTimeWeekDayDate)
    }
    
    @objc func dateChangeWeekEnd() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        changeWakeUpTimeWeekEndTextField.text = "\(formatter.string(from: changeDatePickerWeekEnd.date))"
        changeWakeUpTimeWeekEndText = "\(formatter.string(from: changeDatePickerWeekEnd.date))"
        changeWakeUpTimeWeekEndDate = changeDatePickerWeekEnd.date
        print("wakeUpTimeText: ", changeWakeUpTimeWeekEndText)
        changeWakeUpTimeLabel.text = "時間が変更されました"
        print("宏輝_アラーム: edit change changeWakeUpTimeText:  ", changeWakeUpTimeWeekEndText)
        print("宏輝_アラーム: edit change changeWakeUpTimeDate:  ", changeWakeUpTimeWeekEndDate)
    }
    
    // UIDatePickerのDoneを押したら発火
    @objc func doneWeekDay() {
        changeWakeUpTimeWeekDayTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        changeWakeUpTimeWeekDayTextField.text = "\(formatter.string(from: changeDatePickerWeekDay.date))"
        changeWakeUpTimeWeekDayText = "\(formatter.string(from: changeDatePickerWeekDay.date))"
        changeWakeUpTimeWeekDayDate = changeDatePickerWeekDay.date
        print("宏輝_アラーム: edit done wakeUpTimeWeekDayText: ", changeWakeUpTimeWeekDayText)
        print("宏輝_アラーム: edit done wakeUpTimeWeekDayDate: ", changeWakeUpTimeWeekDayDate)
        changeWakeUpTimeLabel.text = "時間が変更されました"
    }
    
    @objc func doneWeekEnd() {
        changeWakeUpTimeWeekEndTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        changeWakeUpTimeWeekEndTextField.text = "\(formatter.string(from: changeDatePickerWeekEnd.date))"
        changeWakeUpTimeWeekEndText = "\(formatter.string(from: changeDatePickerWeekEnd.date))"
        changeWakeUpTimeWeekEndDate = changeDatePickerWeekEnd.date
        print("宏輝_アラーム: edit done wakeUpTimeWeekEndText: ", changeWakeUpTimeWeekEndText)
        print("宏輝_アラーム: edit done wakeUpTimeWeekEndDate: ", changeWakeUpTimeWeekEndDate)
        changeWakeUpTimeLabel.text = "時間が変更されました"
    }
    
    
    private func configure() {
        // 決定バーの生成
        //平日
        let toolbarWeekDay = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItemWeekDay = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItemWeekDay = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneWeekDay))
        toolbarWeekDay.setItems([spacelItemWeekDay, doneItemWeekDay], animated: true)
        
        //休日
        let toolbarWeekEnd = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItemWeekEnd = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItemWeekEnd = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneWeekEnd))
        toolbarWeekEnd.setItems([spacelItemWeekEnd, doneItemWeekEnd], animated: true)
        
        changeWakeUpTimeWeekDayTextField.inputAccessoryView = toolbarWeekDay
        changeWakeUpTimeWeekEndTextField.inputAccessoryView = toolbarWeekEnd
        
        changeWakeUpTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        changeWakeUpTimeWeekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        changeWakeUpTimeWeekDayTextField.translatesAutoresizingMaskIntoConstraints = false
        changeWakeUpTimeWeekEndLabel.translatesAutoresizingMaskIntoConstraints = false
        changeWakeUpTimeWeekEndTextField.translatesAutoresizingMaskIntoConstraints = false
        changeWakeUpGoBuckButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = PrimaryColor.background
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 30.0
        let labelButtonHightPadding: CGFloat = 60
        
        // 起きる時間をStack
        addSubview(changeWakeUpTimeLabel)
        addSubview(changeWakeUpTimeWeekDayLabel)
        addSubview(changeWakeUpTimeWeekDayTextField)
        addSubview(changeWakeUpTimeWeekEndLabel)
        addSubview(changeWakeUpTimeWeekEndTextField)
        addSubview(changeWakeUpGoBuckButton)
        
        NSLayoutConstraint.activate([
            //起きる時間
            changeWakeUpTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            changeWakeUpTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeLabel.heightAnchor.constraint(equalToConstant: padding),
            
            changeWakeUpTimeWeekDayLabel.topAnchor.constraint(equalTo: changeWakeUpTimeLabel.bottomAnchor, constant: spacePadding),
            changeWakeUpTimeWeekDayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeWeekDayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeWeekDayLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            changeWakeUpTimeWeekDayTextField.topAnchor.constraint(equalTo: changeWakeUpTimeWeekDayLabel.bottomAnchor, constant: 0),
            changeWakeUpTimeWeekDayTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeWeekDayTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeWeekDayTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            changeWakeUpTimeWeekEndLabel.topAnchor.constraint(equalTo: changeWakeUpTimeWeekDayTextField.bottomAnchor, constant: spacePadding),
            changeWakeUpTimeWeekEndLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeWeekEndLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeWeekEndLabel.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            changeWakeUpTimeWeekEndTextField.topAnchor.constraint(equalTo: changeWakeUpTimeWeekEndLabel.bottomAnchor, constant: 0),
            changeWakeUpTimeWeekEndTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpTimeWeekEndTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpTimeWeekEndTextField.heightAnchor.constraint(equalToConstant: labelButtonHightPadding),
            
            // 戻るボタン
            changeWakeUpGoBuckButton.topAnchor.constraint(equalTo: changeWakeUpTimeWeekEndTextField.bottomAnchor, constant: spacePadding),
            changeWakeUpGoBuckButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            changeWakeUpGoBuckButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            changeWakeUpGoBuckButton.heightAnchor.constraint(equalToConstant: labelButtonHightPadding)
        ])
    }
}

extension EditWakeUpAlarmTimeViewByWeekDayWeekEnd: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeWakeUpTimeWeekDayTextField.resignFirstResponder()
        changeWakeUpTimeWeekEndTextField.resignFirstResponder()
    }
    
}
