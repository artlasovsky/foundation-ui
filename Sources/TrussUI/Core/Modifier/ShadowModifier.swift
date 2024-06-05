//
//  ShadowModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.ShadowModifier {
    static func shadow(configuration: ShadowConfiguration) -> Self {
        TrussUI.Modifier.ShadowModifier(configuration: configuration)
    }
    static func shadow(color colorVariable: TrussUI.DynamicColor = .primary.backgroundFaded,
                       radius: CGFloat,
                       x: CGFloat = 0,
                       y: CGFloat = 0
    ) -> Self {
        TrussUI.Modifier.ShadowModifier(
            configuration: ShadowConfiguration(
                radius: radius,
                colorVariable: colorVariable,
                x: x,
                y: y)
        )
    }
    static func shadow(_ variable: TrussUI.Variable.Shadow?) -> Self {
        TrussUI.Modifier.ShadowModifier(configuration: variable?.value)
    }
}

public extension TrussUI.Modifier {
    struct ShadowModifier: TrussUIModifier {
        @Environment(\.self) private var environment
        public let configuration: ShadowConfiguration?
        public func body(content: Content) -> some View {
            if let configuration {
                content
                    .shadow(
                        color: configuration.colorVariable.resolveColor(in: environment),
                        radius: configuration.radius,
                        x: configuration.x,
                        y: configuration.y)
            } else {
                content
            }
        }
    }
}

public struct ShadowConfiguration: Hashable, Equatable {
    var radius: CGFloat
    var colorVariable: TrussUI.DynamicColor
    var x: CGFloat = 0
    var y: CGFloat = 0
}
