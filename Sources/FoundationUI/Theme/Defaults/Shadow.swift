//
//  Shadow.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var shadow: Variable.Shadow { .init() }
}

extension FoundationUI.DefaultTheme.Variable {
    public struct Shadow: FoundationVariable {
        public func callAsFunction(_ token: Token) -> Configuration {
            token.value
        }
        
        public struct Configuration: Sendable {
            var color: FoundationUI.DynamicColor
            var radius: CGFloat
            var spread: CGFloat
            var x: CGFloat
            var y: CGFloat
        }
        
        public struct Token: FoundationTokenShadowScale, Sendable {
            public let value: FoundationUI.DefaultTheme.Variable.Shadow.Configuration
            
            public init(color: FoundationUI.Theme.Color, radius: CGFloat, spread: CGFloat = 0, x: CGFloat = 0, y: CGFloat = 0) {
                value = .init(color: color, radius: radius, spread: spread, x: x, y: y)
            }
        }
    }
}

public protocol FoundationTokenShadowScale: DefaultFoundationVariableTokenScale {}

extension FoundationTokenShadowScale where Self == FoundationUI.DefaultTheme.Variable.Shadow.Token {
    #warning("Test with dark theme, make it darker if needed")
    private static var color: FoundationUI.Theme.Color { .primary.token(.background).colorScheme(.dark) }
    public static var xxSmall: Self { .init(color: color.opacity(0.1), radius: 0.5) }
    public static var xSmall: Self { .init(color: color.opacity(0.15), radius: 1, y: 1) }
    public static var small: Self { .init(color: color.opacity(0.2), radius: 1.5, y: 1) }
    public static var regular: Self{ .init(color: color.opacity(0.25), radius: 2.5, y: 1) }
    public static var large: Self { .init(color: color.opacity(0.28), radius: 3.5, y: 1) }
    public static var xLarge: Self { .init(color: color.opacity(0.35), radius: 4.5, y: 1) }
    public static var xxLarge: Self { .init(color: color.opacity(0.4), radius: 6, y: 1) }
}
//
//#Preview {
//    VStack(spacing: FoundationUI.theme.spacing(.large)) {
//        ForEach(FoundationUI.DefaultTheme.Variable.Shadow.Token.all) { scale in
//            FoundationUI.Shape.roundedRectangle(.regular)
//                .foundation(.size(.regular))
//                .foundation(.foregroundToken(.background))
//                .foundation(.shadow(scale.value))
//        }
//    }
//    .foundation(.padding(.large))
//}
