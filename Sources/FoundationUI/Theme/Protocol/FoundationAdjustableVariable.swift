//
//  FoundationAdjustableVariable.swift
//
//
//  Created by Art Lasovsky on 13/07/2024.
//

import Foundation
import SwiftUI

public protocol FoundationAdjustableVariable: FoundationVariableWithValue {
    var adjust: @Sendable (Value) -> Result { get }
    
    init(_ value: Value)
    init(adjust: @Sendable @escaping (Value) -> Result)
    
    func callAsFunction(_ token: Self) -> Result
}

public extension FoundationAdjustableVariable {
    func callAsFunction(_ token: Self) -> Result {
        token.adjust(value)
    }
}

public struct CGFloatWithMultiplier {
    public let base: CGFloat
    public let multiplier: CGFloat
}

public protocol DefaultFoundationAdjustableVariableWithMultiplier:
    FoundationAdjustableVariable, DefaultFoundationVariableTokenScale
    where Value == CGFloatWithMultiplier, Result == CGFloat {}

public extension DefaultFoundationAdjustableVariableWithMultiplier {
    init(base: CGFloat, multiplier: CGFloat) {
        self.init(.init(base: base, multiplier: multiplier))
    }
    
    init(value: CGFloat) {
        self.init(.init(base: value, multiplier: 1))
    }
    
    static var xxSmall: Self { .xSmall.down(.full) }
    static var xSmall: Self { .small.down(.full) }
    static var small: Self { .regular.down(.full) }
    static var regular: Self { .init { $0.base } }
    static var large: Self { .regular.up(.full) }
    static var xLarge: Self { .large.up(.full) }
    static var xxLarge: Self { .xLarge.up(.full) }
}

extension FoundationUI.DefaultTheme.Variable {
    public enum Step: CGFloat {
        case full = 1
        case half = 0.5
        case third = 0.33
        case quarter = 0.25
    }
}

public extension FoundationAdjustableVariable where Value == CGFloatWithMultiplier, Result == CGFloat {
    func up(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
        up(step.rawValue)
    }
    
    func down(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
        down(step.rawValue)
    }
    
    func negative() -> Self {
        .init { value in
            self.adjust(value) * -1
        }
    }
    
    private func up(_ value: CGFloat) -> Self {
        .init { source in
            let base = source.base
            let multiplier = source.multiplier
            
            let current = self.adjust(.init(base: base, multiplier: multiplier))
            let nextStep = current * multiplier
            let difference = nextStep - current
            
            return (current + difference * value).precise()
        }
    }
    
    private func down(_ value: CGFloat) -> Self {
        .init { source in
            let base = source.base
            let multiplier = source.multiplier
            
            let current = self.adjust(.init(base: base, multiplier: multiplier))
            let nextStep = current / multiplier
            let difference = current - nextStep
            
            return (current - difference * value).precise()
        }
    }
}
