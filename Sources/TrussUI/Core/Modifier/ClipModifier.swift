//
//  ClipModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.ClipModifier {
    static func clip(cornerRadius: TrussUI.Variable.Radius? = nil) -> Self {
        TrussUI.Modifier.ClipModifier(cornerRadius: cornerRadius)
    }
}

public extension TrussUI.Modifier {
    struct ClipModifier: TrussUIModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        let cornerRadius: TrussUI.Variable.Radius?
        
        public func body(content: Content) -> some View {
            if let cornerRadius = cornerRadius?.value ?? envCornerRadius {
                content.clipShape(TrussUI.Shape.roundedRectangle(radius: cornerRadius))
            } else {
                content
            }
        }
    }
}
