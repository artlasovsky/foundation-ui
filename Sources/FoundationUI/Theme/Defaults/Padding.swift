//
//  Padding.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.DefaultTheme {
    public var padding: Variable.Padding { .init(base: baseValue, multiplier: 2) }
}

public extension FoundationUI.DefaultTheme.Variable {
    struct Padding: DefaultFoundationAdjustableVariableWithMultiplier {
        public typealias Result = CGFloat
        public let value: CGFloatWithMultiplier
        public let adjust: @Sendable (CGFloatWithMultiplier) -> CGFloat
        
        public init(_ value: Value) {
            self.value = value
            self.adjust = { _ in value.base }
        }
        
        public init(adjust: @escaping @Sendable (CGFloatWithMultiplier) -> CGFloat) {
            self.adjust = adjust
            self.value = .init(base: 0, multiplier: 0)
        }
    }
}
