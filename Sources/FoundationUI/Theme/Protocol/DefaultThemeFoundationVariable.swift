//
//  DefaultThemeFoundationVariable.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

// MARK: - Token with Multiplier

/// Token with multiplier
public protocol DefaultThemeFoundationVariable: FoundationVariableWithValue
where Value == Configuration, Token: DefaultThemeFoundationVariableToken, Result == CGFloat
{
    typealias Configuration = (base: CGFloat, multiplier: CGFloat)
}

public protocol DefaultThemeFoundationVariableToken: FoundationVariableToken
where SourceValue == DefaultThemeFoundationVariable.Configuration, ResultValue == CGFloat {}

public protocol DefaultThemeFoundationVariableTokenScale: DefaultFoundationVariableTokenScale, DefaultThemeFoundationVariableToken {}

extension DefaultThemeFoundationVariable {
    public func callAsFunction(_ token: Token) -> Result {
        token(value)
    }
    
    public init(base: CGFloat, multiplier: CGFloat = 2) {
        self.init((base, multiplier))
    }
}

// MARK: Default Multiplier Token Scale

extension DefaultThemeFoundationVariableTokenScale {
    public static var xxSmall: Self { xSmall.down(.full) }
    public static var xSmall: Self { small.down(.full) }
    public static var small: Self { regular.down(.full) }
    public static var regular: Self { Self { base, _ in base } }
    public static var large: Self { regular.up(.full) }
    public static var xLarge: Self { large.up(.full) }
    public static var xxLarge: Self { xLarge.up(.full) }
}

// MARK: - Scale Step Extensions

extension FoundationUI.DefaultTheme.Variable {
    public enum Step: CGFloat {
        case full = 1
        case half = 0.5
        case third = 0.33
        case quarter = 0.25
    }
}


public extension FoundationVariableToken
where SourceValue == DefaultThemeFoundationVariable.Configuration, ResultValue == CGFloat {
    private func up(_ value: CGFloat) -> Self {
        .init { base, multiplier in
            let current = self.adjust((base, multiplier))
            let nextStep = current * multiplier
            let difference = nextStep - current
            
            return (current + difference * value).precise()
        }
    }
    
    func up(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
        up(step.rawValue)
    }
    
    private func down(_ value: CGFloat) -> Self {
        .init { base, multiplier in
            let current = self.adjust((base, multiplier))
            let nextStep = current / multiplier
            let difference = current - nextStep
            
            return (current - difference * value).precise()
        }
    }
    
    func down(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
        down(step.rawValue)
    }
    
    func negative() -> Self {
        .init { value in
            self.adjust(value) * -1
        }
    }
}
