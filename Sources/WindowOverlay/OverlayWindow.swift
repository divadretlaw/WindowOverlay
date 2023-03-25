//
//  OverlayWindow.swift
//  OverlayWindow
//
//  Created by David Walter on 03.04.22.
//

import UIKit
import SwiftUI

enum OverlayWindow {
    static var allWindows: [UIWindowScene: UIWindow] = [:]
    
    static func present<Content>(on windowScene: UIWindowScene, isInteractive: Bool, view: () -> Content) where Content: View {
        guard allWindows[windowScene] == nil else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.isUserInteractionEnabled = isInteractive
        allWindows[windowScene] = window
        
        let hostingController = UIHostingController(rootView: view())
        hostingController.view.backgroundColor = .clear
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.modalPresentationStyle = .fullScreen
        
        window.rootViewController = UIViewController(nibName: nil, bundle: nil)
        window.windowLevel = .alert
        window.backgroundColor = .clear
        window.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle

        window.subviews.forEach { $0.isHidden = true }
        window.makeKeyAndVisible()
        
        DispatchQueue.main.async {
            window.rootViewController?.present(hostingController, animated: true)
        }
    }
    
    static func dismiss(on windowScene: UIWindowScene?) {
        if let windowScene = windowScene {
            guard let window = allWindows[windowScene] else { return }
            if let viewController = window.rootViewController {
                viewController.dismiss(animated: true) {
                    window.isHidden = true
                    allWindows[windowScene] = nil
                }
            } else {
                window.isHidden = true
                allWindows[windowScene] = nil
            }
        } else {
            dismiss()
        }
    }
    
    static func dismiss() {
        allWindows.forEach { windowScene, window in
            dismiss(on: windowScene)
        }
    }
}
