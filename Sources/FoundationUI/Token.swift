//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

public struct TokenizedValues<V:Hashable> {
    private let xs: V
    private let sm: V
    private let base: V
    private let lg: V
    private let xl: V
    public init(xs: V, sm: V, base: V, lg: V, xl: V) {
        self.xs = xs
        self.sm = sm
        self.base = base
        self.lg = lg
        self.xl = xl
    }
    public func get(_ token: Token<V>) -> V {
        switch token {
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
//    public func get(_ token: Token<some Hashable>) -> V {
//        switch token {
//        case .xs:
//            return xs
//        case .sm:
//            return sm
//        case .base:
//            return base
//        case .lg:
//            return lg
//        case .xl:
//            return xl
//        case .custom(_):
//            return base
//        }
//    }
}

public enum Token<V:Hashable>: Hashable {
    case xs
    case sm
    case base
    case lg
    case xl
    case custom(_ value: V)
}
