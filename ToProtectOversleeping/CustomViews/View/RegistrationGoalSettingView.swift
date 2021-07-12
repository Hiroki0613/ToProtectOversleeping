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
    var wordCountLabel = WUBodyLabel(fontSize: 10)
    // 最大文字数を表示するためのLabel
    var goalSettingCountingLabel = WUBodyLabel(fontSize: 10)
    // テキスト入力用のTextView
    var goalSettingTextView = UITextView()
    // 目標を記入してOKを出すボタン
    var registerGoalSettingButton = WUButton(backgroundColor: PrimaryColor.primary, title: "登録")
    // 目標を書かずにスキップするボタン
    var skipButton = WUButton(backgroundColor: PrimaryColor.primary, title: "スキップ")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingInformation()
        configureUI()
        configureKeyBoardPlace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingInformation() {
        goalSettingAssistLabel.text = "早起きして達成したい目標を記載してください"
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
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        goalSettingCountingLabel.translatesAutoresizingMaskIntoConstraints = false
        goalSettingTextView.translatesAutoresizingMaskIntoConstraints = false
        registerGoalSettingButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
