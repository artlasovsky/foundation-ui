//
//  ShadowModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct ShadowModifier<Style: ShapeStyle, S: InsettableShape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        @Environment(\.dynamicCornerRadiusStyle) private var dynamicCornerRadiusStyle
        let style: Style
        let shape: S
        let radius: CGFloat
        let spread: CGFloat
        let x: CGFloat
        let y: CGFloat
        
        public func body(content: Content) -> some View {
            content.background {
                shapeView
                    .foregroundStyle(style)
                    .blur(radius: radius)
                    .offset(x: x, y: y)
            }
        }
        
        private var shapeView: some View {
            ShapeBuilder.resolveInsettableShape(
                shape,
                inset: inset,
                strokeWidth: nil,
                dynamicCornerRadius: dynamicCornerRadius,
                dynamicCornerRadiusStyle: dynamicCornerRadiusStyle
            )
        }
        
        private var inset: CGFloat {
            spread * -1
        }
    }
}

public extension FoundationModifier {
    static func shadow<S: Shape>(
        color: Theme.Color,
        radius: CGFloat,
        spread: CGFloat = 0,
        x: CGFloat = 0,
        y: CGFloat = 0,
        in shape: S = .dynamicRoundedRectangle()
    ) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Theme.Color, S>> {
        .init(.init(style: color, shape: shape, radius: radius, spread: spread, x: x, y: y))
    }
    
    static func shadow<Style: ShapeStyle, S: Shape>(
        style: Style,
        radius: CGFloat,
        spread: CGFloat = 0,
        x: CGFloat = 0,
        y: CGFloat = 0,
        in shape: S = .dynamicRoundedRectangle()
    ) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Style, S>> {
        .init(.init(style: style, shape: shape, radius: radius, spread: spread, x: x, y: y))
    }
    
    static func shadow<S: Shape>(
        _ token: Theme.Shadow,
        in shape: S = .dynamicRoundedRectangle()
    ) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Theme.Color, S>> {
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
                .foundation(
                    .shadow(
                        color: .dynamic(.background).colorScheme(.dark),
                        radius: 2.5,
                        spread: -1.5,
                        y: 2,
                        in: .dynamicRoundedRectangle()
                    )
                )
                .foundation(.cornerRadius(.regular))
        }
        .foundation(.padding(.regular))
        .foundation(.background(.dynamic(.background)))
        ._colorScheme(.light)
    }
}
