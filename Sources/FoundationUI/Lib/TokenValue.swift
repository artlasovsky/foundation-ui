//
//  TokenValue.swift
//  
//
//  Created by Art Lasovsky on 12/07/2024.
//

import Foundation
import SwiftUI

@propertyWrapper
struct OptionalTokenValue<V: FoundationVariable>: DynamicProperty {
    let token: V.Token?
    let value: V
    let defaultValue: V.Result?
    var wrappedValue: V.Result? {
        guard let token else { return defaultValue }
        return value(token)
    }
}

@propertyWrapper
struct TokenValue<V: FoundationVariable>: DynamicProperty {
    let token: V.Token
    let value: V
    var wrappedValue: V.Result {
        return value(token)
    }
}
