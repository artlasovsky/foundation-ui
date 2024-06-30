//
//  ShadowModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ShadowModifier {
    static func shadow(color: FoundationUI.Theme.Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> Self {
        FoundationUI.Modifier.ShadowModifier(
            configuration: .init(
                color: color,
                radius: radius,
                x: x,
                y: y
            )
        )
    }
    static func shadow(_ scale: FoundationUI.Theme.Shadow.Scale?, color: FoundationUI.Theme.Color? = nil) -> Self {
        var configuration = scale?.value
        if let color {
            configuration?.color = color
        }
        return FoundationUI.Modifier.ShadowModifier(configuration: configuration)
    }
}

public extension FoundationUI.Modifier {
    struct ShadowModifier: FoundationUIModifier {
        @Environment(\.self) private var environment
        public typealias Configuration = FoundationUI.Theme.Shadow.Configuration
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

#Preview {
    VStack {
        FoundationUI.Shape.roundedRectangle(.regular)
            .foundation(.size(.regular))
            .foundation(.foregroundTinted(.background))
            .foundation(.shadow(.regular))
    }
    .foundation(.padding(.regular))
}
