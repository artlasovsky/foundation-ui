//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.CornerRadiusModifier {
    static func cornerRadius(_ scale: FoundationUI.Theme.Radius.Scale?) -> Self {
        FoundationUI.Modifier.CornerRadiusModifier(scale: scale)
    }
}
public extension FoundationUI.Modifier {
    struct CornerRadiusModifier: FoundationUIModifier {
        let scale: FoundationUI.Theme.Radius.Scale?
        
        private var value: CGFloat? {
            guard let scale else { return nil }
            return FoundationUI.theme.radius(scale)
        }
        
        public func body(content: Content) -> some View {
            content.environment(\.FoundationUICornerRadius, value)
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
