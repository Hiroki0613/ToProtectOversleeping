//
//  GoalSettingWakeUpCardTableListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/12.
//

import UIKit

class GoalSettingWakeUpCardTableListCell: UITableViewCell {
    static let reuseID = "GoalSettingWakeUpCardTableListCell"
    
    // セルの空白を開ける透明ビュー
    var transParentView = UIView()
    
    // tableViewのcell
    var tableCellView = UIView()
    
    // 達成したい目標
    var goalSettingSubLabel = WUBodyLabel(fontSize: 20)
    
    // 空白の中心に置かれるLabel
    var goalSettingMainLabel = WUBodyLabel(fontSize: 24)
    
    // 左へスワイプ可能を表示するLabel
    var swipeOkLeftLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        transParentView.translatesAutoresizingMaskIntoConstraints = false
        tableCellView.translatesAutoresizingMaskIntoConstraints = false
        tableCellView.layer.cornerRadius = 16
//        tableCellView.addBlurToView(alpha: 0.9)
        goalSettingSubLabel.translatesAutoresizingMaskIntoConstraints = false
        goalSettingMainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        swipeOkLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20.0
        
        // セルの空白を開ける透明ビューを用意
        contentView.addSubview(transParentView)
        transParentView.backgroundColor = PrimaryColor.primary
        
        // 透明セルの上にtableViewのCellを追加
        transParentView.addSubview(tableCellView)
        tableCellView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        tableCellView.addSubview(goalSettingSubLabel)
        goalSettingSubLabel.text = "達成したい目標！"
        goalSettingSubLabel.textAlignment = .center
        tableCellView.addSubview(goalSettingMainLabel)
        goalSettingMainLabel.text = ""
        goalSettingMainLabel.textAlignment = .center
        goalSettingMainLabel.numberOfLines = 0
        goalSettingMainLabel.lineBreakMode = .byCharWrapping
        goalSettingSubLabel.sizeToFit()
        
        let leftSwipeText = NSMutableAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "arrow.left")!))
        swipeOkLeftLabel.attributedText = leftSwipeText
//        swipeOkLeftLabel.numberOfLines = 2
        swipeOkLeftLabel.numberOfLines = 1
        swipeOkLeftLabel.sizeToFit()
        tableCellView.addSubview(swipeOkLeftLabel)
        
        NSLayoutConstraint.activate([
            // 透明セル
            transParentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            transParentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            transParentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            transParentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // tableViewのcell
            tableCellView.topAnchor.constraint(equalTo: transParentView.topAnchor, constant: padding),
            tableCellView.leadingAnchor.constraint(equalTo: transParentView.leadingAnchor, constant: padding),
            tableCellView.trailingAnchor.constraint(equalTo: transParentView.trailingAnchor, constant: -padding),
            tableCellView.bottomAnchor.constraint(equalTo: transParentView.bottomAnchor, constant: -padding),
            
            // 左スワイプ
            swipeOkLeftLabel.topAnchor.constraint(equalTo: tableCellView.centerYAnchor),
            swipeOkLeftLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor),
            
            // 達成したい目標！を表示するLabel
            goalSettingSubLabel.topAnchor.constraint(equalTo: tableCellView.topAnchor, constant: 10),
            goalSettingSubLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            goalSettingSubLabel.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            goalSettingSubLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // 個人で書いた目標を表示するLabel
            goalSettingMainLabel.topAnchor.constraint(equalTo: tableCellView.centerYAnchor, constant: -80),
            goalSettingMainLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            goalSettingMainLabel.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding),
            goalSettingMainLabel.bottomAnchor.constraint(equalTo: tableCellView.bottomAnchor, constant: -padding)
        ])
    }
}
