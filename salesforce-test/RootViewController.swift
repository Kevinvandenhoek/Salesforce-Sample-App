//
//  ViewController.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import UIKit
import EasyPeasy
import SMIClientCore
import SMIClientUI

class RootViewController: UIViewController {
    
    private let chatService = ChatService()
    private let setup: UISetup
    private let reference: Bool
    private let titleLabel: UILabel = UILabel(text: "RootViewController")
    private let button: UIButton = UIButton(text: "open chat")
    
    required init(coder: NSCoder) { fatalError() }
    
    /**
     Creates a personalized greeting for a recipient.
     - Parameter configuration: Determines the context of the chat vc
     - Parameter reference: Set to true to use a simple vc instead of chat vc
     */
    init(setup: UISetup, reference: Bool = false) {
        self.setup = setup
        self.reference = reference
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await setup() }
    }
}

@objc
private extension RootViewController {
    
    func didTapButton() {
        Task { await embedChatVC() }
    }
}

private extension RootViewController {
    
    func setup() async {
        view.backgroundColor = .systemGroupedBackground
        title = "RootViewController"
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        view.addSubviews(titleLabel, button)
        titleLabel.textAlignment = .center
        titleLabel.easy.layout(
            Center(),
            Left().to(view, .leftMargin),
            Right().to(view, .rightMargin)
        )
        button.easy.layout(
            Left().to(view, .leftMargin),
            Right().to(view, .rightMargin),
            Top().to(titleLabel)
        )
        
        await embedChatVC()
    }
    
    func embedChatVC() async {
        let vc = await makeVCToEmbed()
        switch setup {
        case .pushed:
            navigationController!.pushViewController(vc, animated: true)
        case .embeddedInPushedVc:
            embed(vc)
        case .presented, .presentedOnTopOfPushedVc:
            present(vc, animated: true)
        }
    }
    
    func makeVCToEmbed() async -> UIViewController {
        guard !reference else { return ReferenceViewController() }
        return try! await chatService.makeViewController()
    }
}
