//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.CornerRadiusModifier {
    static func cornerRadius(_ variable: TrussUI.Variable.Radius?) -> Self {
        TrussUI.Modifier.CornerRadiusModifier(variable: variable)
    }
}
public extension TrussUI.Modifier {
    struct CornerRadiusModifier: TrussUIModifier {
        let variable: TrussUI.Variable.Radius?
        
        public func body(content: Content) -> some View {
            content.environment(\.TrussUICornerRadius, variable?.value)
        }
    }
}

// MARK: - EnvironmentValues
private struct TrussUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

internal extension EnvironmentValues {
    var TrussUICornerRadius: CGFloat? {
        get { self[TrussUICornerRadiusKey.self] }
        set { self[TrussUICornerRadiusKey.self] = newValue }
    }
}
