//
//  FontModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.FontModifier {
    static func font(_ variable: TrussUI.Variable.Font) -> Self {
        TrussUI.Modifier.FontModifier(font: variable.value)
    }
}

public extension TrussUI.Modifier {
    struct FontModifier: TrussUIModifier {
        public let font: Font
        public func body(content: Content) -> some View {
            content.font(font)
        }
    }
}
