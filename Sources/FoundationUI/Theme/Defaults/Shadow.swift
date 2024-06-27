//
//  File.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.Theme {
    public var shadow: FoundationUI.Token.Shadow { .init() }
}

extension FoundationUI.Token {
    public struct Shadow: FoundationToken {
        public func callAsFunction(_ scale: Scale) -> Configuration {
            scale.value
        }
        
        public struct Configuration {
            var color: FoundationUI.DynamicColor
            var radius: CGFloat
            var x: CGFloat
            var y: CGFloat
        }
        
        public struct Scale: FoundationTokenShadowScale {
            public let value: FoundationUI.Token.Shadow.Configuration
            
            public init(color: FoundationUI.DynamicColor, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
                value = .init(color: color, radius: radius, x: x, y: y)
            }
        }
    }
}

public protocol FoundationTokenShadowScale: FoundationTokenScale, FoundationTokenScaleDefault
where SourceValue == FoundationUI.Token.Shadow.Configuration {}

extension FoundationTokenShadowScale where Self == FoundationUI.Token.Shadow.Scale {
    #warning("Test with dark theme, make it darker if needed")
    private static var color: FoundationUI.DynamicColor { .primary.scale(.background).colorScheme(.dark) }
    public static var xxSmall: Self { .init(color: color.opacity(0.1), radius: 0.5) }
    public static var xSmall: Self { .init(color: color.opacity(0.15), radius: 1, y: 1) }
    public static var small: Self { .init(color: color.opacity(0.2), radius: 1.5, y: 1) }
    public static var regular: Self{ .init(color: color.opacity(0.25), radius: 2.5, y: 1) }
    public static var large: Self { .init(color: color.opacity(0.28), radius: 3.5, y: 1) }
    public static var xLarge: Self { .init(color: color.opacity(0.35), radius: 4.5, y: 1) }
    public static var xxLarge: Self { .init(color: color.opacity(0.4), radius: 6, y: 1) }
}

#Preview {
    VStack(spacing: .theme.spacing(.large)) {
        ForEach(FoundationUI.Token.Shadow.Scale.all) { scale in
            FoundationUI.Shape.roundedRectangle(.regular)
                .foundation(.size(.regular))
                .foundation(.foregroundTinted(.background))
                .foundation(.shadow(scale.value))
        }
    }
    .foundation(.padding(.large))
}
