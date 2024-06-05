//
//  DynamicTint.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct DynamicColorTint: DynamicProperty {
    @Environment(\.dynamicColorTint) private var dynamicTint
    private var value: TrussUI.DynamicColor?
    private var keyPath: TrussUI.DynamicColor.VariationKeyPath?
    
    public var wrappedValue: TrussUI.DynamicColor {
        let tint = value ?? dynamicTint
        if let keyPath {
            return tint[keyPath: keyPath]
        }
        return tint
        
    }
    
    public init() {
        self.value = nil
        self.keyPath = nil
    }
    
    public init(_ tint: TrussUI.DynamicColor?, keyPath: TrussUI.DynamicColor.VariationKeyPath? = nil) {
        self.value = tint
        self.keyPath = keyPath
    }
}

// MARK: Environment

private struct DynamicColorTintKey: EnvironmentKey {
    static var defaultValue: TrussUI.DynamicColor = .environmentDefault
}

extension EnvironmentValues {
    var dynamicColorTint: TrussUI.DynamicColor {
        get { self[DynamicColorTintKey.self] }
        set { self[DynamicColorTintKey.self] = newValue }
    }
}
