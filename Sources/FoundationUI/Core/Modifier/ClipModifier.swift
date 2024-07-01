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
    static func clip(cornerRadius: FoundationUI.Theme.Radius.Token? = nil) -> Self {
        FoundationUI.Modifier.ClipModifier(token: cornerRadius)
    }
}

public extension FoundationUI.Modifier {
    struct ClipModifier: FoundationUIModifier {
        @Environment(\.dynamicCornerRadius) private var envCornerRadius
        let token: FoundationUI.Theme.Radius.Token?
    
        private var cornerRadius: CGFloat? {
            guard let token else { return envCornerRadius }
            return FoundationUI.theme.radius(token)
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
