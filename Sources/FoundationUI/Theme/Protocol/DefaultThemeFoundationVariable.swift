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

import SwiftUI

#Preview {
    Text(FoundationUI.theme.padding(.regular).description)
}


public extension FoundationVariableToken
where SourceValue == DefaultThemeFoundationVariable.Configuration, ResultValue == CGFloat {
    func up(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
        .init { base, multiplier in
            let nextStep = base * multiplier
            let difference = nextStep - base
            
            return base + difference * step.rawValue
        }
    }
    
    func down(_ step: FoundationUI.DefaultTheme.Variable.Step) -> Self {
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
