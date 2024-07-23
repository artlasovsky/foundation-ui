//
//  DynamicTint.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

// MARK: Environment

private struct DynamicTintKey: EnvironmentKey {
    static let defaultValue: Theme.Color = .primary
}

extension EnvironmentValues {
    var dynamicTint: Theme.Color {
        get { self[DynamicTintKey.self] }
        set { self[DynamicTintKey.self] = newValue }
    }
}
