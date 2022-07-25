//
//  AppDelegate.swift
//  salesforce-test
//
//  Created by Kevin van den Hoek on 20/07/2022.
//

import UIKit

@main
class AppDelegate: UIResponder {
    
    var window: UIWindow?
    
    // MARK: Testing options
    // For citizenM, use 'let setup: UISetup = .pushed'
    let setup: UISetup = .pushed
    // If set to 'true', a simple reference ViewController is used instead of the Chat SDK UI, to show how safe area should look within the 'setup' options above
    let reference: Bool = true
}

// MARK: UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let vc = RootViewController(setup: setup, reference: reference)
        if setup.needsNavigationController {
            window?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            window?.rootViewController = vc
        }
        window?.makeKeyAndVisible()
        return true
    }
}

// MARK: Different testing options
enum UISetup {
    
    // These are all not really functioning properly, largely due to not adapting to available safe area, but also the internal navigationcontroller is not used.
    case embeddedInPushedVc
    case presentedOnTopOfPushedVc
    case presented
    
    /// Current setup in citizenM
    case pushed
    
    var needsNavigationController: Bool {
        switch self {
        case .presented:
            return false
        case .embeddedInPushedVc, .presentedOnTopOfPushedVc, .pushed:
            return true
        }
    }
}
