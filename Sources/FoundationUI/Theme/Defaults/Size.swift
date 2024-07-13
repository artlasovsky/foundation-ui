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
    struct Size: DefaultFoundationAdjustableVariableWithMultiplier {
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
