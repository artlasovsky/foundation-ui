//
//  Radius.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var radius: Variable.Radius { .init(base: baseValue, multiplier: 1.4) }
}

extension FoundationUI.DefaultTheme.Variable {
    public struct Radius: DefaultThemeFoundationVariable {
        public let value: Configuration
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public struct Token: DefaultThemeFoundationVariableTokenScale {
            public var adjust: @Sendable (SourceValue) -> ResultValue
            public init(_ adjust: @escaping @Sendable (SourceValue) -> ResultValue) {
                self.adjust = adjust
            }
            
            public func callAsFunction(_ base: (base: CGFloat, multiplier: CGFloat)) -> CGFloat {
                adjust(base).precise(0)
            }
        }
    }
}

extension FoundationUI.DefaultTheme.Variable.Radius.Token {
    static let zero = Self(0)
}

#Preview {
    VStack {
        ForEach(FoundationUI.DefaultTheme.Variable.Radius.Token.all) { token in
            RoundedRectangle(cornerRadius: theme.radius(token.value))
                .foundation(.size(.large))
                .foundation(.foregroundToken(.solid))
                .overlay {
                    Text(token.name)
                        .foundation(.foregroundToken(.background))
                        .foundation(.font(.xSmall))
                }
        }
    }
    .foundation(.padding(.regular))
}
