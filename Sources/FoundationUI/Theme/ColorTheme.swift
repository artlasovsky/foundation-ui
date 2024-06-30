//
//  ColorTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI


public protocol DynamicColorDefaults {
    typealias VariationKeyPath = KeyPath<FoundationUI.DynamicColor, FoundationUI.DynamicColor>
}

extension FoundationUI.DynamicColor: DynamicColorDefaults {}

/// Tint are static extensions of `DynamicColor`
public extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var primary: Self {
        .init(
            light: .init(grayscale: 0.5),
            dark: .init(grayscale: 0.57)
        )
    }
    
    static var clear: Self {
        .init(.init(grayscale: 0, opacity: 0))
    }
    
    static var black: Self {
        .init(.init(grayscale: 0, opacity: 1))
    }
    
    static var white: Self {
        .init(.init(grayscale: 1, opacity: 1))
    }
    
    static var gray: Self {
        .init(.init(grayscale: 0.5, opacity: 1))
    }
}

internal extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var red: Self {
        .init(
            light: .init(red8bit: 255, green: 59, blue: 48),
            dark: .init(red8bit: 255, green: 69, blue: 58)
        )
    }
}

/// Variations are extention of `DynamicColor`
public extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var environmentDefault: Self {
        primary
    }
    
    /// App background
    var backgroundFaded: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.98 : 0.97 }, method: .override)
                .saturation(0.02),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.07 : 0.05 }, method: .override)
                .saturation(0.5)
        )
    }
    /// Content background
    var background: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.975 : 0.95 }, method: .override)
                .saturation(0.06),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.18 : 0.12 }, method: .override)
        )
    }
    /// Subtle background
    var backgroundEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.96 : 0.92 }, method: .override)
                .saturation(0.1)
            ,
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.32 : 0.18 }, method: .override)
        )
    }
    /// UI element background
    var fillFaded: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.9 }, method: .override)
                .saturation(0.18),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.44 : 0.22 }, method: .override)
        )
    }
    /// Hovered UI element background
    var fill: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.94 : 0.87 }, method: .override)
                .saturation(0.35),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.49 : 0.27 }, method: .override)
                .saturation(1)
        )
    }
    /// Active / Selected UI element background
    var fillEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.92 : 0.83 }, method: .override)
                .saturation(0.5),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.54 : 0.32 }, method: .override)
                .saturation(1)
        )
    }
    /// Subtle borders and separators
    var borderFaded: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.82 : 0.77 }, method: .override)
                .saturation(0.58),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.62 : 0.4 }, method: .override)
                .saturation(1)
        )
    }
    /// UI element border and focus rings
    var border: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.78 : 0.7 }, method: .override)
                .saturation(0.8),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.7 : 0.45 }, method: .override)
                .saturation(0.99)
        )
    }
    /// Hovered UI element border
    var borderEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.7 : 0.6 }, method: .override)
                .saturation(0.9),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.76 : 0.49 }, method: .override)
                .saturation(1)
        )
    }
    /// Solid backgrounds
    var solid: Self { self }
    /// Low-contrast text
    var textFaded: Self { 
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.6 : 0.35 }, method: .override)
                .saturation(1),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.85 }, method: .override)
                .saturation(0.25)
        )
    }
    /// Normal text
    var text: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.38 : 0.24 }, method: .override)
                .saturation(0.95),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.96 : 0.95 }, method: .override)
                .saturation(0.15)
        )
    }
    /// High-contrast text
    var textEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.24 : 0.12 }, method: .override)
                .saturation(0.8)
            ,
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.97 : 0.99 }, method: .override)
                .saturation(0.05)
        )
    }
    
    var clear: Self {
        self.opacity(0)
    }
}
