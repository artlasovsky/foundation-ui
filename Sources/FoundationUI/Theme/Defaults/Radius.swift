//
//  Radius.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var radius: FoundationUI.Token.Radius { .init(base: baseValue, multiplier: 1.4) }
}

extension FoundationUI.Token {
    public struct Radius: FoundationDefaultThemeMultiplierToken {
        public let value: Configuration
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public struct Scale: FoundationDefaultThemeMultiplierTokenDefaults {
            public var adjust: (SourceValue) -> ResultValue
            public init(_ adjust: @escaping (SourceValue) -> ResultValue) {
                self.adjust = adjust
            }
            
            public func callAsFunction(_ base: (base: CGFloat, multiplier: CGFloat)) -> CGFloat {
                adjust(base).precise(0)
            }
        }
    }
}

#Preview {
    VStack {
        ForEach(FoundationUI.Token.Radius.Scale.all) { token in
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
