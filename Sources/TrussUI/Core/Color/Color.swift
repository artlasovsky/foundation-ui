//
//  File.swift
//  
//
//  Created by Art Lasovsky on 25/02/2024.
//

import Foundation
import SwiftUI

public extension Color {
    static func truss(_ variable: TrussUI.ColorVariable) -> Color {
        variable.color()
    }
    static func truss(scale: TrussUI.ColorScale) -> Color {
        scale.color()
    }
}

public extension ShapeStyle where Self == TrussUI.ColorVariable {
    static func truss(_ variable: Self) -> Self {
        variable
    }
}

public extension ShapeStyle where Self == TrussUI.ColorScale {
    static func truss(scale: Self) -> Self {
        scale
    }
}

public protocol TrussUIColor: ShapeStyle, Hashable, Equatable, Sendable {
    typealias Adjust = (TrussUI.ColorComponents) -> TrussUI.ColorComponents
    
    var light: TrussUI.ColorComponents { get }
    var dark: TrussUI.ColorComponents { get }
    var lightAccessible: TrussUI.ColorComponents { get }
    var darkAccessible: TrussUI.ColorComponents { get }
    
    init(light: TrussUI.ColorComponents, dark: TrussUI.ColorComponents, lightAccessible: TrussUI.ColorComponents?, darkAccessible: TrussUI.ColorComponents?)
    init(light: Self, dark: Self, lightAccessible: Self?, darkAccessible: Self?)
    
    func adjust(_ universal: Adjust) -> Self
    func adjust(light: Adjust, dark: Adjust, lightAccessible: Adjust?, darkAccessible: Adjust?) -> Self
    
    var componentOverride: TrussUI.ColorComponents.Override { get set }
    
    func colorScheme(_ colorScheme: TrussUI.ColorScheme) -> Self
}

public extension TrussUIColor {
    init(_ universal: TrussUI.ColorComponents) {
        self.init(light: universal, dark: universal, lightAccessible: universal, darkAccessible: universal)
    }
    
    init(light: Self, dark: Self, lightAccessible: Self? = nil, darkAccessible: Self? = nil) {
        self.init(
            light: light.componentsWithOverrides(in: .light),
            dark: dark.componentsWithOverrides(in: .dark),
            lightAccessible: lightAccessible?.componentsWithOverrides(in: .lightAccessible),
            darkAccessible: darkAccessible?.componentsWithOverrides(in: .darkAccessible)
        )
    }
    
    init(trussUIColor: some TrussUIColor) {
        self.init(
            light: trussUIColor.light,
            dark: trussUIColor.dark,
            lightAccessible: trussUIColor.lightAccessible,
            darkAccessible: trussUIColor.darkAccessible)
        self.componentOverride = trussUIColor.componentOverride
    }
}

@available(macOS 14.0, *)
public extension TrussUIColor {
    init(color: Color) {
        self.init(lightColor: color)
    }
    
    init(lightColor: Color, dark: Color? = nil, lightAccessible: Color? = nil, darkAccessible: Color? = nil) {
        let dark = dark ?? lightColor
        let lightAccessible = lightAccessible ?? lightColor
        let darkAccessible = darkAccessible ?? dark
        self.init(
            light: .init(color: lightColor, colorScheme: .light),
            dark: .init(color: dark, colorScheme: .dark),
            lightAccessible: .init(color: lightAccessible, colorScheme: .lightAccessible),
            darkAccessible: .init(color: darkAccessible, colorScheme: .darkAccessible))
    }
}

public extension TrussUIColor {
    func adjust(_ universal: Adjust) -> Self {
        .init(
            light: universal(self.light),
            dark: universal(self.dark),
            lightAccessible: universal(self.lightAccessible),
            darkAccessible: universal(self.darkAccessible)
        )
    }
    func adjust(light: Adjust, dark: Adjust, lightAccessible: Adjust? = nil, darkAccessible: Adjust? = nil) -> Self {
        .init(
            light: light(self.light),
            dark: dark(self.dark),
            lightAccessible: lightAccessible?(self.lightAccessible) ?? light(self.lightAccessible),
            darkAccessible: darkAccessible?(self.darkAccessible) ?? dark(self.darkAccessible)
        )
    }
}

public extension TrussUIColor {
    func resolve(in environment: EnvironmentValues) -> Color {
        // Extract ColorScheme from the environment
        let colorScheme = TrussUI.ColorScheme(environment)
        if let environmentTint = environment.TrussUITint {
            return applyCurrentTintOverrides(to: environmentTint).resolve(in: colorScheme)
        } else {
            return resolve(in: colorScheme)
        }
    }
    
    func resolve(in colorScheme: TrussUI.ColorScheme) -> Color {
        componentsWithOverrides(in: colorScheme).color
    }
    
    func components(_ environment: EnvironmentValues) -> TrussUI.ColorComponents {
        components(colorScheme: TrussUI.ColorScheme(environment))
    }
    
    func components(colorScheme: TrussUI.ColorScheme) -> TrussUI.ColorComponents {
        componentsWithOverrides(in: colorScheme)
    }
    
    private func componentsWithOverrides(in colorScheme: TrussUI.ColorScheme) -> TrussUI.ColorComponents {
        let tint = componentOverride.tint ?? self
        let tintWithOverrides = applyCurrentTintOverrides(to: tint)
        return tintWithOverrides.resolveComponents(in: componentOverride.colorScheme ?? colorScheme)
    }

    private func resolveComponents(in colorScheme: TrussUI.ColorScheme) -> TrussUI.ColorComponents {
        switch colorScheme {
        case .light:
            light
        case .dark:
            dark
        case .lightAccessible:
            lightAccessible
        case .darkAccessible:
            darkAccessible
        }
    }
}

public extension TrussUIColor {
    /// Returns ``SwiftUI/Color`` value which will adjust to the View's Environment
    ///
    /// > Important: In the SwiftUI Previews accessible colors will only will be visible when it is set in system settings
    func color() -> Color {
        .init(nsColor: .init(name: nil, dynamicProvider: { appearance in
            return .init(self.color(TrussUI.ColorScheme(appearance: appearance)))
        }))
    }
    func color(_ environment: EnvironmentValues) -> Color {
        color(TrussUI.ColorScheme(environment))
    }
    func color(_ colorScheme: TrussUI.ColorScheme) -> Color {
        switch colorScheme {
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

public extension TrussUIColor {
    func hash(into hasher: inout Hasher) {
        hasher.combine(light)
        hasher.combine(dark)
        hasher.combine(lightAccessible)
        hasher.combine(darkAccessible)
        hasher.combine(componentOverride)
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

public extension TrussUI {
    struct ColorVariable: TrussUIColor {
        public var light: TrussUI.ColorComponents
        public var dark: TrussUI.ColorComponents
        public var lightAccessible: TrussUI.ColorComponents
        public var darkAccessible: TrussUI.ColorComponents
        
        public var componentOverride: TrussUI.ColorComponents.Override = .init()
        
        public init(light: TrussUI.ColorComponents, dark: TrussUI.ColorComponents, lightAccessible: TrussUI.ColorComponents? = nil, darkAccessible: TrussUI.ColorComponents? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
        
        public func scale<S: TrussUIColor>(_ value: TrussUI.ColorScale) -> S {
            .init(trussUIColor: value)
        }
        
        public static func scale<S: TrussUIColor>(_ value: TrussUI.ColorScale) -> S {
            .init(trussUIColor: value)
        }
    }
    struct ColorScale: TrussUIColor {
        public var light: TrussUI.ColorComponents
        public var dark: TrussUI.ColorComponents
        public var lightAccessible: TrussUI.ColorComponents
        public var darkAccessible: TrussUI.ColorComponents
        
        public var componentOverride: TrussUI.ColorComponents.Override = .init()
        
        public init(tint: TrussUI.ColorVariable) {
            self.light = tint.light
            self.dark = tint.dark
            self.lightAccessible = tint.lightAccessible
            self.darkAccessible = tint.darkAccessible
        }
        
        public init(light: TrussUI.ColorComponents, dark: TrussUI.ColorComponents, lightAccessible: TrussUI.ColorComponents? = nil, darkAccessible: TrussUI.ColorComponents? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
        
        /// Overrides the base tint.
        public func tint<S: TrussUIColor>(_ color: TrussUI.ColorVariable) -> S {
            var copy = self
            copy.componentOverride.tint = color
            return .init(trussUIColor: copy)
        }
        
        public static func tint<S: TrussUIColor>(_ color: TrussUI.ColorVariable) -> S {
            .init(trussUIColor: color)
        }
    }
}

public extension TrussUI.ColorComponents {
    struct Override: Sendable {
        var hue: CGFloat = 1
        var saturation: CGFloat = 1
        var brightness: CGFloat = 1
        var alpha: CGFloat = 1
        
        var colorScheme: TrussUI.ColorScheme? = nil
        var tint: (any TrussUIColor)? = nil
    }
}

extension TrussUI.ColorComponents.Override: Hashable, Equatable {
    public static func == (lhs: TrussUI.ColorComponents.Override, rhs: TrussUI.ColorComponents.Override) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hue)
        hasher.combine(saturation)
        hasher.combine(brightness)
        hasher.combine(alpha)
        hasher.combine(colorScheme)
        if let tint {
            hasher.combine(tint)
        }
    }
}

public extension TrussUIColor {
    private func applyCurrentTintOverrides(to tint: some TrussUIColor) -> some TrussUIColor {
        tint.adjust({ $0.multiplied(
            hue: componentOverride.hue,
            saturation: componentOverride.saturation,
            brightness: componentOverride.brightness, 
            alpha: componentOverride.alpha
        ) })
    }
    
    /// Multiplies the opacity of the color by the given amount.
    func opacity(_ opacity: Double) -> Self {
        var copy = self
        copy.componentOverride.alpha = opacity
        return copy
    }
    /// Multiplies the hue of the color by the given amount.
    func hue(_ hue: Double) -> Self {
        var copy = self
        copy.componentOverride.hue = hue
        return copy
    }
    /// Multiplies the saturation of the color by the given amount.
    func saturation(_ saturation: Double) -> Self {
        var copy = self
        copy.componentOverride.saturation = saturation
        return copy
    }
    /// Multiplies the brightness of the color by the given amount.
    func brightness(_ brightness: Double) -> Self {
        var copy = self
        copy.componentOverride.brightness = brightness
        return copy
    }
    /// Overrides the color scheme.
    func colorScheme(_ colorScheme: TrussUI.ColorScheme) -> Self {
        var copy = self
        copy.componentOverride.colorScheme = colorScheme
        return copy
    }
}

// MARK: - EnvironmentValues

private struct TrussUITintKey: EnvironmentKey {
    static let defaultValue: TrussUI.ColorVariable? = nil
}

internal extension EnvironmentValues {
    var TrussUITint: TrussUI.ColorVariable? {
        get { self[TrussUITintKey.self] }
        set { self[TrussUITintKey.self] = newValue }
    }
}

internal extension EnvironmentValues {
    init(colorScheme: ColorScheme, colorSchemeContrast: ColorSchemeContrast) {
        var env = EnvironmentValues()
        env.colorScheme = colorScheme
        env._colorSchemeContrast = colorSchemeContrast
        self = env
    }
}

// MARK: - Preview

internal extension TrussUI.ColorVariable {
    static let test = Self(
        light: .init(hue: 0, saturation: 0.8, brightness: 1), // red
        dark: .init(hue: 0.2, saturation: 0.8, brightness: 1) // green
    )
    
    static let tint = Self(.init(hue: 0.7, saturation: 0.6, brightness: 1))
    
    static let mix = Self(
        light: .test.opacity(0.5).colorScheme(.dark),
//        dark: .tint.opacity(0.5),
        dark: .primary.scale(.background),
        lightAccessible: .test.colorScheme(.dark).opacity(0.2),
        darkAccessible: .tint.brightness(1.2)
    )
    
    static let split = Self(
        light: .scale(.text.opacity(0.5)),
        dark: .scale(.text.opacity(0.5).colorScheme(.light))
    )
}

fileprivate extension TrussUI.Variable.Font {
    static let colorSwatch = Self(value: .system(size: 8, design: .rounded), label: "colorSwatch")
}

private struct TrussUIColorSwatch<S: TrussUIColor>: View {
    @Environment(\.self) private var environment
    let style: S
    var showValues: TrussUI.ColorComponents.ShowValues? = nil
    
    var body: some View {
        HStack (alignment: .bottom) {
            labeled()
            Divider()
                .frame(height: 40)
                .padding(.bottom, 13)
            labeled(.light)
            labeled(.dark)
            labeled(.lightAccessible)
            labeled(.darkAccessible)
        }
    }
    
    @ViewBuilder
    func labeled(_ colorScheme: TrussUI.ColorScheme? = nil) -> some View {
        let colorScheme = colorScheme ?? TrussUI.ColorScheme(environment)
        VStack {
            Text(colorScheme.rawValue)
                .truss(.font(.colorSwatch))
            style.components(colorScheme: colorScheme).swatch()
        }
    }
}

extension TrussUIColor {
    func swatch() -> some View {
        TrussUIColorSwatch(style: self)
    }
}

@available(macOS 14.0, *)
struct ColorPreview: PreviewProvider {
    struct Swatch: View {
        var body: some View {
            TrussUI.Component.roundedRectangle(.regular)
                .truss(.size(.regular))
                .truss(.foreground(.background))
                .overlay(content: {
                    Text("Text")
                        .truss(.foreground(.text))
                })
        }
    }
    static var previews: some View {
        VStack {
            VStack {
                TrussUI.ColorVariable.primary.swatch()
                TrussUI.ColorVariable(color: .gray).swatch()
            }
            HStack {
                TrussUI.Component.roundedRectangle(.regular)
                    .truss(.size(.regular))
                    .truss(.foreground(.tint(.split)))
                    .environment(\.colorScheme, .light)
                TrussUI.Component.roundedRectangle(.regular)
                    .truss(.size(.regular))
                    .truss(.foreground(.tint(.split)))
                    .environment(\.colorScheme, .dark)
            }
            HStack {
                Swatch()
                    .environment(\.colorScheme, .light)
                Swatch()
                    .environment(\.colorScheme, .dark)
            }
            HStack {
                Swatch()
                    .environment(\.colorScheme, .light)
                Swatch()
                    .environment(\.colorScheme, .dark)
            }
            HStack {
                Swatch()
                    .environment(\.colorScheme, .light)
                Swatch()
                    .environment(\.colorScheme, .dark)
            }
            .environment(\._colorSchemeContrast, .increased)
        }
        .padding()
    }
}
