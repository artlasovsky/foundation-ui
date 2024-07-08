//
//  Size.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.DefaultTheme {
    public var size: Variable.Size { .init(base: baseValue * 8, multiplier: 2) }
}

public extension FoundationUI.DefaultTheme.Variable {
    struct Size: DefaultThemeFoundationVariable {
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
