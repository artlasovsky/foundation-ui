//
//  ClipModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ClipModifier {
    /// Clip with Rectangle or RoundedRectangle
    static func clip(cornerRadius: FoundationUI.Theme.Radius.Scale? = nil) -> Self {
        FoundationUI.Modifier.ClipModifier(scale: cornerRadius)
    }
}

public extension FoundationUI.Modifier {
    struct ClipModifier: FoundationUIModifier {
        @Environment(\.FoundationUICornerRadius) private var envCornerRadius
        let scale: FoundationUI.Theme.Radius.Scale?
    
        private var cornerRadius: CGFloat? {
            guard let scale else { return envCornerRadius }
            return FoundationUI.theme.radius(scale)
        }
        
        public func body(content: Content) -> some View {
            if let cornerRadius {
                content.clipShape(FoundationUI.Shape.roundedRectangle(radius: cornerRadius))
            } else {
                content.clipShape(Rectangle())
            }
        }
    }
}

#Preview {
    VStack {
        Rectangle()
            .foundation(.size(.regular))
            .overlay {
                Rectangle()
                    .foundation(.size(width: .large, height: .small))
            }
            .foundation(.clip())
            .foundation(.cornerRadius(.regular))
    }
    .padding()
}
