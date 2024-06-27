//
//  ShadowModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ShadowModifier {
    static func shadow(color: FoundationUI.DynamicColor, radius: CGFloat, x: CGFloat, y: CGFloat) -> Self {
        FoundationUI.Modifier.ShadowModifier(
            configuration: .init(
                color: color,
                radius: radius,
                x: x,
                y: y
            )
        )
    }
    static func shadow(_ scale: FoundationUI.Token.Shadow.Scale?, color: FoundationUI.Token.DynamicColor? = nil) -> Self {
        var configuration = scale?.value
        if let color {
            configuration?.color = color
        }
        return FoundationUI.Modifier.ShadowModifier(configuration: configuration)
    }
}

#Preview {
    VStack {
        FoundationUI.Shape.roundedRectangle(.regular)
            .foundation(.size(.regular))
            .foundation(.foregroundTinted(.background))
            .foundation(.shadow(.regular))
    }
    .foundation(.padding(.regular))
}

public extension FoundationUI.Modifier {
    struct ShadowModifier: FoundationUIModifier {
        @Environment(\.self) private var environment
        public typealias Configuration = FoundationUI.Token.Shadow.Configuration
        public let configuration: Configuration?
    
        public func body(content: Content) -> some View {
            if let configuration {
                content
                    .shadow(
                        color: configuration.color.resolveColor(in: environment),
                        radius: configuration.radius,
                        x: configuration.x,
                        y: configuration.y)
            } else {
                content
            }
        }
    }
}
