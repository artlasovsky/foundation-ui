//
//  FoundationVariable.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

/// #Naming
/// `Variable`
/// - `Variable Token`
///     - `Token Scale` (predefined scale like `colorScale` or `sizeScale`)

// MARK: - Token
#warning("TODO: Tests! To make sure it's working all the time!")

public protocol FoundationVariable {
    associatedtype Result
    associatedtype Token
    func callAsFunction(_ token: Token) -> Result
}

public protocol FoundationVariableWithValue: FoundationVariable {
    associatedtype Value
    var value: Value { get }
    init(_ base: Value)
}

extension FoundationVariableWithValue where Token: FoundationVariableToken {
    public func callAsFunction(_ token: Token) -> Result where Token.SourceValue == Value, Token.ResultValue == Result {
        token(value)
    }
}

public protocol FoundationVariableToken: Sendable {
    associatedtype SourceValue
    associatedtype ResultValue
    typealias Adjust = @Sendable (SourceValue) -> ResultValue
    var adjust: Adjust { get }
    
    func callAsFunction(_ base: SourceValue) -> ResultValue
    
    init(_ adjust: @escaping Adjust)
}

extension FoundationVariableToken {
    public func callAsFunction(_ base: SourceValue) -> ResultValue {
        adjust(base)
    }
    public init(value: ResultValue) {
        self.init({ _ in value })
    }
}

// MARK: - Default Token Scale

/// Default size scale from `xxSmall` to `xxLarge`
public protocol DefaultFoundationVariableTokenScale {
    static var xxSmall: Self { get }
    static var xSmall: Self { get }
    static var small: Self { get }
    static var regular: Self { get }
    static var large: Self { get }
    static var xLarge: Self { get }
    static var xxLarge: Self { get }
}

internal extension DefaultFoundationVariableTokenScale {
    static var all: [NamedValue<Self>] {
        [
            .init("xxSmall", .xxSmall),
            .init("xSmall", .xSmall),
            .init("small", .small),
            .init("regular", .regular),
            .init("large", .large),
            .init("xLarge", .xLarge),
            .init("xxLarge", .xxLarge)
        ]
    }
}

internal struct NamedValue<V>: Hashable, Identifiable {
    var id: String { name }
    
    let name: String
    let value: V
    
    init(_ name: String, _ value: V) {
        self.name = name
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    static func == (lhs: NamedValue, rhs: NamedValue) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
