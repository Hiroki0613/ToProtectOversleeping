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
    
    // 空白の中心に置かれるLabel
    var goalSettingCellLabel = WUBodyLabel(fontSize: 20)
    
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
        tableCellView.addBlurToView(alpha: 0.9)
        goalSettingCellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20.0
        
        // セルの空白を開ける透明ビューを用意
        contentView.addSubview(transParentView)
        transParentView.backgroundColor = PrimaryColor.primary
        
        // 透明セルの上にtableViewのCellを追加
        transParentView.addSubview(tableCellView)
        tableCellView.addSubview(goalSettingCellLabel)
        goalSettingCellLabel.text = ""
        goalSettingCellLabel.textAlignment = .center
        goalSettingCellLabel.numberOfLines = 0
        goalSettingCellLabel.lineBreakMode = .byCharWrapping
        
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
            
            // 空白時のcellに表示させるLabel
            goalSettingCellLabel.topAnchor.constraint(equalTo: tableCellView.centerYAnchor, constant: -padding),
            goalSettingCellLabel.leadingAnchor.constraint(equalTo: tableCellView.leadingAnchor, constant: padding),
            goalSettingCellLabel.trailingAnchor.constraint(equalTo: tableCellView.trailingAnchor, constant: -padding)
        ])
    }
}
