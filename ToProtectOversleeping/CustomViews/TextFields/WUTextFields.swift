//
//  WUTextFields.swift
//  ToProtectOversleeping
//
//  Created by 近藤宏輝 on 2021/05/05.
//

import UIKit

class WUTextFields: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = PrimaryColor.primary.cgColor
        
        textColor = PrimaryColor.primary
        tintColor = PrimaryColor.primary.withAlphaComponent(0.3)
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = PrimaryColor.background
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
        attributedPlaceholder = NSAttributedString(
            string: "選択",
            attributes: [.foregroundColor : PrimaryColor.primary.withAlphaComponent(0.3)])
//        placeholder = "選択"
    }
    
}
