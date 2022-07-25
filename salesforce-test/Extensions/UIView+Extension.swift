//
//  UIView+Extension.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
