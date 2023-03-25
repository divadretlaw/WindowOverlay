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

extension EnvironmentValues {
    var windowOverlayModalTransitionStyle: UIModalTransitionStyle {
        get { self[WindowOverlayModalTransitionStyleKey.self] }
        set { self[WindowOverlayModalTransitionStyleKey.self] = newValue }
    }
}
