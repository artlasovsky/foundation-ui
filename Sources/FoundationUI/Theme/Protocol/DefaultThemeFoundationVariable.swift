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
where Value == Configuration, Token: FoundationDefaultThemeMultiplierTokenScale, Result == CGFloat
{
    typealias Configuration = (base: CGFloat, multiplier: CGFloat)
}

public protocol FoundationDefaultThemeMultiplierTokenScale: FoundationVariableToken
where SourceValue == DefaultThemeFoundationVariable.Configuration, ResultValue == CGFloat {}

public protocol FoundationTokenMultiplierSizeScale: DefaultFoundationVariableTokenScale, FoundationDefaultThemeMultiplierTokenScale {}

extension DefaultThemeFoundationVariable {
    public func callAsFunction(_ token: Token) -> Result {
        token(value)
    }
    
    public init(base: CGFloat, multiplier: CGFloat = 2) {
        self.init((base, multiplier))
    }
}

// MARK: Default Multiplier Token Scale

public protocol DefaultThemeFoundationVariableTokenScale: FoundationTokenMultiplierSizeScale {}

extension DefaultThemeFoundationVariableTokenScale {
    public static var xxSmall: Self { Self { $0 / pow($1, 3) } }
    public static var xSmall: Self { Self { $0 / pow($1, 2) } }
    public static var small: Self { Self { $0 / $1 } }
    public static var regular: Self { Self { base, _ in base } }
    public static var large: Self { Self { $0 * $1 } }
    public static var xLarge: Self { Self { $0 * pow($1, 2) } }
    public static var xxLarge: Self { Self { ($0 * pow($1, 3)) } }
}

// MARK: - Scale Step Extensions

extension FoundationUI.DefaultTheme.Variable {
    public enum ScaleStep: CGFloat {
        case full = 1
        case half = 0.5
        case third = 0.33
        case quarter = 0.25
    }
}


public extension FoundationVariableToken
where SourceValue == DefaultThemeFoundationVariable.Configuration, ResultValue == CGFloat {
    func up(_ step: FoundationUI.DefaultTheme.Variable.ScaleStep) -> Self {
        .init { base, multiplier in
            let nextStep = base * multiplier
            let difference = nextStep - base
            
            return base + difference * step.rawValue
        }
    }
    
    func down(_ step: FoundationUI.DefaultTheme.Variable.ScaleStep) -> Self {
        .init { base, multiplier in
            let nextStep = base / multiplier
            let difference = base - nextStep
            
            return base - difference * step.rawValue
        }
    }
    
    func negative() -> Self {
        .init { value in
            self.adjust(value) * -1
        }
    }
}
