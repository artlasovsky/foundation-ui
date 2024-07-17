//
//  DynamicColor.swift
//
//
//  Created by Art Lasovsky on 31/05/2024.
//

import Foundation
import SwiftUI


#warning("Update this")
/// Permanent color
/// `color: red.background`
///
/// Use environment tint
/// `@Environment(\.tint) var tint`
/// `color: tint.background`
///
/// Shortcut for environment tint (available in .foundation() modifiers)
/// `color: \.background`
///
/// /// Declare in view with property wrapper `@DynamicColorTint`
/// `@DynamicColorTint private var tint`

public extension FoundationUI {
    struct DynamicColor {
        public typealias Components = FoundationUI.ColorComponents
        
        public private(set) var light: Components
        public private(set) var dark: Components
        public private(set) var lightAccessible: Components
        public private(set) var darkAccessible: Components
        
        private var blendMode: BlendMode = .normal
        private var extendedBlendMode: ExtendedBlendMode? = nil
        
        internal func copyBlendMode(from source: Self) -> Self {
            var copy = self
            copy.blendMode = source.blendMode
            copy.extendedBlendMode = source.extendedBlendMode
            return copy
        }
    }
}

//extension FoundationUI.DynamicColor {
//    static var dynamic: Self {
//        .primary
//    }
//}

extension FoundationUI.DynamicColor: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        let colorScheme = FoundationUI.ColorScheme(environment)
        let color = switch colorScheme {
            case .light: light
            case .dark: dark
            case .lightAccessible: lightAccessible
            case .darkAccessible: darkAccessible
        }
        
        let blendMode = extendedBlendMode?.resolve(in: colorScheme) ?? blendMode
        
        return color.resolve(in: environment).blendMode(blendMode)
    }
    
    public func resolveColor(in environment: EnvironmentValues) -> Color {
        let colorScheme = FoundationUI.ColorScheme(environment)
        switch colorScheme {
        case .light:
            return light.color
        case .dark:
            return dark.color
        case .lightAccessible:
            return lightAccessible.color
        case .darkAccessible:
            return darkAccessible.color
        }
    }
}

extension FoundationUI.DynamicColor {
    public init(
        light: Components,
        dark: Components,
        lightAccessible: Components? = nil,
        darkAccessible: Components? = nil
    ) {
        self.light = light
        self.dark = dark
        self.lightAccessible = lightAccessible ?? light
        self.darkAccessible = darkAccessible ?? dark
    }
    
    public init(_ universal: Components) {
        self.init(light: universal, dark: universal)
    }
    
    @available(macOS 14.0, iOS 17.0, *)
    public static func from(color: Color) -> FoundationUI.DynamicColor {
        self.init(
            light: .init(color: color, colorScheme: .light),
            dark: .init(color: color, colorScheme: .dark),
            lightAccessible: .init(color: color, colorScheme: .lightAccessible),
            darkAccessible: .init(color: color, colorScheme: .darkAccessible)
        )
    }
}

public extension FoundationUI.DynamicColor {
    func hue(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.hue(value, method: method),
            dark: dark.hue(value, method: method),
            lightAccessible: lightAccessible.hue(value, method: method),
            darkAccessible: darkAccessible.hue(value, method: method)
        )
    }
    
    func hue(dynamic value: Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.hue(dynamic: value, method: method),
            dark: dark.hue(dynamic: value, method: method),
            lightAccessible: lightAccessible.hue(dynamic: value, method: method),
            darkAccessible: darkAccessible.hue(dynamic: value, method: method)
        )
    }
    
    func saturation(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.saturation(value, method: method),
            dark: dark.saturation(value, method: method),
            lightAccessible: lightAccessible.saturation(value, method: method),
            darkAccessible: darkAccessible.saturation(value, method: method)
        )
    }
    
    func saturation(dynamic value: Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.saturation(dynamic: value, method: method),
            dark: dark.saturation(dynamic: value, method: method),
            lightAccessible: lightAccessible.saturation(dynamic: value, method: method),
            darkAccessible: darkAccessible.saturation(dynamic: value, method: method)
        )
    }
    
    func brightness(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.brightness(value, method: method),
            dark: dark.brightness(value, method: method),
            lightAccessible: lightAccessible.brightness(value, method: method),
            darkAccessible: darkAccessible.brightness(value, method: method)
        )
    }
    
    func brightness(dynamic value: Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.brightness(dynamic: value, method: method),
            dark: dark.brightness(dynamic: value, method: method),
            lightAccessible: lightAccessible.brightness(dynamic: value, method: method),
            darkAccessible: darkAccessible.brightness(dynamic: value, method: method)
        )
    }
    
    func opacity(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.opacity(value, method: method),
            dark: dark.opacity(value, method: method),
            lightAccessible: lightAccessible.opacity(value, method: method),
            darkAccessible: darkAccessible.opacity(value, method: method)
        )
    }
    
    func opacity(dynamic value: Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        .init(
            light: light.opacity(dynamic: value, method: method),
            dark: dark.opacity(dynamic: value, method: method),
            lightAccessible: lightAccessible.opacity(dynamic: value, method: method),
            darkAccessible: darkAccessible.opacity(dynamic: value, method: method)
        )
    }
}

public extension FoundationUI.DynamicColor {
    func blendMode(_ blendMode: BlendMode) -> Self {
        var copy = self
        copy.blendMode = blendMode
        return copy
    }
    func blendMode(_ blendMode: ExtendedBlendMode) -> Self {
        var copy = blendMode.adjustColor(self)
        copy.extendedBlendMode = blendMode
        return copy
    }
    
    func colorScheme(_ colorScheme: FoundationUI.ColorScheme) -> Self {
        var copy = self
        let components: Components
        switch colorScheme {
        case .light:
            components = light
        case .dark:
            components = dark
        case .lightAccessible:
            components = lightAccessible
        case .darkAccessible:
            components = darkAccessible
        }
        copy.light = components
        copy.dark = components
        copy.lightAccessible = components
        copy.darkAccessible = components
//        copy.colorScheme = colorScheme
        return copy
    }
}

// MARK: - Types

public extension FoundationUI.DynamicColor {
    enum ExtendedBlendMode: Sendable, Hashable {
        case vibrant
        
        func adjustColor(_ color: FoundationUI.DynamicColor) -> FoundationUI.DynamicColor {
            switch self {
            case .vibrant:
                var copy = color
                copy.light = copy.light.opacity(0.65)
                copy.dark = copy.dark.opacity(0.5)
                return copy
            }
        }
        
        func resolve(in colorScheme: FoundationUI.ColorScheme) -> BlendMode? {
            switch self {
            case .vibrant:
                switch colorScheme {
                case .light:
                    return .plusDarker
                case .dark:
                    return .plusLighter
                case .lightAccessible, .darkAccessible:
                    return nil
                }
            }
        }
    }
}

// MARK: - Protocols

extension FoundationUI.DynamicColor: Hashable {}

extension FoundationUI.DynamicColor: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.light == rhs.light
        && lhs.dark == rhs.dark
        && lhs.lightAccessible == rhs.lightAccessible
        && lhs.darkAccessible == rhs.darkAccessible
        && lhs.blendMode == rhs.blendMode
        && lhs.extendedBlendMode == rhs.extendedBlendMode
    }
}

extension FoundationUI.DynamicColor: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        \(String(describing: Self.self).components(separatedBy: "_")[0])
        light: \(light)
        dark: \(dark)
        lightAccessible: \(lightAccessible)
        darkAccessible: \(darkAccessible)
        """
    }
}
