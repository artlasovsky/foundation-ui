//
//  ColorVariable.swift
//
//
//  Created by Art Lasovsky on 20/12/2023.
//

import Foundation
import SwiftUI

internal extension Color {
    typealias RGBAComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    typealias HSBAComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    @available(macOS 14.0, *)
    func rgbaComponents(in scheme: TrussUI.ColorScheme) -> RGBAComponents {
        var environment: EnvironmentValues
        switch scheme {
        case .light:
            environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        case .dark:
            environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .standard)
        case .lightAccessible:
            environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .increased)
        case .darkAccessible:
            environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .increased)
        }
        let resolved = self.resolve(in: environment)
        return (CGFloat(resolved.red), CGFloat(resolved.green), CGFloat(resolved.blue), CGFloat(resolved.opacity))
    }
}

extension TrussUI {
    public struct ColorVariable: ShapeStyle {
        private let light: TrussUI.Tint.Adjust
        private let dark: TrussUI.Tint.Adjust?
        private let lightAccessible: TrussUI.Tint.Adjust?
        private let darkAccessible: TrussUI.Tint.Adjust?
        
        private var override = Override()
        
        public init(
            light: @escaping TrussUI.Tint.Adjust,
            dark: TrussUI.Tint.Adjust? = nil,
            lightAccessible: TrussUI.Tint.Adjust? = nil,
            darkAccessible: TrussUI.Tint.Adjust? = nil
        ) {
            self.light = light
            self.dark = dark ?? light
            self.lightAccessible = lightAccessible
            self.darkAccessible = darkAccessible
        }
        
        public init(
            light: TrussUI.ColorVariable,
            dark: TrussUI.ColorVariable,
            lightAccessible: TrussUI.ColorVariable? = nil,
            darkAccessible: TrussUI.ColorVariable? = nil
        ) {
            self.light = light.light
            self.dark = dark.dark
            self.lightAccessible = lightAccessible?.lightAccessible
            self.darkAccessible = darkAccessible?.darkAccessible
            
            self.override.light = light.override.light
            self.override.dark = dark.override.dark
            self.override.lightAccessible = lightAccessible?.override.lightAccessible ?? light.override.light
            self.override.darkAccessible = darkAccessible?.override.darkAccessible ?? dark.override.dark
        }
        
        private func adjustTint(in environment: EnvironmentValues?) -> Tint {
            let override = self.override.resolve(in: environment)
            var tint = override?.tint ?? environment?.TrussUITint ?? TrussUI.Tint.primary
            if let colorScheme = override?.colorScheme {
                tint = tint.colorScheme(colorScheme)
            }
            return tint
                .adjusted(
                    light: light,
                    dark: dark,
                    lightAccessible: lightAccessible,
                    darkAccessible: darkAccessible)
                .hue(override?.hue)
                .saturation(override?.saturation)
                .brightness(override?.brightness)
                .opacity(override?.opacity)
        }
        
        public func resolve(in environment: EnvironmentValues) -> Color {
            let override = self.override.resolve(in: environment)
            return adjustTint(in: environment)
                .resolve(in: override?.colorScheme ?? TrussUI.ColorScheme(environment))
        }
        public func resolveComponents(in environment: EnvironmentValues) -> TrussUI.ColorComponents {
            let override = self.override.resolve(in: environment)
            return adjustTint(in: environment)
                .resolveComponents(in: override?.colorScheme ?? TrussUI.ColorScheme(environment))
        }
        
        // Resolving particular colorScheme ColorVariable color ignoring the environment
        public func resolve(in colorScheme: TrussUI.ColorScheme) -> Color {
            let override = self.override.resolve(in: colorScheme)
            return adjustTint(in: nil)
                .resolve(in: override?.colorScheme ?? colorScheme)
        }
        // Resolving particular colorScheme ColorVariable color components ignoring the environment
        public func resolveComponents(in colorScheme: TrussUI.ColorScheme) -> TrussUI.ColorComponents {
            let override = self.override.resolve(in: colorScheme)
            return adjustTint(in: nil)
                .resolveComponents(in: override?.colorScheme ?? colorScheme)
        }
    }
}

// MARK: - Color Scheme

extension TrussUI {
    public enum ColorScheme: Sendable {
        case light
        case dark
        case lightAccessible
        case darkAccessible
        
        init(_ environment: EnvironmentValues) {
            switch (environment.colorScheme, environment.colorSchemeContrast) {
            case (.light, .standard):
                self = .light
            case (.dark, .standard):
                self = .dark
            case (.light, .increased):
                self = .lightAccessible
            case (.dark, .increased):
                self = .darkAccessible
            default:
                self = .light
            }
        }
    }
}

// MARK: - Overrides

private extension TrussUI.ColorVariable {
    struct Override: Hashable {
        struct Properties: Hashable {
            var tint: TrussUI.Tint? = nil
            var hue: CGFloat? = nil
            var saturation: CGFloat? = nil
            var brightness: CGFloat? = nil
            var opacity: CGFloat? = nil
            var colorScheme: TrussUI.ColorScheme? = nil
        }
        var light = Properties()
        var dark = Properties()
        var lightAccessible = Properties()
        var darkAccessible = Properties()
        
        mutating func tint(_ value: TrussUI.Tint) {
            light.tint = value.colorScheme(.light)
            dark.tint = value.colorScheme(.dark)
            lightAccessible.tint = value.colorScheme(.lightAccessible)
            darkAccessible.tint = value.colorScheme(.darkAccessible)
        }
        
        mutating func hue(_ value: CGFloat) {
            light.hue = value
            dark.hue = value
            lightAccessible.hue = value
            darkAccessible.hue = value
        }
        
        mutating func saturation(_ value: CGFloat) {
            light.saturation = value
            dark.saturation = value
            lightAccessible.saturation = value
            darkAccessible.saturation = value
        }
        
        mutating func brightness(_ value: CGFloat) {
            light.brightness = value
            dark.brightness = value
            lightAccessible.brightness = value
            darkAccessible.brightness = value
        }
        
        mutating func opacity(_ value: CGFloat) {
            light.opacity = value
            dark.opacity = value
            lightAccessible.opacity = value
            darkAccessible.opacity = value
        }
        
        mutating func colorScheme(_ value: TrussUI.ColorScheme) {
            light.colorScheme = value
            dark.colorScheme = value
            lightAccessible.colorScheme = value
            darkAccessible.colorScheme = value
        }
        
        func resolve(in environment: EnvironmentValues?) -> Properties? {
            guard let environment else { return nil }
            return resolve(in: TrussUI.ColorScheme(environment))
        }
        
        func resolve(in colorScheme: TrussUI.ColorScheme?) -> Properties? {
            guard let colorScheme else { return nil }
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

public extension TrussUI.ColorVariable {
    func tint(_ tint: Tint) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.tint(tint)
        return copy
    }
    
    @available(macOS 14.0, *)
    func tintColor(_ color: Color) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.tint(Tint(color: color))
        return copy
    }
    
    func hue(_ value: CGFloat) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.hue(value)
        return copy
    }
    
    func saturation(_ value: CGFloat) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.saturation(value)
        return copy
    }
    
    func brightness(_ value: CGFloat) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.brightness(value)
        return copy
    }
    
    func opacity(_ value: CGFloat) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.opacity(value)
        return copy
    }
    
    func colorScheme(_ value: TrussUI.ColorScheme) -> TrussUI.ColorVariable {
        var copy = self
        copy.override.colorScheme(value)
        return copy
    }
}

// MARK: - ColorVariable - Equatable, Hashable

extension TrussUI.ColorVariable: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.resolve(in: .light) == rhs.resolve(in: .light) &&
        lhs.resolve(in: .dark) == rhs.resolve(in: .dark) &&
        lhs.resolve(in: .lightAccessible) == rhs.resolve(in: .lightAccessible) &&
        lhs.resolve(in: .darkAccessible) == rhs.resolve(in: .darkAccessible) &&
        lhs.override == rhs.override
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.resolve(in: .light))
        hasher.combine(self.resolve(in: .dark))
        hasher.combine(self.resolve(in: .lightAccessible))
        hasher.combine(self.resolve(in: .darkAccessible))
        hasher.combine(self.override)
    }
}

// MARK: - Swatch

public extension TrussUI.ColorVariable {
    @ViewBuilder
    func swatch(showValues: TrussUI.ColorComponents.ShowValues? = .none) -> some View {
        HStack {
            self
                .resolveComponents(in: .init(colorScheme: .light, colorSchemeContrast: .standard))
                .swatch(showValues: showValues)
            self
                .resolveComponents(in: .init(colorScheme: .dark, colorSchemeContrast: .standard))
                .swatch(showValues: showValues)
            self
                .resolveComponents(in: .init(colorScheme: .light, colorSchemeContrast: .increased))
                .swatch(showValues: showValues)
            self
                .resolveComponents(in: .init(colorScheme: .dark, colorSchemeContrast: .increased))
                .swatch(showValues: showValues)
        }
    }
}

// MARK: - Preview

@available(macOS 14.0, *)
private extension TrussUI.Tint {
    static let systemRed = TrussUI.Tint(color: .red)
    static let systemYellow = TrussUI.Tint(lightColor: .yellow)
    static let redEqual = TrussUI.Tint(
        light: .init(hue: 0.009, saturation: 0.8125, brightness: 1),
        dark: .init(red: 255 / 255, green: 59 / 255, blue: 48 / 255),
        lightAccessible: .init(color: .red, colorScheme: .lightAccessible),
        darkAccessible: .init(color: .red, colorScheme: .lightAccessible)
    )
    static let tintFromTint: TrussUI.Tint = .init(
        light: TrussUI.Tint.systemRed.light,
        dark: TrussUI.Tint.systemYellow.dark
    )
}

private extension TrussUI.Tint {
    static let red = TrussUI.Tint(
        light: .init(hue: 0.01, saturation: 0.81, brightness: 1),
        dark: .init(hue: 0.01, saturation: 0.77, brightness: 1),
        lightAccessible: .init(hue: 0.98, saturation: 1, brightness: 0.84),
        darkAccessible: .init(hue: 0.01, saturation: 0.62, brightness: 1))
}

private extension TrussUI.ColorVariable {
    static let swiftUI = TrussUI.ColorVariable(
        light: { $0 },
        dark: { $0.set(green: $0.green + 0.04, blue: $0.blue + 0.04) },
        lightAccessible: { $0.multiplied(saturation: 2, brightness: 0.84) },
        darkAccessible: { $0.multiplied(saturation: 0.76) }
    )
    
    static let mix = TrussUI.ColorVariable(
        light: TrussUI.ColorVariable.Scale.solid,
        dark: TrussUI.ColorVariable.Scale.text.opacity(0.5)
    )
}

struct ColorScaleTestPreview: PreviewProvider {
    struct ColorComponentsTest: View {
        var body: some View {
            VStack {
                TrussUI.ColorVariable.swiftUI.swatch(showValues: .rgb)
                if #available(macOS 14, *) {
                    HStack {
                        Text("Color Scheme Inheritance: ")
                        TrussUI.Component.roundedRectangle(.regular)
                            .truss(.size(.small))
                            .truss(.foreground(.Scale.solid.colorScheme(.dark)))
                            .truss(.tint(.systemRed))
                        TrussUI.Component.roundedRectangle(.regular)
                            .truss(.size(.small))
                            .truss(.foreground(.Scale.solid))
                            .truss(.tint(.systemRed.colorScheme(.dark)))
                    }
                    Text("Tint")
                    TrussUI.Tint.redEqual.swatch()
                    TrussUI.Tint.tintFromTint.swatch()
                    TrussUI.Tint.systemRed.swatch(showValues: .hsb)
                    TrussUI.Tint.red.swatch(showValues: .hsb)
                    Text("Tint: Color Scheme Override")
                    TrussUI.Tint.systemRed.colorScheme(.lightAccessible).swatch()
                    Text("Color Variable")
                    TrussUI.ColorVariable.Scale.solid.tint(.red).swatch(showValues: .hsb)
                    TrussUI.ColorVariable.Scale.solid.tint(.systemRed).swatch(showValues: .hsb)
                    TrussUI.ColorVariable.mix.tint(.systemRed).swatch()
                    TrussUI.ColorVariable.Scale.backgroundEmphasized.swatch()
                    TrussUI.ColorVariable.Scale.textFaded.swatch()
                }
            }
            .frame(height: 900)
        }
    }

    static var previews: some View {
        VStack (spacing: 0) {
            ColorComponentsTest()
        }
        .truss(.padding(.regular))
        .truss(.background())
    }
}

// MARK: EnvironmentValues

private struct TrussUITintKey: EnvironmentKey {
    static let defaultValue: TrussUI.Tint? = nil
}
private struct TrussUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

internal extension EnvironmentValues {
    var TrussUITint: TrussUI.Tint? {
        get { self[TrussUITintKey.self] }
        set { self[TrussUITintKey.self] = newValue }
    }
    var TrussUICornerRadius: CGFloat? {
        get { self[TrussUICornerRadiusKey.self] }
        set { self[TrussUICornerRadiusKey.self] = newValue }
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
