//
//  ShadowModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct ShadowModifier<Style: ShapeStyle, S: Shape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        let style: Style
        let shape: S
        let radius: CGFloat
        let spread: CGFloat
        let x: CGFloat
        let y: CGFloat
        
        public func body(content: Content) -> some View {
            content
                .background {
                    ShapeBuilder.resolveShape(shape, dynamicCornerRadius: cornerRadius)
                        .foregroundStyle(style)
                        .blur(radius: radius)
                        .padding(spread * -1)
                        .offset(x: x, y: y)
                }
        }
        
        private var cornerRadius: CGFloat? {
            if let dynamicCornerRadius {
                return dynamicCornerRadius + spread
            }
            return nil
        }
    }
}

public extension FoundationUI.Modifier {
    static func shadow<Style: ShapeStyle, S: Shape>(
        style: Style,
        radius: CGFloat,
        spread: CGFloat = 0,
        x: CGFloat = 0,
        y: CGFloat = 0,
        in shape: S = .viewShape
    ) -> Modifier<Library.ShadowModifier<Style, S>> {
        .init(.init(style: style, shape: shape, radius: radius, spread: spread, x: x, y: y))
    }
    
    static func shadow<S: Shape>(
        _ token: FoundationUI.Theme.Shadow,
        in shape: S = .viewShape
    ) -> Modifier<Library.ShadowModifier<FoundationUI.Theme.Color, S>> {
        let configuration = token.value
        return .init(.init(
            style: configuration.color,
            shape: shape,
            radius: configuration.radius,
            spread: configuration.spread,
            x: configuration.x,
            y: configuration.y
        ))
    }
}

struct ShadowModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Shadow")
                .foundation(.size(.regular))
                .foundation(.background(.dynamic(.background), in: .dynamicRoundedRectangle()))
                .foundation(.shadow(style: .black.opacity(0.3), radius: 2.5, spread: -1.5, y: 2, in: .dynamicRoundedRectangle()))
                .foundation(.cornerRadius(.regular))
        }
        .foundation(.padding(.regular))
    }
}
