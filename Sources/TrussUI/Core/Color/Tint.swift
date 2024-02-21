//
//  Tint.swift
//
//
//  Created by Art Lasovsky on 07/02/2024.
//

import Foundation
import SwiftUI

extension TrussUI {
    public struct Tint: Sendable, ShapeStyle {
        public let light: ColorComponents
        public let dark: ColorComponents
        public let lightAccessible: ColorComponents
        public let darkAccessible: ColorComponents
        
        public init(light: ColorComponents, dark: ColorComponents? = nil, lightAccessible: ColorComponents? = nil, darkAccessible: ColorComponents? = nil) {
            self.light = light
            self.dark = dark ?? self.light
            self.lightAccessible = lightAccessible ?? self.light
            self.darkAccessible = darkAccessible ?? self.dark
        }
        
        @available(macOS 14.0, *)
        public init(_ color: Color) {
            self.init(lightColor: color)
        }
        
        @available(macOS 14.0, *)
        public init(lightColor: Color, dark: Color? = nil, lightAccessible: Color? = nil, darkAccessible: Color? = nil) {
            self.light = .init(color: lightColor, colorScheme: .light)
            self.dark = .init(color: dark ?? lightColor, colorScheme: .dark)
            self.lightAccessible = .init(color: lightAccessible ?? lightColor, colorScheme: .lightAccessible)
            self.darkAccessible = .init(color: darkAccessible ?? dark ?? lightColor, colorScheme: .darkAccessible)
        }
        
        public func resolve(in environment: EnvironmentValues) -> Color {
            resolve(in: TrussUI.ColorScheme(environment))
        }
        
        public func resolve(in colorScheme: TrussUI.ColorScheme) -> Color {
            resolveComponents(in: colorScheme).color
        }
        
        public func resolveComponents(in environment: EnvironmentValues) -> ColorComponents {
            resolveComponents(in: TrussUI.ColorScheme(environment))
        }
        
        public func resolveComponents(in colorScheme: TrussUI.ColorScheme) -> ColorComponents {
            switch colorScheme {
            case .light:
                return light
            case .dark:
                return dark
            case .lightAccessible:
                return lightAccessible
            case .darkAccessible:
                return darkAccessible
            }
        }
    }
}

extension TrussUI.Tint: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.light == rhs.light &&
        lhs.dark == rhs.dark &&
        lhs.lightAccessible == rhs.lightAccessible &&
        lhs.darkAccessible == rhs.darkAccessible
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.resolve(in: .light))
        hasher.combine(self.resolve(in: .dark))
        hasher.combine(self.resolve(in: .lightAccessible))
        hasher.combine(self.resolve(in: .darkAccessible))
    }
}

public extension TrussUI.Tint {
    typealias ColorComponents = TrussUI.ColorComponents
    typealias Adjust = @Sendable (ColorComponents) -> ColorComponents
    
    func adjusted(
        light: Adjust,
        dark: Adjust? = nil,
        lightAccessible: Adjust? = nil,
        darkAccessible: Adjust? = nil
    ) -> Self {
        .init(
            light: light(self.light),
            dark: dark?(self.dark),
            lightAccessible: lightAccessible?(self.lightAccessible),
            darkAccessible: darkAccessible?(self.darkAccessible)
        )
    }
    
    func hue(_ value: CGFloat?) -> Self {
        var copy = self
        copy = copy.hue(light: value, dark: value)
        return copy
    }
    
    func hue(light: CGFloat?, dark: CGFloat?, lightAccessible: CGFloat? = nil, darkAccessible: CGFloat? = nil) -> Self {
        var copy = self
        copy = copy.adjusted(
            light: { $0.set(hue: light) },
            dark: { $0.set(hue: dark) },
            lightAccessible: { $0.set(hue: lightAccessible ?? light) },
            darkAccessible: { $0.set(hue: darkAccessible ?? dark) })
        return copy
    }
    
    func saturation(_ value: CGFloat?) -> Self {
        var copy = self
        copy = copy.saturation(light: value, dark: value)
        return copy
    }
    
    func saturation(light: CGFloat?, dark: CGFloat?, lightAccessible: CGFloat? = nil, darkAccessible: CGFloat? = nil) -> Self {
        var copy = self
        copy = copy.adjusted(
            light: { $0.set(saturation: light) },
            dark: { $0.set(saturation: dark) },
            lightAccessible: { $0.set(saturation: lightAccessible ?? light) },
            darkAccessible: { $0.set(saturation: darkAccessible ?? dark) })
        return copy
    }
    
    func brightness(_ value: CGFloat?) -> Self {
        var copy = self
        copy = copy.brightness(light: value, dark: value)
        return copy
    }
    
    func brightness(light: CGFloat?, dark: CGFloat?, lightAccessible: CGFloat? = nil, darkAccessible: CGFloat? = nil) -> Self {
        var copy = self
        copy = copy.adjusted(
            light: { $0.set(brightness: light) },
            dark: { $0.set(brightness: dark) },
            lightAccessible: { $0.set(brightness: lightAccessible ?? light) },
            darkAccessible: { $0.set(brightness: darkAccessible ?? dark) })
        return copy
    }
    
    func opacity(_ value: CGFloat?) -> Self {
        var copy = self
        copy = copy.opacity(light: value, dark: value)
        return copy
    }
    
    func opacity(light: CGFloat?, dark: CGFloat?, lightAccessible: CGFloat? = nil, darkAccessible: CGFloat? = nil) -> Self {
        var copy = self
        copy = copy.adjusted(
            light: { $0.set(hue: nil, alpha: light) },
            dark: { $0.set(hue: nil, alpha: dark) },
            lightAccessible: { $0.set(hue: nil, alpha: lightAccessible ?? light) },
            darkAccessible: { $0.set(hue: nil, alpha: darkAccessible ?? dark) })
        return copy
    }
    
    func colorScheme(_ colorScheme: TrussUI.ColorScheme) -> Self {
        switch colorScheme {
        case .light:
            return Self(light: light)
        case .dark:
            return Self(light: dark)
        case .lightAccessible:
            return Self(light: lightAccessible)
        case .darkAccessible:
            return Self(light: darkAccessible)
        }
    }
}

public extension TrussUI.Tint {
    @ViewBuilder
    func swatch(showValues: ColorComponents.ShowValues? = .none) -> some View {
        Swatch(tint: self, showValues: showValues)
    }
    
    private struct Swatch: View {
        let tint: TrussUI.Tint
        let showValues: ColorComponents.ShowValues?
        @ViewBuilder
        func resolvedIn(colorScheme: ColorScheme, colorSchemeContrast: ColorSchemeContrast) -> some View {
            TrussUI.Component.roundedRectangle(.regular)
                .theme().size(.small)
                .foregroundStyle(tint.resolve(in: .init(colorScheme: colorScheme, colorSchemeContrast: colorSchemeContrast)))
        }
        var body: some View {
            HStack {
                VStack {
                    tint.light.swatch(showValues: showValues)
                        .overlay(alignment: .leading) { resolvedIn(colorScheme: .light, colorSchemeContrast: .standard) }
                }
                VStack {
                    tint.dark.swatch(showValues: showValues)
                        .overlay(alignment: .leading) { resolvedIn(colorScheme: .dark, colorSchemeContrast: .standard) }
                }
                VStack {
                    tint.lightAccessible.swatch(showValues: showValues)
                        .overlay(alignment: .leading) { resolvedIn(colorScheme: .light, colorSchemeContrast: .increased) }
                }
                VStack {
                    tint.darkAccessible.swatch(showValues: showValues)
                        .overlay(alignment: .leading) { resolvedIn(colorScheme: .dark, colorSchemeContrast: .increased) }
                }
            }
        }
    }
}
