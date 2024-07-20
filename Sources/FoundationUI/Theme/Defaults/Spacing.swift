//
//  Spacing.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

extension FoundationUI.DefaultTheme {
    public var spacing: Variable.Spacing { .init(base: baseValue * 1.25, multiplier: 2) }
}

public extension FoundationUI.DefaultTheme.Variable {
    struct Spacing: DefaultFoundationAdjustableVariableWithMultiplier {        
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
