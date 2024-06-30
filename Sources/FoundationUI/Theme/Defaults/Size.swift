//
//  Size.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.DefaultTheme {
    public var size: FoundationUI.Token.Size { .init(base: baseValue * 8, multiplier: 2) }
}

public extension FoundationUI.Token {
    struct Size: FoundationDefaultThemeMultiplierToken {
        public let value: Configuration
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public struct Scale: FoundationDefaultThemeMultiplierTokenDefaults {
            public var adjust: (SourceValue) -> ResultValue
            public init(_ adjust: @escaping (SourceValue) -> ResultValue) {
                self.adjust = adjust
            }
        }
    }
}
