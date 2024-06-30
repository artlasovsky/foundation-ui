//
//  File.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.TintModifier {
    static func tint(_ dynamicColor: FoundationUI.Theme.Color?) -> Self {
        FoundationUI.Modifier.TintModifier(tint: dynamicColor)
    }
    @available(macOS 14.0, iOS 17.0, *)
    static func tintColor(_ color: Color?) -> Self {
        guard let color else {
            return tint(.environmentDefault)
        }
        return tint(.from(color: color))
    }
}

public extension FoundationUI.Modifier {
    struct TintModifier: FoundationUIModifier {
        let tint: FoundationUI.DynamicColor?
        public func body(content: Content) -> some View {
            content.environment(\.dynamicColorTint, tint ?? .environmentDefault)
        }
    }
}
