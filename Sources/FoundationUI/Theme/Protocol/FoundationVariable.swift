//
//  FoundationVariable.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

// MARK: - Variable
#warning("TODO: Tests! To make sure it's working all the time!")

public protocol FoundationVariable: Hashable {
    associatedtype Result: Hashable
    associatedtype Token
    func callAsFunction(_ token: Token) -> Result
}

public protocol FoundationVariableWithValue: FoundationVariable {
    associatedtype Value: Hashable
    var value: Value { get }
    init(value: Value)
}

public extension FoundationVariableWithValue {
    init(_ value: Value) {
        self.init(value: value)
    }
}

public enum FoundationVariableStep: CGFloat {
    case full
    case half
    case third
    case quarter
}

public extension FoundationVariableWithValue where Value: FloatingPoint {
    static func value(_ value: Value) -> Self {
        .init(value: value)
    }
    
    func up(_ step: FoundationVariableStep) -> Self {
        switch step {
        case .full:
            .init(value + value)
        case .half:
            .init(value + value / 2)
        case .third:
            .init(value + value / 3)
        case .quarter:
            .init(value + value / 4)
        }
    }
    
    func down(_ step: FoundationVariableStep) -> Self {
        let stepDown = value / 2
        switch step {
        case .full:
            return .init(value - stepDown)
        case .half:
            return .init(value - stepDown / 2)
        case .third:
            return .init(value - stepDown / 3)
        case .quarter:
            return .init(value - stepDown / 4)
        }
    }
    func negative() -> Self {
        .init(value: value * -1)
    }
}
