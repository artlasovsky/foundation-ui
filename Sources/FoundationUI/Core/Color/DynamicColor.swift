//
//  DynamicColor.swift
//
//
//  Created by Art Lasovsky on 31/05/2024.
//

import Foundation
import SwiftUI


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
        private let current: ComponentsSet
        private var source: ComponentsSet? = nil
        
        public var light: Components { current.light }
        public var dark: Components { current.dark }
        public var lightAccessible: Components { current.lightAccessible }
        public var darkAccessible: Components { current.darkAccessible }
        
        private var base: ComponentsSet { source ?? current }
        
        private var blendMode: BlendMode = .normal
        private var extendedBlendMode: ExtendedBlendMode? = nil
        
        private var colorScheme: FoundationUI.ColorScheme?
        
        let id = UUID()
    }
}

extension FoundationUI.DynamicColor: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        let colorScheme = colorScheme ?? FoundationUI.ColorScheme(environment)
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
        switch FoundationUI.ColorScheme(environment) {
        case .light:
            light.color
        case .dark:
            dark.color
        case .lightAccessible:
            lightAccessible.color
        case .darkAccessible:
            darkAccessible.color
        }
    }
}

public extension FoundationUI.DynamicColor {
    typealias Adjustment = (Components) -> Components
    /// Overrides all previous changes
    func makeVariation(
        light: Adjustment,
        dark: Adjustment,
        lightAccessible: Adjustment? = nil,
        darkAccessible: Adjustment? = nil
    ) -> Self {
        var color = Self(
            light: light(base.light),
            dark: dark(base.dark),
            lightAccessible: lightAccessible?(base.lightAccessible) ?? light(base.lightAccessible),
            darkAccessible: darkAccessible?(base.darkAccessible) ?? dark(base.darkAccessible)
        )
        color.source = base
        return color
    }
}

extension FoundationUI.DynamicColor {
    public init(
        light: Components,
        dark: Components,
        lightAccessible: Components? = nil,
        darkAccessible: Components? = nil
    ) {
        self.current = .init(
            light: light,
            dark: dark, 
            lightAccessible: lightAccessible,
            darkAccessible: darkAccessible
        )
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

extension FoundationUI.DynamicColor {
    struct ComponentsSet: Hashable {
        let light: Components
        let dark: Components
        let lightAccessible: Components
        let darkAccessible: Components
        
        init(light: Components, dark: Components, lightAccessible: Components? = nil, darkAccessible: Components? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
        
        init(_ universal: Components) {
            self.init(light: universal, dark: universal)
        }
    }
}

public extension FoundationUI.DynamicColor {
    func opacity(_ value: CGFloat) -> Self {
        .init(
            light: light.multiply(opacity: value),
            dark: dark.multiply(opacity: value),
            lightAccessible: lightAccessible.multiply(opacity: value),
            darkAccessible: darkAccessible.multiply(opacity: value)
        )
    }
    
    func brightness(_ value: CGFloat) -> Self {
        .init(
            light: light.multiply(brightness: value),
            dark: dark.multiply(brightness: value),
            lightAccessible: lightAccessible.multiply(brightness: value),
            darkAccessible: darkAccessible.multiply(brightness: value)
        )
    }
    
    func saturation(_ value: CGFloat) -> Self {
        .init(
            light: light.multiply(saturation: value),
            dark: dark.multiply(saturation: value),
            lightAccessible: lightAccessible.multiply(saturation: value),
            darkAccessible: darkAccessible.multiply(saturation: value)
        )
    }
    
    func hue(_ value: CGFloat) -> Self {
        .init(
            light: light.override(hue: value),
            dark: dark.override(hue: value),
            lightAccessible: lightAccessible.override(hue: value),
            darkAccessible: darkAccessible.override(hue: value)
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
        copy.colorScheme = colorScheme
        return copy
    }
}

// MARK: - Types

public extension FoundationUI.DynamicColor {
    enum ExtendedBlendMode: Sendable {
        case vibrant
        
        func adjustColor(_ color: FoundationUI.DynamicColor) -> FoundationUI.DynamicColor {
            switch self {
            case .vibrant:
                color
                    .makeVariation(
                        light: { _ in color.light.multiply(opacity: 0.65) },
                        dark: { _ in color.dark.multiply(opacity: 0.5) },
                        lightAccessible: { $0 },
                        darkAccessible: { $0 }
                    )                
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
        && lhs.colorScheme == rhs.colorScheme
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
