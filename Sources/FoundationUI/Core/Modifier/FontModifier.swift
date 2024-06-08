//
//  FontModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.FontModifier {
    static func font(_ variable: FoundationUI.Variable.Font) -> Self {
        FoundationUI.Modifier.FontModifier(font: variable.value)
    }
}

public extension FoundationUI.Modifier {
    struct FontModifier: FoundationUIModifier {
        public let font: Font
        public func body(content: Content) -> some View {
            content.font(font)
        }
    }
}
