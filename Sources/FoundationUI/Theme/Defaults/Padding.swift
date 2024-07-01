//
//  Padding.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.DefaultTheme {
    public var padding: Variable.Padding { .init(base: baseValue) }
}

public extension FoundationUI.DefaultTheme.Variable {
    struct Padding: DefaultThemeFoundationVariable {
        public let value: Configuration
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public struct Token: DefaultThemeFoundationVariableTokenScale {
            public var adjust: (SourceValue) -> ResultValue
            public init(_ adjust: @escaping (SourceValue) -> ResultValue) {
                self.adjust = adjust
            }
        }
    }    
}

