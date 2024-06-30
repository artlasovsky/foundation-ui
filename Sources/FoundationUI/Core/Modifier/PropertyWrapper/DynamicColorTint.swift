//
//  DynamicTint.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

//@propertyWrapper
//public struct DynamicColorTint: DynamicProperty {
//    @Environment(\.dynamicColorTint) private var dynamicTint
//    private var value: FoundationUI.DynamicColor?
//    private var keyPath: FoundationUI.DynamicColor.VariationKeyPath?
//    
//    public var wrappedValue: FoundationUI.DynamicColor {
//        let tint = value ?? dynamicTint
//        if let keyPath {
//            return tint[keyPath: keyPath]
//        }
//        return tint
//        
//    }
//    
//    public init() {
//        self.value = nil
//        self.keyPath = nil
//    }
//    
//    public init(_ tint: FoundationUI.DynamicColor?, keyPath: FoundationUI.DynamicColor.VariationKeyPath? = nil) {
//        self.value = tint
//        self.keyPath = keyPath
//    }
//}

// MARK: Environment

private struct DynamicColorTintKey: EnvironmentKey {
    static var defaultValue: FoundationUI.DynamicColor = .environmentDefault
}

extension EnvironmentValues {
    var dynamicColorTint: FoundationUI.DynamicColor {
        get { self[DynamicColorTintKey.self] }
        set { self[DynamicColorTintKey.self] = newValue }
    }
}
