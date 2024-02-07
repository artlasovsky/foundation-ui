//
//  Variable.swift
//
//
//  Created by Art Lasovsky on 18/01/2024.
//

import Foundation
import SwiftUI

public protocol VariableValue: Hashable, Equatable {
    associatedtype Value
    var value: Value { get }
    var label: String? { get }
    
    init(value: Value, label: String?)
}

public extension VariableValue {
    init(_ value: Value, label: String? = nil) {
        self.init(value: value, label: label)
    }
    init(_ value: Value, _ label: String? = nil) {
        self.init(value: value, label: label)
    }
}

public protocol VariableScale: VariableValue {
    static var xxSmall: Self { get }
    static var xSmall: Self { get }
    static var small: Self { get }
    static var regular: Self { get }
    static var large: Self { get }
    static var xLarge: Self { get }
    static var xxLarge: Self { get }
}
