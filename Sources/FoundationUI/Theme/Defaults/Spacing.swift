//
//  Spacing.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.Theme {
    public var spacing: FoundationUI.Token.Spacing { .init(base: baseValue) }
}

extension FoundationUI.Token {
    public struct Spacing: FoundationTokenWithMultiplier {
        public let value: Configuration
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public struct Scale: FoundationTokenWithMultiplierScaleDefault {
            public var adjust: (SourceValue) -> ResultValue
            public init(_ adjust: @escaping (SourceValue) -> ResultValue) {
                self.adjust = adjust
            }
        }
    }
}
