//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.CornerRadiusModifier {
    static func cornerRadius(_ variable: FoundationUI.Variable.Radius?) -> Self {
        FoundationUI.Modifier.CornerRadiusModifier(variable: variable)
    }
}
public extension FoundationUI.Modifier {
    struct CornerRadiusModifier: FoundationUIModifier {
        let variable: FoundationUI.Variable.Radius?
        
        public func body(content: Content) -> some View {
            content.environment(\.FoundationUICornerRadius, variable?.value)
        }
    }
}

// MARK: - EnvironmentValues
private struct FoundationUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

internal extension EnvironmentValues {
    var FoundationUICornerRadius: CGFloat? {
        get { self[FoundationUICornerRadiusKey.self] }
        set { self[FoundationUICornerRadiusKey.self] = newValue }
    }
}
