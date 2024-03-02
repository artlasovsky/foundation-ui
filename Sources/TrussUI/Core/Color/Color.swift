//
//  File.swift
//  
//
//  Created by Art Lasovsky on 25/02/2024.
//

import Foundation
import SwiftUI

// MARK: - SwiftUI Extensions
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

#warning("Take a look on this")
public protocol _ColorSet {} // .opacity().hue() will override the initial color
public protocol _AdjustableColorSet {} // .opacity().hue() will be stored as an adjustments

// MARK: - ColorSet protocol
public protocol ColorSet: ShapeStyle, Hashable, Equatable, Sendable {
    typealias Adjustments = (TrussUI.ColorComponents) -> TrussUI.ColorComponents.Adjustments
    
    var light: TrussUI.ColorComponents { get set }
    var dark: TrussUI.ColorComponents { get set }
    var lightAccessible: TrussUI.ColorComponents { get set }
    var darkAccessible: TrussUI.ColorComponents { get set }
    
    init(light: TrussUI.ColorComponents, dark: TrussUI.ColorComponents, lightAccessible: TrussUI.ColorComponents?, darkAccessible: TrussUI.ColorComponents?)
    init(lightSet: Self, dark: Self, lightAccessible: Self?, darkAccessible: Self?)
    
    func adjustments(_ universal: @escaping Adjustments) -> Self
    func adjustments(light: Adjustments, dark: Adjustments, lightAccessible: Adjustments?, darkAccessible: Adjustments?) -> Self
    
    var options: TrussUI.ColorSetOptions { get set }
    
    func colorScheme(_ colorScheme: TrussUI.ColorScheme) -> Self
}

// MARK: - ColorSet inits
public extension ColorSet {
    init(_ universal: TrussUI.ColorComponents) {
        self.init(light: universal, dark: universal, lightAccessible: universal, darkAccessible: universal)
    }
    
    init(lightSet light: Self, dark: Self, lightAccessible: Self? = nil, darkAccessible: Self? = nil) {
        self.init(
            light: light.components(in: light.options.colorScheme ?? .light),
            dark: dark.components(in: dark.options.colorScheme ?? .dark),
            lightAccessible: lightAccessible?.components(in: lightAccessible?.options.colorScheme ?? .lightAccessible),
            darkAccessible: darkAccessible?.components(in: darkAccessible?.options.colorScheme ?? .darkAccessible)
        )
    }
    
    init(colorSet: some ColorSet) {
        var tint: any ColorSet = colorSet
        if let tintOverride = colorSet.options.tint {
            tint = tintOverride.copyAdjustmentsFrom(tint)
        }
        self.init(
            light: tint.components(in: .light),
            dark: tint.components(in: .dark),
            lightAccessible: tint.components(in: .lightAccessible),
            darkAccessible: tint.components(in: .darkAccessible))
        self.options = colorSet.options
    }
}

@available(macOS 14.0, *)
public extension ColorSet {
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

// MARK: - Resolve `ShapeStyle`
public extension ColorSet {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        let colorScheme = options.colorScheme ?? TrussUI.ColorScheme(environment)
        var components = self.components(in: colorScheme)
        if !options.environmentCanOverrideTint, let tintOverride = options.tint {
            components = tintOverride.components(in: colorScheme)
//                .withAdjustments(from: components)
        } else if options.environmentCanOverrideTint, let envTintOverride = environment.trussUITint {
            components = envTintOverride.components(in: colorScheme).withAdjustments(from: components)
        }
        return components.resolve()
    }
    
    func components(in colorScheme: TrussUI.ColorScheme) -> TrussUI.ColorComponents {
        switch colorScheme {
        case .light: light
        case .dark: dark
        case .lightAccessible: lightAccessible
        case .darkAccessible: darkAccessible
        }
    }
    
    func components(in environment: EnvironmentValues) -> TrussUI.ColorComponents {
        components(in: TrussUI.ColorScheme(environment))
    }
}

// MARK: - Resolve `Color`
public extension ColorSet {
    func color(_ colorScheme: TrussUI.ColorScheme) -> Color {
        components(in: colorScheme).color
    }
    func color(_ environment: EnvironmentValues) -> Color {
        color(TrussUI.ColorScheme(environment))
    }
    /// Returns ``SwiftUI/Color`` value which will adjust to the View's Environment
    ///
    /// > Important: In the SwiftUI Previews accessible colors will only will be visible when it is set in system settings
    func color() -> Color {
        .init(nsColor: .init(name: nil, dynamicProvider: { appearance in
            return .init(self.color(TrussUI.ColorScheme(appearance: appearance)))
        }))
    }
}

// MARK: - Adjustments
public extension ColorSet {
    func adjustments(_ universal: @escaping Adjustments) -> Self {
        adjustments(
            light: universal,
            dark: universal,
            lightAccessible: universal,
            darkAccessible: universal
        )
    }
    func adjustments(light: Adjustments, dark: Adjustments, lightAccessible: Adjustments? = nil, darkAccessible: Adjustments? = nil) -> Self {
        var copy = self
        copy.light.adjustments = light(self.light)
        copy.dark.adjustments = dark(self.dark)
        copy.lightAccessible.adjustments = lightAccessible?(self.lightAccessible) ?? light(self.lightAccessible)
        copy.darkAccessible.adjustments = darkAccessible?(self.darkAccessible) ?? dark(self.darkAccessible)
        return copy
    }
}

extension ColorSet {
    func copyAdjustmentsFrom(_ colorSet: some ColorSet) -> Self {
        var copy = self
        copy.light.adjustments = colorSet.light.adjustments
        copy.dark.adjustments = colorSet.dark.adjustments
        copy.lightAccessible.adjustments = colorSet.lightAccessible.adjustments
        copy.darkAccessible.adjustments = colorSet.darkAccessible.adjustments
        return .init(colorSet: copy)
    }
}

// MARK: - ColorVariable
public extension TrussUI {
    struct ColorVariable: ColorSet {
        public var light: TrussUI.ColorComponents
        public var dark: TrussUI.ColorComponents
        public var lightAccessible: TrussUI.ColorComponents
        public var darkAccessible: TrussUI.ColorComponents
        public var options = TrussUI.ColorSetOptions()
        
        public init(light: TrussUI.ColorComponents, dark: TrussUI.ColorComponents, lightAccessible: TrussUI.ColorComponents? = nil, darkAccessible: TrussUI.ColorComponents? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
        
        private func copyAdjustmentsFrom(_ colorSet: some ColorSet) -> Self {
            var copy = self
            copy.light.adjustments = colorSet.light.adjustments
            copy.dark.adjustments = colorSet.dark.adjustments
            copy.lightAccessible.adjustments = colorSet.lightAccessible.adjustments
            copy.darkAccessible.adjustments = colorSet.darkAccessible.adjustments
            return .init(colorSet: copy)
        }
        
        public func scale(_ colorScale: TrussUI.ColorScale) -> Self {
            copyAdjustmentsFrom(colorScale)
        }
        
        public static func scale(_ colorScale: TrussUI.ColorScale) -> Self {
            .init(colorSet: colorScale)
        }
    }
}

// MARK: - ColorScale
public extension TrussUI {
    struct ColorScale: ColorSet {
        public var light: TrussUI.ColorComponents
        public var dark: TrussUI.ColorComponents
        public var lightAccessible: TrussUI.ColorComponents
        public var darkAccessible: TrussUI.ColorComponents
        public var options = TrussUI.ColorSetOptions(environmentCanOverrideTint: true)
        
        public init(light: TrussUI.ColorComponents, dark: TrussUI.ColorComponents, lightAccessible: TrussUI.ColorComponents? = nil, darkAccessible: TrussUI.ColorComponents? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
        
        /// Overrides the base tint.
        /// Will not inherit the environment tint after applying. (can be unlocked with `.unlock()`)
        public func tint(_ colorVariable: TrussUI.ColorVariable) -> Self {
            var copy = self
            copy.options.tint = colorVariable
            return copy.lock()
        }
        
        @available(macOS 14.0, *)
        public func tintColor(_ color: Color) -> Self {
            var copy = self
            copy.options.tint = TrussUI.ColorVariable(color: color)
            return copy.lock()
        }
        
        /// Create a new ``TrussUI/TrussUI/ColorScale`` from ``TrussUI/TrussUI/ColorVariable``
        /// The tint can be overriden by `.truss(.tint())`
        public static func variable(_ colorVariable: TrussUI.ColorVariable) -> Self {
            Self(colorSet: colorVariable).unlock()
        }
    }
}

// MARK: - Adjustments
public extension ColorSet {
    func lock() -> Self {
        var copy = self
        copy.options.environmentCanOverrideTint = false
        return copy
    }
    func unlock() -> Self {
        var copy = self
        copy.options.environmentCanOverrideTint = true
        return copy
    }
    
    func blendMode(_ mode: BlendMode) -> Self {
        var copy = self
        copy.light.blendMode(mode)
        copy.dark.blendMode(mode)
        copy.lightAccessible.blendMode(mode)
        copy.darkAccessible.blendMode(mode)
        return copy
    }
    
    /// Multiplies the opacity of the color by the given amount.
    func opacity(_ opacity: Double) -> Self {
        var copy = self
        copy.light.opacity(opacity)
        copy.dark.opacity(opacity)
        copy.lightAccessible.opacity(opacity)
        copy.darkAccessible.opacity(opacity)
        return copy
    }
    /// Multiplies the hue of the color by the given amount.
    func hue(_ hue: Double) -> Self {
        var copy = self
        copy.light.hue(hue)
        copy.dark.hue(hue)
        copy.lightAccessible.hue(hue)
        copy.darkAccessible.hue(hue)
        return copy
    }
    /// Multiplies the saturation of the color by the given amount.
    func saturation(_ saturation: Double) -> Self {
        var copy = self
        copy.light.saturation(saturation)
        copy.dark.saturation(saturation)
        copy.lightAccessible.saturation(saturation)
        copy.darkAccessible.saturation(saturation)
        return copy
    }
    /// Multiplies the brightness of the color by the given amount.
    func brightness(_ brightness: Double) -> Self {
        var copy = self
        copy.light.brightness(brightness)
        copy.dark.brightness(brightness)
        copy.lightAccessible.brightness(brightness)
        copy.darkAccessible.brightness(brightness)
        return copy
    }
    /// Overrides the color scheme.
    func colorScheme(_ colorScheme: TrussUI.ColorScheme) -> Self {
        var copy = self
        copy.options.colorScheme = colorScheme
        return copy
    }
}

// MARK: - ColorSetOptions
public extension TrussUI {
    struct ColorSetOptions: Sendable {
        var tint: (any ColorSet)? = nil
        var colorScheme: TrussUI.ColorScheme? = nil
        var environmentCanOverrideTint: Bool = false
    }
}
extension TrussUI.ColorSetOptions: Hashable, Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorScheme)
        if let tint {
            hasher.combine(tint)
        }
    }
}

// MARK: - EnvironmentValues
private struct TrussUITintKey: EnvironmentKey {
    static let defaultValue: TrussUI.ColorVariable? = nil
}
internal extension EnvironmentValues {
    var trussUITint: TrussUI.ColorVariable? {
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

// MARK: - Hashable, Equatable
public extension ColorSet {
    func hash(into hasher: inout Hasher) {
        hasher.combine(light)
        hasher.combine(dark)
        hasher.combine(lightAccessible)
        hasher.combine(darkAccessible)
        hasher.combine(options)
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

// MARK: - Preview

internal extension TrussUI.ColorVariable {
    static let test = Self(
        light: .init(hue: 0, saturation: 0.8, brightness: 1), // red
        dark: .init(hue: 0.2, saturation: 0.8, brightness: 1) // green
    )
    
    static let purple = Self(.init(hue: 0.7, saturation: 0.6, brightness: 1))
//        .adjustments({ $0.multiply(alpha: 0.5) })
    
    static let mix = Self(
        lightSet: .test.opacity(0.5).colorScheme(.dark),
//        dark: .tint.opacity(0.5),
        dark: .primary.scale(.background),
        lightAccessible: .test.colorScheme(.dark).opacity(0.2),
        darkAccessible: .purple.brightness(1.2)
    )
    
    static let split = Self(
        lightSet: .scale(.text.opacity(0.5)),
        dark: .scale(.text).opacity(0.5).colorScheme(.light)
    )
//    static let splitBlend = Self(
//        lightSet: .test.scale(.fill),
//        dark: .test.scale(.fill)
//    )
    static let adjust = Self(
        lightSet: .purple.scale(.adjust),
        dark: .purple.scale(.adjust2).colorScheme(.light)
    )
}

internal extension TrussUI.ColorScale {
    static let adjust = Self.defaultTint.adjustments(
        light: { _ in .multiply(saturation: 0.8, brightness: 0.6) },
        dark: { _ in .multiply(saturation: 1.2, brightness: 0.74) }
    )
    static let textVibrant = Self(
        lightSet: .text.blendMode(.plusDarker),
        dark: .text.blendMode(.plusLighter)
    ).opacity(0.8)
    static let adjust2 = Self.defaultTint.adjustments(
        light: { $0.multiply(saturation: 0.8, brightness: 0.5).set(saturation: 0.3) },
        dark: { _ in .init(saturation: 1.2, brightness: 0.74) }
    )
    static let tintedScale = Self.variable(.test).adjustments(
        light: { $0.multiply(brightness: 0.9) },
        dark: { $0.multiply(brightness: 0.3) }
    )
}

fileprivate extension TrussUI.Variable.Font {
    static let colorSwatch = Self(value: .system(size: 8, design: .rounded), label: "colorSwatch")
}

private struct TrussUIColorSwatch<S: ColorSet>: View {
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
            style.components(in: colorScheme).swatch()
        }
    }
}

extension ColorSet {
    func swatch() -> some View {
        TrussUIColorSwatch(style: self)
    }
}

@available(macOS 14.0, *)
struct ColorPreview: PreviewProvider {
    struct Swatch: View {
        var fill: TrussUI.ColorScale = .background
        var text: TrussUI.ColorScale = .text
        var body: some View {
            TrussUI.Component.roundedRectangle(.regular)
                .truss(.size(.regular))
                .truss(.foreground(fill))
                .overlay(content: {
                    VStack {
                        Text("Text")
                            .truss(.foreground(text))
                    }
                })
        }
    }
    struct SwatchPair: View {
        var fill: TrussUI.ColorScale = .background
        var text: TrussUI.ColorScale = .text
        var body: some View {
            HStack {
                Swatch(fill: fill, text: text)
                    .environment(\.colorScheme, .light)
                Swatch(fill: fill, text: text)
                    .environment(\.colorScheme, .dark)
            }
        }
    }
    struct SwatchOverlap: View {
        var fill: TrussUI.ColorScale = .solid
        private let offset: CGFloat = .truss.padding(.large)
        var body: some View {
            ZStack {
                TrussUI.Component.roundedRectangle(.regular)
                    .truss(.size(.regular))
                    .truss(.foreground(fill))
                    .environment(\.colorScheme, .light)
                TrussUI.Component.roundedRectangle(.regular)
                    .offset(x: offset, y: offset)
                    .truss(.size(.regular))
                    .truss(.foreground(fill))
                    .environment(\.colorScheme, .dark)
            }
            .offset(x: -offset / 2, y: -offset / 2)
            .padding(offset / 2)
        }
    }
    static var previews: some View {
        VStack {
//            ZStack {
//                TrussUI.Component.roundedRectangle(.regular)
//                    .truss(.size(.regular))
//                    .truss(.foreground(.solid))
//                TrussUI.Component.roundedRectangle(.regular)
//                    .offset(x: 15, y: 3)
//                    .truss(.size(.regular))
//                    .truss(.foreground(.variable(.split)))
//            }
//            ZStack {
//                TrussUI.Component.roundedRectangle(.regular)
//                    .truss(.size(.regular))
//                    .truss(.foreground(.tintedScale))
////                    .truss(.foreground(.adjust))
//                    .environment(\.colorScheme, .light)
//                TrussUI.Component.roundedRectangle(.regular)
//                    .offset(x: 15, y: 15)
//                    .truss(.size(.regular))
////                    .truss(.foreground(.adjust.tint(.init(color: .blue))))
////                    .truss(.foreground(.tintedScale.unlock()))
//                    .truss(.foreground(.solid.tint(.test)))
////                    .truss(.foreground(.variable(.adjust)))
//                    .environment(\.colorScheme, .dark)
//            }
//            .offset(x: -7.5, y: -7.5)
            SwatchOverlap(fill: .solid)
            SwatchOverlap(fill: .solid.tint(.purple))
//            SwatchPair()
//            SwatchPair(fill: .backgroundFaded, text: .text)
//            SwatchPair().truss(.tintColor(.orange))
//            ZStack {
//                TrussUI.Component.roundedRectangle(.regular)
//                    .truss(.size(.regular))
//                    .truss(.foreground(.textVibrant))
//                    .environment(\.colorScheme, .light)
//                TrussUI.Component.roundedRectangle(.regular)
//                    .offset(x: 15, y: 15)
//                    .truss(.size(.regular))
////                    .foregroundStyle(.yellow.blendMode(.color))
//                    .truss(.foreground(.textVibrant))
//                    .environment(\.colorScheme, .dark)
//            }
//            .offset(x: -7.5, y: -7.5)
//            .truss(.tint(.test))
//            .truss(.tint(.primary))
//            VStack {
//                TrussUI.ColorVariable.primary.swatch()
//                TrussUI.ColorVariable(color: .gray).swatch()
//            }
//            HStack {
//                TrussUI.Component.roundedRectangle(.regular)
//                    .truss(.size(.regular))
//                    .truss(.foreground(.variable(.split)))
//                    .environment(\.colorScheme, .light)
//                TrussUI.Component.roundedRectangle(.regular)
//                    .truss(.size(.regular))
//                    .truss(.foreground(.variable(.split)))
//                    .environment(\.colorScheme, .dark)
//            }
//            HStack {
//                Swatch()
//                    .environment(\.colorScheme, .light)
//                Swatch()
//                    .environment(\.colorScheme, .dark)
//            }
//            HStack {
//                Swatch()
//                    .environment(\.colorScheme, .light)
//                Swatch()
//                    .environment(\.colorScheme, .dark)
//            }
//            HStack {
//                Swatch()
//                    .environment(\.colorScheme, .light)
//                Swatch()
//                    .environment(\.colorScheme, .dark)
//            }
//            .environment(\._colorSchemeContrast, .increased)
        }
        .padding()
    }
}
