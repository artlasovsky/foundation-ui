//
//  Padding.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.Theme {
    public var padding: FoundationUI.Token.Padding { .init(base: baseValue) }
}

public extension FoundationUI.Token {
    public struct Padding: FoundationTokenWithMultiplier {
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

