//
//  DynamicColorComponents.swift
//  
//
//  Created by Art Lasovsky on 07/03/2024.
//

import Foundation
import SwiftUI

public extension TrussUI {
    struct DynamicColorComponents: TrussUIColorComponents {
        public var hue: CGFloat { adjusted.hue }
        public var saturation: CGFloat { adjusted.saturation }
        public var brightness: CGFloat { adjusted.brightness }
        public var opacity: CGFloat { adjusted.opacity }
        
        private var adjusted: ColorComponents {
            adjustments.applyTo(initial)
        }

        private (set) var blendMode: BlendMode = .normal
        private var initial: ColorComponents
        private var adjustments = Adjustments()
        
        public init(_ colorComponents: ColorComponents) {
            initial = colorComponents
        }
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat = 1) {
            initial = .init(
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                opacity: opacity
            )
        }
        
        public func shapeStyle() -> some ShapeStyle {
            color().blendMode(blendMode)
        }
        
        internal func applyAdjustmentsTo<Components: TrussUIColorComponents>(_ components: Components) -> Components {
            adjustments.applyTo(components)
        }
        
        internal func updateAdjustmentsFrom(_ adjustments: Adjustments) -> Self {
            var copy = self
            copy.adjustments = adjustments
            return copy
        }
    }
}

public extension TrussUI.DynamicColorComponents {
    struct Adjustments: Sendable, Hashable, Equatable {
        var multiplyHue: CGFloat = 1
        var multiplySaturation: CGFloat = 1
        var multiplyBrightness: CGFloat = 1
        var multiplyOpacity: CGFloat = 1
        var overrideHue: CGFloat? = nil
        var overrideSaturation: CGFloat? = nil
        var overrideBrightness: CGFloat? = nil
        var overrideOpacity: CGFloat? = nil
        
        func applyTo<Components: TrussUIColorComponents>(_ components: Components) -> Components {
            components
                .set(
                    hue: overrideHue,
                    saturation: overrideSaturation,
                    brightness: overrideBrightness,
                    opacity: overrideOpacity
                )
                .multiply(
                    hue: multiplyHue,
                    saturation: multiplySaturation,
                    brightness: multiplyBrightness,
                    opacity: multiplyOpacity
                )
        }
    }
}

public extension TrussUI.DynamicColorComponents {
    func multiply(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, opacity: CGFloat = 1) -> Self {
        var copy = self
        copy.adjustments.multiplyHue *= hue
        copy.adjustments.multiplySaturation *= saturation
        copy.adjustments.multiplyBrightness *= brightness
        copy.adjustments.multiplyOpacity *= opacity
        return copy
    }
    
    func set(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        var copy = self
        // h:0.5 -> multiply h:0.5 -> h:0.25 -> set h:1 -> h:1 -> multiply h:0.75 -> h:0.75
        // if {value} != nil
        // set `initial.{value}`
        // reset `adjustment.{value}` to `1`
        if let hue {
            copy.adjustments.overrideHue = hue
            copy.adjustments.multiplyHue = 1
        }
        if let saturation {
            copy.adjustments.overrideSaturation = saturation
            copy.adjustments.multiplySaturation = 1
        }
        if let brightness {
            copy.adjustments.overrideBrightness = brightness
            copy.adjustments.multiplyBrightness = 1
        }
        if let opacity {
            copy.adjustments.overrideOpacity = opacity
            copy.adjustments.multiplyOpacity = 1
        }
        return copy
    }
    
    func blendMode(_ mode: BlendMode) -> Self {
        var copy = self
        copy.blendMode = mode
        return copy
    }
}

public extension TrussUI.DynamicColorComponents {
    func multiply(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, opacity: CGFloat = 1) -> Adjustments {
        multiply(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity).adjustments
    }
    func set(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, opacity: CGFloat? = nil) -> Adjustments {
        set(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity).adjustments
    }
    func opacity(_ opacity: CGFloat) -> Adjustments {
        multiply(opacity: opacity)
    }
    func hue(_ hue: CGFloat) -> Adjustments {
        multiply(hue: hue)
    }
    func saturation(_ saturation: CGFloat) -> Adjustments {
        multiply(saturation: saturation)
    }
    func brightness(_ brightness: CGFloat) -> Adjustments {
        multiply(brightness: brightness)
    }
}

public extension TrussUI.DynamicColorComponents {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hue)
        hasher.combine(saturation)
        hasher.combine(brightness)
        hasher.combine(opacity)
        hasher.combine(blendMode)
    }
}
