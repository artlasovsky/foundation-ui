//
//  DynamicTint.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

// MARK: Environment

private struct DynamicColorTintKey: EnvironmentKey {
    static var defaultValue: FoundationUI.Theme.Color = .dynamic
}

extension EnvironmentValues {
    var dynamicColorTint: FoundationUI.Theme.Color {
        get { self[DynamicColorTintKey.self] }
        set { self[DynamicColorTintKey.self] = newValue }
    }
}
