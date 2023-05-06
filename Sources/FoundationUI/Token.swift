//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

public struct TokenizedValues<V:Hashable> {
    public let none: V
    public let xs: V
    public let sm: V
    public let base: V
    public let lg: V
    public let xl: V
    public init(none: V, xs: V, sm: V, base: V, lg: V, xl: V) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.base = base
        self.lg = lg
        self.xl = xl
    }
    public func get(_ token: Token<V>) -> V {
        switch token {
        case .none:
            return none
        case .xs:
            return xs
        case .sm:
            return sm
        case .base:
            return base
        case .lg:
            return lg
        case .xl:
            return xl
        case .custom(let value):
            return value
        }
    }
}

public enum Token<V:Hashable>: Hashable {
    case none
    case xs
    case sm
    case base
    case lg
    case xl
    case custom(_ value: V)
}
