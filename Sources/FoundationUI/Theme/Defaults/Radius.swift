//
//  Radius.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
    public struct Radius: DefaultFoundationAdjustableVariableWithMultiplier {
        public var value: CGFloatWithMultiplier
        public var adjust: @Sendable (CGFloatWithMultiplier) -> CGFloat
        
        public init(value configuration: CGFloatWithMultiplier) {
            value = configuration
            adjust = { _ in configuration.base }
        }
        public init(adjust: @escaping @Sendable (CGFloatWithMultiplier) -> CGFloat) {
            value = .init(base: 0, multiplier: 0)
            self.adjust = adjust
        }
        
        public func callAsFunction(_ token: Self) -> CGFloat {
            token.adjust(value).precise(0)
        }
    }
}

public extension Theme.Radius {
    static let zero = Self(value: 0)
}

public extension Theme.Radius {
    static func swatch() -> some View {
        Swatch("Radius", value: Theme.default.radius) { title, value in
            VStack {
                Text(title)
                    .foundation(.foreground(.dynamic(.solidSubtle)))
                Text(String(format: "%.2f", value))
                    .foundation(.foreground(.dynamic(.text)))
            }
            .foundation(.font(.xSmall))
            .foundation(.size(width: .large, height: .regular))
            .foundation(.background(.dynamic(.background)))
            .foundation(.border(.dynamic(.borderSubtle)))
            .foundation(.cornerRadius(.init(value: value)))
        }
    }
}

struct Radius_Preview: PreviewProvider {
    static var previews: some View {
        Theme.Radius.swatch().foundation(.padding(.regular))
    }
}
