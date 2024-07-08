//
//  Spacing.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.DefaultTheme {
    public var spacing: Variable.Spacing { .init(base: baseValue) }
}

public extension FoundationUI.DefaultTheme.Variable {
    struct Spacing: DefaultThemeFoundationVariable {
        public let value: Configuration
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public struct Token: DefaultThemeFoundationVariableTokenScale {
            public var adjust: @Sendable (SourceValue) -> ResultValue
            public init(_ adjust: @escaping @Sendable (SourceValue) -> ResultValue) {
                self.adjust = adjust
            }
        }
    }
}
