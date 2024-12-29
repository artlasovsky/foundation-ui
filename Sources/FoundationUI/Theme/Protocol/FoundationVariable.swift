//
//  FoundationVariable.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Variable
#warning("TODO: Tests! To make sure it's working all the time!")

public protocol FoundationVariable: Hashable {
    associatedtype Result: Hashable
    associatedtype Token
    func callAsFunction(_ token: Token) -> Result
}

public protocol FoundationVariableWithValue: FoundationVariable, AdjustableByEnvironment {
    associatedtype Value: Hashable
    var value: Value { get }
    init(value: Value)
}

public extension FoundationVariableWithValue {
	func callAsFunction(_ token: Self) -> Value {
		token.value
	}
	
	func resolve(in environment: EnvironmentValues?) -> Value {
		guard let environment else { return value }
		return environmentAdjustment?(environment)?.value ?? value
	}
	
	func resolve(theme: Theme?, colorScheme: FoundationColorScheme = .light) -> Value {
		var environment = colorScheme.environmentValues()
		environment.foundationTheme = theme
		return environmentAdjustment?(environment)?.value ?? value
	}
}

public extension FoundationVariableWithValue {
	static func ==(lhs: Self, rhs: Self) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}
}

public extension FoundationVariableWithValue {
    init(_ value: Value) {
        self.init(value: value)
    }
}

public enum FoundationVariableStep: CGFloat {
    case full
    case half
    case quarter
}

public extension FoundationVariableWithValue where Value: FloatingPoint {
    static func value(_ value: Value) -> Self {
        .init(value: value)
    }
	
	static var zero: Self { value(0) }
    
	///	Step up from the current value by the following amounts:
	///	- `.full` doubles the value
	///	- `.half` adds half of the value
	///	- `.quarter` adds a quarter of the value
	///
	///	| Step		| 8		| 16		|
	/// | -			| -		| -		|
	/// | `.quarter`	| 10		| 20		|
	/// | `.half`		| 12		| 24		|
	/// | `.full`		| 16		| 32		|
    func up(_ step: FoundationVariableStep) -> Self {
        switch step {
        case .full:
            .init(value + value)
        case .half:
            .init(value + value / 2)
        case .quarter:
            .init(value + value / 4)
        }
    }
    
	/// Step down from the current value by the following proportions of half the value:
	/// - `.full` subtracts half the value
	/// - `.half` subtracts a quarter of the value
	/// - `.quarter` subtracts an eighth of the value
	///
	/// | Step		| 16		| 8		|
	/// | -			| -		| -		|
	/// | `.quarter`	| 14		| 7		|
	/// | `.half`		| 12		| 6		|
	/// | `.full`		| 8		| 4		|
    func down(_ step: FoundationVariableStep) -> Self {
        let stepDown = value / 2
        switch step {
        case .full:
            return .init(value - stepDown)
        case .half:
            return .init(value - stepDown / 2)
        case .quarter:
            return .init(value - stepDown / 4)
        }
    }
	
    func negative() -> Self {
        self * -1
    }
	
	static func +(lhs: Self, rhs: Value) -> Self {
		.init(lhs.value + rhs)
	}
	
	static func -(lhs: Self, rhs: Value) -> Self {
		.init(lhs.value + rhs)
	}
	
	static func *(lhs: Self, rhs: Value) -> Self {
		.init(lhs.value * rhs)
	}
	
	static func /(lhs: Self, rhs: Value) -> Self {
		.init(lhs.value / rhs)
	}
}
