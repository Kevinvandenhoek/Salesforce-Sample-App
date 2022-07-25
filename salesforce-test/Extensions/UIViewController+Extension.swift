//
//  UIViewController+Extension.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func embed(_ childViewController: UIViewController, in containerView: UIView? = nil) {
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        let containerView = containerView ?? view!
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
}
