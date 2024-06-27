//
//  Token.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

// MARK: - Token

public protocol FoundationToken {
    associatedtype Result
    associatedtype Scale
    func callAsFunction(_ scale: Scale) -> Result
}

public protocol FoundationTokenWithValue: FoundationToken {
    associatedtype Value
    var value: Value { get }
    init(_ base: Value)
}

extension FoundationTokenWithValue where Scale: FoundationTokenAdjustableScale {
    public func callAsFunction(_ scale: Scale) -> Result where Scale.SourceValue == Value, Scale.ResultValue == Result {
        scale(value)
    }
}

public protocol FoundationTokenScale {
    associatedtype SourceValue
    var value: SourceValue { get }
}

public protocol FoundationTokenAdjustableScale {
    associatedtype SourceValue
    associatedtype ResultValue
    typealias Adjust = (SourceValue) -> ResultValue
    var adjust: Adjust { get }
    
    func callAsFunction(_ base: SourceValue) -> ResultValue
    
    init(_ adjust: @escaping Adjust)
}

extension FoundationTokenAdjustableScale {
    public func callAsFunction(_ base: SourceValue) -> ResultValue {
        adjust(base)
    }
    public init(value: ResultValue) {
        self.init({ _ in value })
    }
}

// MARK: - Default Token Scale

/// Default size scale from `xxSmall` to `xxLarge`
public protocol FoundationTokenScaleDefault {
    static var xxSmall: Self { get }
    static var xSmall: Self { get }
    static var small: Self { get }
    static var regular: Self { get }
    static var large: Self { get }
    static var xLarge: Self { get }
    static var xxLarge: Self { get }
}

internal extension FoundationTokenScaleDefault {
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
