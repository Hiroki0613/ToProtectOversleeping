//
//  BlankWakeUpCardTableListCell.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/07/06.
//

import UIKit

class BlankWakeUpCardTableListCell: UITableViewCell {
    static let reuseID = "BlankWakeUpCardTableListCell"
    
    // セルの空白を開ける透明ビュー
    var transparentView = UIView()
    
    // tableViewのcell
    var tableCellView = UIView()
    
    // 空白の中心に置かれるLabel
    var blankCellLabel = WUBodyLabel(fontSize: 40)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        tableCellView.translatesAutoresizingMaskIntoConstraints = false
        blankCellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20.0
        let spacePadding: CGFloat = 10.0
        
        // セルの空白を開ける透明ビューを用意
        contentView.addSubview(transparentView)
        transparentView.backgroundColor = .systemOrange
        
        // 透明セルの上にtableViewのcellを追加
        transparentView.addSubview(tableCellView)
        tableCellView.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        
        tableCellView.addSubview(blankCellLabel)
        blankCellLabel.text = "プレースホルダー"
        
        NSLayoutConstraint.activate([
            // 透明セル
            transparentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // tableViewのcell
            tableCellView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: padding),
            tableCellView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: padding),
            tableCellView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -padding),
            tableCellView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -padding),
            
            // 空白時のcellに表示させるLabel
            blankCellLabel.topAnchor.constraint(equalTo: tableCellView.centerYAnchor),
            blankCellLabel.leadingAnchor.constraint(equalTo: tableCellView.centerXAnchor)
        ])
    }
    
    
    
}
