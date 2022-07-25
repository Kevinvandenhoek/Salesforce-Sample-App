//
//  ReferenceViewController.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import Foundation
import UIKit
import EasyPeasy

final class ReferenceViewController: UIViewController {
    
    private let topLabel = UILabel(text: "hello world")
    private lazy var bottomButton = UIButton(text: "open next page")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ReferenceViewController"
        view.backgroundColor = .systemBackground
        
        bottomButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        view.addSubviews(topLabel, bottomButton)
        topLabel.easy.layout(
            Left().to(view, .leftMargin),
            Top().to(view, .topMargin),
            Right().to(view, .rightMargin)
        )
        bottomButton.easy.layout(
            Left().to(view, .leftMargin),
            Bottom().to(view, .bottomMargin),
            Right().to(view, .rightMargin)
        )
    }
}

@objc
private extension ReferenceViewController {
    
    func didTapButton() {
        let detail = ReferenceViewController()
        detail.view.backgroundColor = [UIColor.systemRed, .systemBlue, .systemCyan, .systemMint].randomElement()!
        if let navigationController = navigationController {
            navigationController.pushViewController(detail, animated: true)
        } else {
            present(detail, animated: true)
        }
    }
}
