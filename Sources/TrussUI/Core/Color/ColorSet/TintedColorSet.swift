//
//  TintedColorSet.swift
//  
//
//  Created by Art Lasovsky on 07/03/2024.
//

import Foundation
import SwiftUI

public extension TrussUI {
    struct TintedColorSet: TrussUIColorSet {
        public typealias Adjust = @Sendable (Components) -> Components.Adjustments
        public var light: Components { components(.light) }
        public var dark: Components { components(.dark) }
        public var lightAccessible: Components { components(.lightAccessible) }
        public var darkAccessible: Components { components(.darkAccessible) }
        
        public var colorScheme: TrussUI.ColorScheme?
        
        private var tint: TrussUI.ColorSet
        
        private var tintIsLocked: Bool = false
        
        private var lightAdjust: Adjust?
        private var darkAdjust: Adjust?
        private var lightAccessibleAdjust: Adjust?
        private var darkAccessibleAdjust: Adjust?
        
        public init(light: Components, dark: Components, lightAccessible: Components? = nil, darkAccessible: Components? = nil) {
            tint = .init(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        }
        
        private init(_ colorSet: TrussUI.ColorSet) {
            self.tint = colorSet
        }
    }
}

public extension TrussUI.TintedColorSet {
    func blendMode(_ blendMode: BlendMode) -> TrussUI.TintedColorSet {
        var copy = self
        copy.tint = .init(
            light: tint.light.blendMode(blendMode),
            dark: tint.dark.blendMode(blendMode),
            lightAccessible: tint.lightAccessible.blendMode(blendMode),
            darkAccessible: tint.darkAccessible.blendMode(blendMode)
        )
        return copy
    }
}

public extension TrussUI.TintedColorSet {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        var colorSet = self
        if !tintIsLocked, let envTint = environment.trussUITint {
            colorSet.tint = envTint
        }
        return colorSet.components(.init(environment)).shapeStyle()
    }
    
    func components(_ colorScheme: TrussUI.ColorScheme) -> Components {
        let colorScheme = self.colorScheme ?? colorScheme
        var components = tint.components(colorScheme)
        let adjust = switch colorScheme {
        case .light: lightAdjust
        case .dark: darkAdjust
        case .lightAccessible: lightAccessibleAdjust
        case .darkAccessible: darkAccessibleAdjust
        }
        if let adjust {
            components = adjust(components).applyTo(components)
        }
        return components
    }
}

public extension TrussUI.TintedColorSet {
    func lockTint(_ lock: Bool) -> Self {
        var copy = self
        copy.tintIsLocked = lock
        return copy
    }
    static func tint(_ colorSet: TrussUI.ColorSet) -> Self {
        .init(colorSet)
    }
    
    func tint(_ colorSet: TrussUI.ColorSet) -> Self {
        var copy = self
        copy.tint = colorSet
        return copy.lockTint(true)
    }
}

public extension TrussUI.TintedColorSet {
    func adjust(light: @escaping Adjust, dark: @escaping Adjust, lightAccessible: Adjust? = nil, darkAccessible: Adjust? = nil) -> Self {
        var copy = self
        copy.lightAdjust = light
        copy.darkAdjust = dark
        copy.lightAccessibleAdjust = lightAccessible ?? light
        copy.darkAccessibleAdjust = darkAccessible ?? dark
        return copy
    }
    
    func adjust(_ universal: @escaping Adjust) -> Self {
        adjust(light: universal, dark: universal, lightAccessible: universal, darkAccessible: universal)
    }
    
    func hue(_ hue: Double) -> Self {
        adjust { $0.hue(hue) }
    }
    
    func saturation(_ saturation: Double) -> Self {
        adjust { $0.saturation(saturation) }
    }
    
    func brightness(_ brightness: Double) -> Self {
        adjust { $0.brightness(brightness) }
    }
    
    func opacity(_ opacity: Double) -> Self {
        adjust { $0.opacity(opacity) }
    }
}

public extension TrussUI.TintedColorSet {
    func hash(into hasher: inout Hasher) {
        hasher.combine(light)
        hasher.combine(dark)
        hasher.combine(lightAccessible)
        hasher.combine(darkAccessible)
        
        hasher.combine(lightAdjust?(light))
        hasher.combine(darkAdjust?(dark))
        hasher.combine(lightAccessibleAdjust?(lightAccessible))
        hasher.combine(darkAccessibleAdjust?(darkAccessible))
    }
}
