//
//  Shadow.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public protocol FoundationTokenShadowScale: DefaultFoundationVariableTokenScale {}

extension FoundationTokenShadowScale where Self == Theme.Shadow {
    #warning("Test with dark theme, make it darker if needed")
    private static var color: Theme.Color { .primary.variant(.background).colorScheme(.dark) }
    public static var xxSmall: Self { .init(color: color.opacity(0.1), radius: 0.5, y: 0.5) }
    public static var xSmall: Self { .init(color: color.opacity(0.15), radius: 1, spread: -1, y: 1) }
    public static var small: Self { .init(color: color.opacity(0.2), radius: 2, spread: -1.5, y: 1) }
    public static var regular: Self{ .init(color: color.opacity(0.25), radius: 3, spread: -2, y: 1.2) }
    public static var large: Self { .init(color: color.opacity(0.28), radius: 4, spread: -2, y: 1.4) }
    public static var xLarge: Self { .init(color: color.opacity(0.35), radius: 5, spread: -2.5, y: 1.6) }
    public static var xxLarge: Self { .init(color: color.opacity(0.4), radius: 6, spread: -2.5, y: 1.8) }
}

extension Theme {
    @frozen
    public struct Shadow: FoundationVariableWithValue, FoundationTokenShadowScale {
        public func callAsFunction(_ token: Self) -> Configuration {
            token.value
        }
        
        public var value: Configuration
        
        public init() {
            self = .regular
        }
        
        public init(color: Theme.Color, radius: CGFloat, spread: CGFloat = 0, x: CGFloat = 0, y: CGFloat = 0) {
            self.value = .init(color: color, radius: radius, spread: spread, x: x, y: y)
        }
        
        public init(value: Configuration) {
            self.value = value
        }
        
        public struct Configuration: Sendable, Hashable {
            var color: Theme.Color
            var radius: CGFloat
            var spread: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
        }
    }
}

struct ShadowPreview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .foundation(.spacing(.large))) {
            ForEach(Theme.Shadow.Token.all) { scale in
                Text(scale.name)
                    .foundation(.size(.regular))
                    .foundation(.background(.dynamic(.background), in: .dynamicRoundedRectangle()))
                    .foundation(.shadow(scale.value, in: .dynamicRoundedRectangle()))
                    .foundation(.cornerRadius(.regular))
            }
        }
        .foundation(.padding(.large))
    }
}
