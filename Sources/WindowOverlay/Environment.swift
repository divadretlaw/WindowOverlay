//
//  Environment.swift
//  WindowOverlay
//
//  Created by David Walter on 25.03.23.
//

import SwiftUI

struct WindowOverlayModalTransitionStyleKey: EnvironmentKey {
    static var defaultValue: UIModalTransitionStyle { .crossDissolve }
}

struct WindowOverlayBackgroundColorKey: EnvironmentKey {
    static var defaultValue: UIColor { .clear }
}

struct WindowOverlayLevelKey: EnvironmentKey {
    static var defaultValue: UIWindow.Level { .normal }
}

extension EnvironmentValues {
    var windowOverlayModalTransitionStyle: UIModalTransitionStyle {
        get { self[WindowOverlayModalTransitionStyleKey.self] }
        set { self[WindowOverlayModalTransitionStyleKey.self] = newValue }
    }
    
    var windowOverlayBackgroundColor: UIColor {
        get { self[WindowOverlayBackgroundColorKey.self] }
        set { self[WindowOverlayBackgroundColorKey.self] = newValue }
    }
    
    var windowOverlayLevel: UIWindow.Level {
        get { self[WindowOverlayLevelKey.self] }
        set { self[WindowOverlayLevelKey.self] = newValue }
    }
}
