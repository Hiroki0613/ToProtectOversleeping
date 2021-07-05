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
}
