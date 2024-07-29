//
//  DynamicColor.swift
//
//
//  Created by Art Lasovsky on 31/05/2024.
//

import Foundation
import SwiftUI

@frozen
public struct DynamicColor {
    public typealias Components = ColorComponents
    
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

// MARK: Resolve Components

public extension DynamicColor {
    func resolveComponents(in colorScheme: FoundationColorScheme) -> ColorComponents {
        switch colorScheme {
        case .light: light
        case .dark: dark
        case .lightAccessible: lightAccessible
        case .darkAccessible: darkAccessible
        }
    }
}

// MARK: Resolve ShapeStyle

extension DynamicColor: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        let colorScheme = FoundationColorScheme(environment)
        
        let components = resolveComponents(in: colorScheme)
        
        let blendMode = extendedBlendMode?.resolve(in: colorScheme) ?? blendMode
        
        return components.resolve(in: environment).blendMode(blendMode)
    }
    
}

// MARK: Resolve Color

public extension DynamicColor {
    func resolveColor(in environment: EnvironmentValues) -> Color {
        let colorScheme = FoundationColorScheme(environment)
        return resolveComponents(in: colorScheme).color
    }
    
    func resolveCGColor(in environment: EnvironmentValues) -> CGColor {
        let colorScheme = FoundationColorScheme(environment)
        return resolveComponents(in: colorScheme).cgColor()
    }
    
    #if os(macOS)
    func resolveNSColor() -> NSColor {
        .init(name: nil) { appearance in
            let components: ColorComponents
            switch appearance.name {
            case .aqua, .vibrantLight:
                components = light
            case .darkAqua, .vibrantDark:
                components = dark
            case .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
                components = lightAccessible
            case .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                components = darkAccessible
            default:
                components = light
            }
            return components.nsColor()
        }
    }
    #elseif os(iOS)
    func resolveUIColor() -> UIColor {
        .init { uiTrait in
            let components: ColorComponents
            switch (uiTrait.userInterfaceStyle, uiTrait.accessibilityContrast) {
            case (.light, .normal), (.light, .unspecified):
                components = light
            case (.dark, .normal), (.light, .unspecified):
                components = dark
            case (.light, .high):
                components = lightAccessible
            case (.dark, .high):
                components = darkAccessible
            default:
                components = light
            }
            return components.uiColor()
        }
    }
    #endif
}

// MARK: - Initializers

public extension DynamicColor {
    init(
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
    
    init(_ universal: Components) {
        self.init(light: universal, dark: universal)
    }
    
    static func from(color: Color) -> DynamicColor {
        .init(
            light: .init(color: color, colorScheme: .light),
            dark: .init(color: color, colorScheme: .dark),
            lightAccessible: .init(color: color, colorScheme: .lightAccessible),
            darkAccessible: .init(color: color, colorScheme: .darkAccessible)
        )
    }
    
    #if os(macOS)
    static func from(nsColor: NSColor) -> DynamicColor {
        .init(
            light: .init(nsColor: nsColor, colorScheme: .light),
            dark: .init(nsColor: nsColor, colorScheme: .dark),
            lightAccessible: .init(nsColor: nsColor, colorScheme: .lightAccessible),
            darkAccessible: .init(nsColor: nsColor, colorScheme: .darkAccessible)
        )
    }
    #elseif os(iOS)
    static func from(uiColor: UIColor) -> DynamicColor {
        .init(
            light: .init(uiColor: uiColor, colorScheme: .light),
            dark: .init(uiColor: uiColor, colorScheme: .dark),
            lightAccessible: .init(uiColor: uiColor, colorScheme: .lightAccessible),
            darkAccessible: .init(uiColor: uiColor, colorScheme: .darkAccessible)
        )
    }
    
    #endif
}

// MARK: - Modifiers

public extension DynamicColor {
    func hue(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.hue(value, method: method)
        copy.dark = dark.hue(value, method: method)
        copy.lightAccessible = lightAccessible.hue(value, method: method)
        copy.darkAccessible = darkAccessible.hue(value, method: method)
        
        return copy
    }
    
    func hue(dynamic value: @escaping Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.hue(dynamic: value, method: method)
        copy.dark = dark.hue(dynamic: value, method: method)
        copy.lightAccessible = lightAccessible.hue(dynamic: value, method: method)
        copy.darkAccessible = darkAccessible.hue(dynamic: value, method: method)
        
        return copy
    }
    
    func saturation(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.saturation(value, method: method)
        copy.dark = dark.saturation(value, method: method)
        copy.lightAccessible = lightAccessible.saturation(value, method: method)
        copy.darkAccessible = darkAccessible.saturation(value, method: method)
        
        return copy
    }
    
    func saturation(dynamic value: @escaping Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.saturation(dynamic: value, method: method)
        copy.dark = dark.saturation(dynamic: value, method: method)
        copy.lightAccessible = lightAccessible.saturation(dynamic: value, method: method)
        copy.darkAccessible = darkAccessible.saturation(dynamic: value, method: method)
        
        return copy
    }
    
    func brightness(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.brightness(value, method: method)
        copy.dark = dark.brightness(value, method: method)
        copy.lightAccessible = lightAccessible.brightness(value, method: method)
        copy.darkAccessible = darkAccessible.brightness(value, method: method)
        
        return copy
    }
    
    func brightness(dynamic value: @escaping Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.brightness(dynamic: value, method: method)
        copy.dark = dark.brightness(dynamic: value, method: method)
        copy.lightAccessible = lightAccessible.brightness(dynamic: value, method: method)
        copy.darkAccessible = darkAccessible.brightness(dynamic: value, method: method)
        
        return copy
    }
    
    func opacity(_ value: CGFloat, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.opacity(value, method: method)
        copy.dark = dark.opacity(value, method: method)
        copy.lightAccessible = lightAccessible.opacity(value, method: method)
        copy.darkAccessible = darkAccessible.opacity(value, method: method)
        
        return copy
    }
    
    func opacity(dynamic value: @escaping Components.ConditionalValue, method: Components.AdjustMethod = .multiply) -> Self {
        var copy = self
        
        copy.light = light.opacity(dynamic: value, method: method)
        copy.dark = dark.opacity(dynamic: value, method: method)
        copy.lightAccessible = lightAccessible.opacity(dynamic: value, method: method)
        copy.darkAccessible = darkAccessible.opacity(dynamic: value, method: method)
        
        return copy
    }
}

public extension DynamicColor {
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
    
    func colorScheme(_ colorScheme: FoundationColorScheme) -> Self {
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
        return copy
    }
}

// MARK: - Types

public extension DynamicColor {
    enum ExtendedBlendMode: Sendable, Hashable {
        case vibrant
        
        func adjustColor(_ color: DynamicColor) -> DynamicColor {
            switch self {
            case .vibrant:
                var copy = color
                copy.light = copy.light.opacity(0.8)
                copy.dark = copy.dark.opacity(0.65)
                return copy
            }
        }
        
        func resolve(in colorScheme: FoundationColorScheme) -> BlendMode? {
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

extension DynamicColor: Hashable {}

extension DynamicColor: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.light == rhs.light
        && lhs.dark == rhs.dark
        && lhs.lightAccessible == rhs.lightAccessible
        && lhs.darkAccessible == rhs.darkAccessible
        && lhs.blendMode == rhs.blendMode
        && lhs.extendedBlendMode == rhs.extendedBlendMode
    }
}

extension DynamicColor: CustomDebugStringConvertible {
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
