//
//  UILabel.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, size: CGFloat = 36) {
        self.init()
        font = .systemFont(ofSize: size)
        self.text = text
        textColor = UIColor(named: "text")
        backgroundColor = .systemGray6
    }
}
