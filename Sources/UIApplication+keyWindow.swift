//
//  File.swift
//  
//
//  Created by Yanis Plumit on 05.02.2023.
//

import UIKit

public extension UIApplication {
    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState != .unattached }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    static var topModalViewController: UIViewController? {
        UIViewController.topModalViewController()
    }
}

public extension UIViewController {

    var topModalViewController: UIViewController? {
        return type(of: self).topModalViewController(vc: self)
    }
    
    static func topModalViewController(vc: UIViewController?) -> UIViewController? {
        var result = vc
        while nil != result?.presentedViewController {
            result = result?.presentedViewController
        }
        return result
    }

    static func topModalViewController() -> UIViewController? {
        return topModalViewController(vc: UIApplication.shared.keyWindow?.rootViewController)
    }
     
}
