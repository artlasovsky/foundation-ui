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
    public static var xxSmall: Self { regular.down(4) }
    public static var xSmall: Self { regular.down(2) }
    public static var small: Self { regular.down(1) }
    public static var regular: Self { Self { base, _ in base } }
    public static var large: Self { regular.up(1) }
    public static var xLarge: Self { regular.up(2) }
    public static var xxLarge: Self { regular.up(3) }
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
    func up(_ value: CGFloat) -> Self {
        .init { base, multiplier in
            let nextStep = base * multiplier * value
            let difference = nextStep - base
            
            return base + difference
        }
    }
    
    func up(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
        up(step.rawValue)
    }
    
    func down(_ value: CGFloat) -> Self {
        .init { base, multiplier in
            let nextStep = base / multiplier / value
            let difference = base - nextStep
            
            return base - difference
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
