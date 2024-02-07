//
//  ColorScale.swift
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
            let tint = override?.tint ?? environment?.TrussUITint ?? TrussUI.Tint.primary
            return tint.adjusted(light: light, dark: dark, lightAccessible: lightAccessible, darkAccessible: darkAccessible)
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
        public func resolveComponents(in environment: EnvironmentValues) -> ColorComponents {
            let override = self.override.resolve(in: environment)
            return adjustTint(in: environment)
                .resolveComponents(in: override?.colorScheme ?? TrussUI.ColorScheme(environment))
        }
        
        // Resolving particula colorScheme ColorVariable color ignoring the environment
        public func resolve(in colorScheme: TrussUI.ColorScheme) -> Color {
            let override = self.override.resolve(in: colorScheme)
            return adjustTint(in: nil)
                .resolve(in: override?.colorScheme ?? colorScheme)
        }
        // Resolving particula colorScheme ColorVariable color components ignoring the environment
        public func resolveComponents(in colorScheme: TrussUI.ColorScheme) -> ColorComponents {
            let override = self.override.resolve(in: colorScheme)
            return adjustTint(in: nil)
                .resolveComponents(in: override?.colorScheme ?? colorScheme)
        }
    }
}

private extension TrussUI.ColorVariable {
    struct Override {
        struct Properties {
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
            light.tint = value
            dark.tint = value
            lightAccessible.tint = value
            darkAccessible.tint = value
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

extension TrussUI.ColorVariable: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.resolve(in: .light) == rhs.resolve(in: .light) &&
        lhs.resolve(in: .dark) == rhs.resolve(in: .dark) &&
        lhs.resolve(in: .lightAccessible) == rhs.resolve(in: .lightAccessible) &&
        lhs.resolve(in: .darkAccessible) == rhs.resolve(in: .darkAccessible)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.resolve(in: .light))
        hasher.combine(self.resolve(in: .dark))
        hasher.combine(self.resolve(in: .lightAccessible))
        hasher.combine(self.resolve(in: .darkAccessible))
    }
}

public extension TrussUI.ColorVariable {
    func tint(_ tint: Tint) -> Self {
        var copy = self
        copy.override.tint(tint)
        return copy
    }
    
    @available(macOS 14.0, *)
    func tintColor(_ color: Color) -> Self {
        var copy = self
        copy.override.tint(Tint(color))
        return copy
    }
    
    func hue(_ value: CGFloat) -> Self {
        var copy = self
        copy.override.hue(value)
        return copy
    }
    
    func saturation(_ value: CGFloat) -> Self {
        var copy = self
        copy.override.saturation(value)
        return copy
    }
    
    func brightness(_ value: CGFloat) -> Self {
        var copy = self
        copy.override.brightness(value)
        return copy
    }
    
    func opacity(_ value: CGFloat) -> Self {
        var copy = self
        copy.override.opacity(value)
        return copy
    }
    
    func colorScheme(_ value: TrussUI.ColorScheme) -> Self {
        var copy = self
        copy.override.colorScheme(value)
        return copy
    }
}

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

extension TrussUI {
    public struct ColorComponents: Sendable {
        typealias ColorComponents = Self
        public let hue: CGFloat
        public let saturation: CGFloat
        public let brightness: CGFloat
        public let alpha: CGFloat
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1) {
            self.hue = Self.clamp(hue)
            self.saturation = Self.clamp(saturation)
            self.brightness = Self.clamp(brightness)
            self.alpha = Self.clamp(alpha)
        }
        
        public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
            var nsColor = NSColor(
                red: Self.clamp(red),
                green: Self.clamp(green),
                blue: Self.clamp(blue),
                alpha: Self.clamp(alpha)
            )
            nsColor = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
            self.hue = nsColor.hueComponent
            self.saturation = nsColor.saturationComponent
            self.brightness = nsColor.brightnessComponent
            self.alpha = nsColor.alphaComponent
        }
        
        @available(macOS 14.0, *)
        public init(color: Color, colorScheme: TrussUI.ColorScheme) {
            let components = color.rgbaComponents(in: colorScheme)
            self.init(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
        }
        
    //    @available(macOS, introduced: 12.0, deprecated: 14.0, obsoleted: 14.0, renamed: "init(color:colorScheme:)")
    //    init(color: Color) {
    //        Unpredictable with Previews
    //        let nsColor = NSColor(color).usingColorSpace(.deviceRGB)
    //        self.hue = nsColor?.hueComponent ?? 0
    //        self.saturation = nsColor?.saturationComponent ?? 0
    //        self.brightness = nsColor?.brightnessComponent ?? 0
    //        self.alpha = nsColor?.alphaComponent ?? 0
    //    }
        
        
        internal func to8Bit(_ value: CGFloat) -> Int {
            let roundingRule = FloatingPointRoundingRule.toNearestOrEven
            return Int((value * 255).rounded(roundingRule))
        }
        
        private static func clamp(_ value: CGFloat) -> CGFloat {
            max(0, min(1, value))
        }
    }
}

extension TrussUI.ColorComponents: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hue == rhs.hue &&
        lhs.saturation == rhs.saturation &&
        lhs.brightness == rhs.brightness &&
        lhs.alpha == rhs.alpha
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hue)
        hasher.combine(saturation)
        hasher.combine(brightness)
        hasher.combine(alpha)
    }
}

public extension TrussUI.ColorComponents {
    private var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var color = NSColor(color)
        color = color.usingColorSpace(.deviceRGB) ?? color
        return (color.redComponent, color.greenComponent, color.blueComponent)
    }
    
    var red: CGFloat { rgb.red }
    var green: CGFloat { rgb.green }
    var blue: CGFloat { rgb.blue }
    
    
    var color: Color {
        .init(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    var isSaturated: Bool {
        saturation > 0
    }
    
    func multiplied(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1) -> Self {
        .init(hue: self.hue * hue, saturation: self.saturation * saturation, brightness: self.brightness * brightness, alpha: self.alpha * alpha)
    }
    
    func multiplied(red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1) -> Self {
        .init(red: self.red * red, green: self.green * green, blue: self.blue * blue, alpha: self.alpha * alpha)
    }
    
    func set(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> Self {
        .init(hue: hue ?? self.hue, saturation: saturation ?? self.saturation, brightness: brightness ?? self.brightness, alpha: alpha ?? self.alpha)
    }
    
    func set(red: CGFloat? = nil, green: CGFloat? = nil, blue: CGFloat? = nil, alpha: CGFloat? = nil) -> Self {
        .init(red: red ?? self.red, green: green ?? self.green, blue: blue ?? self.blue, alpha: alpha ?? self.alpha)
    }
}

public extension TrussUI.ColorComponents {
    @ViewBuilder
    func swatch(showValues: ShowValues? = .none) -> some View {
        Swatch(components: self, showValues: showValues)
    }
    enum ShowValues: Equatable {
        case rgb
        case rgb8bit
        case rgbFloat
        case hsb
    }
    private struct Swatch: View {
        let components: ColorComponents
        let showValues: ShowValues?
        func _8Bit(_ value: CGFloat) -> String {
            "\(components.to8Bit(value))"
        }
        func float(_ value: CGFloat) -> String {
            String(format: "%.2f", value)
        }
        var body: some View {
            HStack {
                TrussUI.Component.roundedRectangle(.regular)
                    .theme().size(.regular)
                    .foregroundStyle(components.color)
                if [.rgb, .rgb8bit].contains(showValues) {
                    VStack(alignment: .leading) {
                        Text(_8Bit(components.red))
                        Text(_8Bit(components.green))
                        Text(_8Bit(components.blue))
                        Text(_8Bit(components.alpha))
                    }
                }
                if [.rgb, .rgbFloat].contains(showValues) {
                    VStack(alignment: .leading) {
                        Text(float(components.red))
                        Text(float(components.green))
                        Text(float(components.blue))
                        Text(float(components.alpha))
                    }
                }
                if showValues == .hsb {
                    VStack(alignment: .leading) {
                        Text(float(components.hue))
                        Text(float(components.saturation))
                        Text(float(components.brightness))
                        Text(float(components.alpha))
                    }
                }
            }
            .font(.system(size: 10).monospaced())
        }
    }
}

// MARK: - Tint

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

// MARK: - Preview

@available(macOS 14.0, *)
private extension TrussUI.Tint {
    static let systemRed = Self(lightColor: .red)
    static let systemYellow = Self(lightColor: .yellow)
    static let redEqual = Self(
        light: .init(hue: 0.009, saturation: 0.8125, brightness: 1),
        dark: .init(red: 255 / 255, green: 59 / 255, blue: 48 / 255),
        lightAccessible: .init(color: .red, colorScheme: .lightAccessible)
    )
    static let tintFromTint: TrussUI.Tint = .init(
        light: TrussUI.Tint.systemRed.light,
        dark: TrussUI.Tint.systemYellow.dark
    )
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
                    TrussUI.Tint.redEqual.swatch()
                    TrussUI.Tint.tintFromTint.swatch()
                    TrussUI.Tint.systemRed.swatch(showValues: .hsb)
                    TrussUI.Component.roundedRectangle(.regular)
                        .theme().size(.regular)
                        .theme().foreground(TrussUI.Tint.systemRed.colorScheme(.lightAccessible))
//                        .theme().foreground(.swiftUI.tintColor(.red).colorScheme(.light))
//                    TrussUI.ColorVariable.swiftUI.tintColor(.red).colorScheme(.light).swatch()
                    TrussUI.Tint.systemRed.colorScheme(.lightAccessible).swatch()
                    TrussUI.ColorVariable.mix.tint(.systemRed).swatch()
                    TrussUI.ColorVariable.Scale.backgroundEmphasized.swatch()
                    TrussUI.ColorVariable.Scale.textFaded.swatch()
                    
                }
            }
        }
    }

    static var previews: some View {
        VStack (spacing: 0) {
            ColorComponentsTest()
        }
        .theme().padding(.regular)
        .theme().background()
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

private extension EnvironmentValues {
    init(colorScheme: ColorScheme, colorSchemeContrast: ColorSchemeContrast) {
        var env = EnvironmentValues()
        env.colorScheme = colorScheme
        env._colorSchemeContrast = colorSchemeContrast
        self = env
    }
}
