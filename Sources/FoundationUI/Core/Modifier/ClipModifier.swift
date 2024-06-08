//
//  ClipModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ClipModifier {
    static func clip(cornerRadius: FoundationUI.Variable.Radius? = nil) -> Self {
        FoundationUI.Modifier.ClipModifier(cornerRadius: cornerRadius)
    }
}

public extension FoundationUI.Modifier {
    struct ClipModifier: FoundationUIModifier {
        @Environment(\.FoundationUICornerRadius) private var envCornerRadius
        let cornerRadius: FoundationUI.Variable.Radius?
        
        public func body(content: Content) -> some View {
            if let cornerRadius = cornerRadius?.value ?? envCornerRadius {
                content.clipShape(FoundationUI.Shape.roundedRectangle(radius: cornerRadius))
            } else {
                content
            }
        }
    }
}
