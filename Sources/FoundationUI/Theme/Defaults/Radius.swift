//
//  Radius.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var radius: Variable.Radius { .init(base: baseValue, multiplier: 1.5) }
}

extension FoundationUI.DefaultTheme.Variable {
    public struct Radius: DefaultFoundationAdjustableVariableWithMultiplier {
        public var value: CGFloatWithMultiplier
        public var adjust: @Sendable (CGFloatWithMultiplier) -> CGFloat
        
        public init(_ configuration: CGFloatWithMultiplier) {
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

#Preview {
    VStack {
        ForEach(FoundationUI.DefaultTheme.Variable.Radius.all) { token in
            let cornerRadius = FoundationUI.theme.radius(token.value)
            RoundedRectangle(cornerRadius: cornerRadius)
                .foundation(.size(.large))
                .foundation(.foregroundTinted(.solid))
                .overlay {
                    Text(cornerRadius.description)
                        .foundation(.foregroundTinted(.background))
                        .foundation(.font(.xSmall))
                }
        }
    }
    .foundation(.padding(.regular))
}
