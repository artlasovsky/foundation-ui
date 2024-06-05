//
//  File.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.TintModifier {
    static func tint(_ dynamicColor: TrussUI.DynamicColor?) -> Self {
        TrussUI.Modifier.TintModifier(tint: dynamicColor)
    }
    @available(macOS 14.0, iOS 17.0, *)
    static func tintColor(_ color: Color?) -> Self {
        guard let color else {
            return tint(.environmentDefault)
        }
        return tint(.init(color: color))
    }
}

public extension TrussUI.Modifier {
    struct TintModifier: TrussUIModifier {
        let tint: TrussUI.DynamicColor?
        public func body(content: Content) -> some View {
            content.environment(\.dynamicColorTint, tint ?? .environmentDefault)
        }
    }
}
