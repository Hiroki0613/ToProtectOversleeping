//
//  RegistrationGoalSettingView.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/13.
//

import UIKit

/*
 参考URL
 【Swift】UITextViewに文字数制限と行数制限を加える方法
 https://orangelog.site/swift/uitextview-limits/
 UITextViewをコードで作成し、編集終了ボタンの追加とキーボード被り対策
 https://qiita.com/Secret-Base36/items/3cd00dbb28439cb949e0
 swift textViewの文字を入力するごとに保存,セーブなど(予測変換にも対応)
 https://rils-k.hatenablog.com/entry/2020/09/08/230540
 */

class RegistrationGoalSettingView: UIView {
    
    // キーボード出現によるスクロール量
    var scrollByKeyboard: CGFloat = 0
    // 早起きして達成したい目標を記入
    var goalSettingAssistLabel = WUBodyLabel(fontSize: 20)
    // 残り文字数を表示するためのLabel
    var wordCountLabel = WUBodyLabel(fontSize: 17)
    // 最大文字数を表示するためのLabel
    var goalSettingCountingLabel = WUBodyLabel(fontSize: 17)
    // テキスト入力用のTextView
    var goalSettingTextView = UITextView()
    // 一時的に保存しておくString
    var goalSettingLabel = UILabel()
//    var goalSettingLabelText = ""
    //最大文字数
    var maxWordCount: Int = 70
    //プレイスホルダー
    let placeholder: String = "達成したい目標を入力・・・"
    // 目標を記入してOKを出すボタン
    var registerGoalSettingButton = WUButton(backgroundColor: PrimaryColor.primary, title: "登録")
    // 目標を書かずにスキップするボタン
    var skipButton = WUButton(backgroundColor: PrimaryColor.primary, title: "スキップ")
    var buttonStackView = UIStackView(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configureUI()
        configureKeyBoardPlace()
        configureToolBarKeybord()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingInformation() {
        goalSettingAssistLabel.numberOfLines = 0
        goalSettingAssistLabel.textAlignment = .center
        goalSettingAssistLabel.text = "早起きして達成したい\n目標を記載してください\n (70文字かつ6行まで)"
        goalSettingCountingLabel.text = "/70"
        wordCountLabel.text = "70"
        goalSettingTextView.font = UIFont.systemFont(ofSize: 22)
        
        goalSettingTextView.delegate = self
        //タップでキーボードを下げる
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
        //下にスワイプでキーボードを下げる
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDownGesture.direction = .down
        self.addGestureRecognizer(swipeDownGesture)
        
    }
    
    private func configureToolBarKeybord() {
        //キーボードに編集終了ボタンを乗せるツールバーを作成
        let kbToolbar = UIToolbar()
        kbToolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        //ボタンを右寄せにするためのスペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        //編集終了ボタン
        let kbDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(kbDoneTaped))
        //スペーサーとボタンをツールバーに追加
        kbToolbar.items = [spacer,kbDoneButton]
        //textViewのキーボードのinputAccessoryViewに作成したツールバーを設定
        goalSettingTextView.inputAccessoryView = kbToolbar
        //textViewのキーボードのinputAccessoryViewに作成したツールバーを設定
        goalSettingTextView.inputAccessoryView = kbToolbar
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    //keyboardのDoneが押された時に実行されるメソッド
    @objc func kbDoneTaped(sender:UIButton){
        //キーボードを閉じる
        self.endEditing(true)
    }
    
    private func configureKeyBoardPlace() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: Notification?) {
        print("キーボードが表示された")
        // キーボードの大きさを取得
        let keyboardFrame: CGRect = (notification?.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // キーボードのすぐ上にテキストビューが来るように調整する
        self.scrollByKeyboard = keyboardFrame.size.height - (self.frame.height - self.goalSettingTextView.frame.maxY)
        // 画面をスクロールさせる
        let affine = CGAffineTransform.init(translationX: 0.0, y: -self.scrollByKeyboard)
        // 画面のスクロールをアニメーションさせる
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.transform = affine
                       },
                       completion: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification?) {
        print("キーボードが消された")
        // 画面のスクロールを元に戻す
        let affine = CGAffineTransform.init(translationX: 0.0, y: 0.0)
        // 画面のスクロールをアニメーションさせる
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.transform = affine
                       },
                       completion: { (true) in
                        self.scrollByKeyboard = 0.0
                       })
    }
    
    private func configureUI() {
        goalSettingAssistLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(goalSettingAssistLabel)
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wordCountLabel)
        goalSettingCountingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(goalSettingCountingLabel)
        goalSettingTextView.translatesAutoresizingMaskIntoConstraints = false
        goalSettingTextView.layer.cornerRadius = 16
        goalSettingTextView.returnKeyType = .done
        addSubview(goalSettingTextView)
        registerGoalSettingButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(registerGoalSettingButton)
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 30
        addSubview(buttonStackView)
        backgroundColor = PrimaryColor.background
        
        let padding: CGFloat = 20.0
        
        NSLayoutConstraint.activate([
            goalSettingAssistLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            goalSettingAssistLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            goalSettingAssistLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            goalSettingAssistLabel.heightAnchor.constraint(equalToConstant: 80),
            
            wordCountLabel.topAnchor.constraint(equalTo: goalSettingAssistLabel.bottomAnchor, constant: 5),
            wordCountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            wordCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            goalSettingCountingLabel.topAnchor.constraint(equalTo: goalSettingAssistLabel.bottomAnchor, constant: 5),
            goalSettingCountingLabel.leadingAnchor.constraint(equalTo: wordCountLabel.trailingAnchor, constant: 10),
            goalSettingCountingLabel.heightAnchor.constraint(equalToConstant: 20),
            
            goalSettingTextView.topAnchor.constraint(equalTo: goalSettingCountingLabel.bottomAnchor, constant: padding),
            goalSettingTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            goalSettingTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            goalSettingTextView.heightAnchor.constraint(equalToConstant: 200),
            
            buttonStackView.topAnchor.constraint(equalTo: goalSettingTextView.bottomAnchor, constant: padding),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}

extension RegistrationGoalSettingView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 改行禁止を実装
        if text == "\n" {
            //キーボードを閉じる
            textView.resignFirstResponder()
            return false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let text = self.goalSettingTextView.text!
                   UserDefaults.standard.set(text, forKey: "theGoalSettingText")
                }
                
        //        let existingLines = goalSettingTextView.text.components(separatedBy: .newlines)//既に存在する改行数
        //        let newLines = text.components(separatedBy: .newlines)//新規改行数
        //        let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
        //        return linesAfterChange <= 3 && goalSettingTextView.text.count + (text.count - range.length) <= maxWordCount
        return goalSettingTextView.text.count + (text.count - range.length) <= maxWordCount
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let existingLines = goalSettingTextView.text.components(separatedBy: .newlines)//既に存在する改行数
        if existingLines.count <= 6 {
            self.wordCountLabel.text = "\(maxWordCount - goalSettingTextView.text.count)"
        }
        
        if goalSettingTextView.text.count > 60 {
            wordCountLabel.textColor = .red
           } else {
            wordCountLabel.textColor = .black
           }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .darkText
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //textViewからテキストの取り出し
        guard let text = textView.text else { return }
        goalSettingLabel.text = ""
        goalSettingLabel.text = text
        print("宏輝_textView.text: ", goalSettingLabel.text!)
//        guard let goalSettingLabelTextUnWrap = goalSettingLabel.text else { return }
//        goalSettingLabelText = goalSettingLabelTextUnWrap
//        print("宏輝_textView.text2: ", goalSettingLabelText)
        
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = placeholder
        }
    }
}
