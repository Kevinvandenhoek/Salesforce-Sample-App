//
//  UIButton+Extension.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(text: String) {
        self.init()
        setTitle(text, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        setTitleColor(UIColor(named: "text"), for: .normal)
        backgroundColor = .systemGray6
    }
}
