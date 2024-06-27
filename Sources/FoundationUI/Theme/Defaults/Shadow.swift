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
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
        
        public struct Scale: FoundationTokenShadowScale {
            public let value: FoundationUI.Token.Shadow.Configuration
            
            public init(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
                value = .init(color: color, radius: radius, x: x, y: y)
            }
        }
    }
}

public protocol FoundationTokenShadowScale: FoundationTokenScale, FoundationTokenScaleDefault
where SourceValue == FoundationUI.Token.Shadow.Configuration {}

extension FoundationTokenShadowScale where Self == FoundationUI.Token.Shadow.Scale {
    private static var color: Color { .black.opacity(0.3) }
    public static var xxSmall: Self { .init(color: color.opacity(0.5), radius: 1.5) }
    public static var xSmall: Self { .init(color: color.opacity(0.7), radius: 2) }
    public static var small: Self { .init(color: color.opacity(0.8), radius: 2.5) }
    public static var regular: Self{ .init(color: color.opacity(0.9), radius: 3, x: 0, y: 0) }
    public static var large: Self { .init(color: color, radius: 3.5) }
    public static var xLarge: Self { .init(color: color, radius: 4) }
    public static var xxLarge: Self { .init(color: color, radius: 5) }
}

extension View {
    @ViewBuilder
    func shadow_(_ scale: FoundationUI.Token.Shadow.Scale) -> some View {
        let configuration = FoundationUI.Token.Shadow()(scale)
        self.shadow(
            color: configuration.color,
            radius: configuration.radius,
            x: configuration.x,
            y: configuration.y
        )
    }
}

#Preview {
    VStack(spacing: .theme.spacing(.regular)) {
        ForEach(FoundationUI.Token.Shadow.Scale.all) { scale in
            FoundationUI.Shape.roundedRectangle(.regular)
                .foundation(.size(.regular))
                .foundation(.foregroundTinted(.background))
                .shadow_(scale.value)
        }
    }
    .foundation(.padding(.regular))
}
