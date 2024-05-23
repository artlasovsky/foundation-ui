//
//  ColorSet.swift
//
//
//  Created by Art Lasovsky on 02/03/2024.
//

import Foundation
import SwiftUI

public extension TrussUI {
    struct ColorSet: TrussUIColorSet {
        public var light: Components
        public var dark: Components
        public var lightAccessible: Components
        public var darkAccessible: Components
        
        public var colorScheme: TrussUI.ColorScheme?
        
        public init(light: Components, dark: Components, lightAccessible: Components? = nil, darkAccessible: Components? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
    }
}

public extension TrussUI.ColorSet {
    func blendMode(_ blendMode: BlendMode) -> TrussUI.ColorSet {
        .init(
            light: light.blendMode(blendMode),
            dark: dark.blendMode(blendMode),
            lightAccessible: lightAccessible.blendMode(blendMode),
            darkAccessible: darkAccessible.blendMode(blendMode)
        )
    }
}

public extension TrussUI.ColorSet {
    static func from(_ tintedColorSet: TrussUI.TintedColorSet) -> Self {
        .init(
            light: tintedColorSet.light,
            dark: tintedColorSet.dark,
            lightAccessible: tintedColorSet.lightAccessible,
            darkAccessible: tintedColorSet.darkAccessible
        )
    }
}

public extension TrussUI.ColorSet {
    func hue(_ hue: Double) -> Self {
        .init(
            light: light.hue(hue),
            dark: dark.hue(hue),
            lightAccessible: lightAccessible.hue(hue),
            darkAccessible: darkAccessible.hue(hue)
        )
    }
    
    func saturation(_ saturation: Double) -> Self {
        .init(
            light: light.saturation(saturation),
            dark: dark.saturation(saturation),
            lightAccessible: lightAccessible.saturation(saturation),
            darkAccessible: darkAccessible.saturation(saturation)
        )
    }
    
    func brightness(_ brightness: Double) -> Self {
        .init(
            light: light.brightness(brightness),
            dark: dark.brightness(brightness),
            lightAccessible: lightAccessible.brightness(brightness),
            darkAccessible: darkAccessible.brightness(brightness)
        )
    }
    
    func opacity(_ opacity: Double) -> Self {
        .init(
            light: light.opacity(opacity),
            dark: dark.opacity(opacity),
            lightAccessible: lightAccessible.opacity(opacity),
            darkAccessible: darkAccessible.opacity(opacity)
        )
    }
}

// MARK: - Protocol
public protocol TrussUIColorSet: ShapeStyle, Hashable, Equatable { // aka "Destructive"
    typealias Components = TrussUI.DynamicColorComponents
    var light: Components { get }
    var dark: Components { get }
    var lightAccessible: Components { get }
    var darkAccessible: Components { get }
    
    var colorScheme: TrussUI.ColorScheme? { get set }
    
    init(light: Components, dark: Components, lightAccessible: Components?, darkAccessible: Components?)
    
    func components(_ colorScheme: TrussUI.ColorScheme) -> Components
    
    func blendMode(_ blendMode: BlendMode) -> Self
}

public extension TrussUIColorSet {
    init(universal components: Components) {
        self.init(light: components, dark: components, lightAccessible: components, darkAccessible: components)
    }
    
    init(colorSet: Self) {
        self.init(lightSet: colorSet, dark: colorSet, lightAccessible: colorSet, darkAccessible: colorSet)
    }
 
    init(lightSet light: Self, dark: Self, lightAccessible: Self? = nil, darkAccessible: Self? = nil) {
        self.init(
            light: light.components(.light),
            dark: dark.components(.dark),
            lightAccessible: lightAccessible?.components(.lightAccessible),
            darkAccessible: darkAccessible?.components(.darkAccessible)
        )
    }
}

@available(macOS 14.0, iOS 17.0, *)
public extension TrussUIColorSet {
    init(color: Color) {
        self.init(lightColor: color)
    }

    init(lightColor: Color, dark: Color? = nil, lightAccessible: Color? = nil, darkAccessible: Color? = nil) {
        let dark = dark ?? lightColor
        let lightAccessible = lightAccessible ?? lightColor
        let darkAccessible = darkAccessible ?? dark
        self.init(
            light: .init(.init(color: lightColor, colorScheme: .light)),
            dark: .init(.init(color: dark, colorScheme: .dark)),
            lightAccessible: .init(.init(color: lightAccessible, colorScheme: .lightAccessible)),
            darkAccessible: .init(.init(color: darkAccessible, colorScheme: .darkAccessible))
        )
    }
}

public extension TrussUIColorSet {
    static func fromComponents<C: TrussUIColorComponents>(light: C, dark: C, lightAccessible: C? = nil, darkAccessible: C? = nil) -> Self {
        .init(
            light: .init(light),
            dark: .init(dark),
            lightAccessible: .init(lightAccessible ?? light),
            darkAccessible: .init(darkAccessible ?? dark)
        )
    }
    static func fromComponents<C: TrussUIColorComponents>(_ universal: C) -> Self {
        .fromComponents(light: universal, dark: universal)
    }
    static func fromColorSet<C: TrussUIColorSet>(light: C, dark: C, lightAccessible: C? = nil, darkAccessible: C? = nil) -> Self {
        .fromComponents(
            light: light.light,
            dark: dark.dark,
            lightAccessible: lightAccessible?.lightAccessible,
            darkAccessible: darkAccessible?.darkAccessible
        )
    }
    static func fromColorSet<C: TrussUIColorSet>(_ universal: C) -> Self {
        .fromColorSet(light: universal, dark: universal)
    }
}

public extension TrussUIColorSet {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        components(.init(environment)).shapeStyle()
    }
    
    func components(_ colorScheme: TrussUI.ColorScheme) -> Components {
        switch (self.colorScheme ?? colorScheme) {
        case .light: light
        case .dark: dark
        case .lightAccessible: lightAccessible
        case .darkAccessible: darkAccessible
        }
    }
    
    func color(_ colorScheme: TrussUI.ColorScheme) -> Color {
        components(colorScheme).color()
    }
    
    func color(in environment: EnvironmentValues) -> Color {
        components(.init(environment)).color()
    }
}

public extension TrussUIColorSet {
    func colorScheme(_ colorScheme: TrussUI.ColorScheme) -> Self {
        var copy = self
        copy.colorScheme = colorScheme
        return copy
    }
    
    /// Automatically adjust the color blend mode to mix with the background
    func vibrant() -> Self {
        .init(
            light: light.opacity(0.65).blendMode(.plusDarker),
            dark: dark.opacity(0.5).blendMode(.plusLighter),
            lightAccessible: lightAccessible,
            darkAccessible: darkAccessible
        )
    }
}

public extension TrussUIColorSet {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    static func == (lhs: Self, rhs: some TrussUIColorSet) -> Bool {
        lhs.light == rhs.light &&
        lhs.dark == rhs.dark &&
        lhs.lightAccessible == rhs.lightAccessible &&
        lhs.darkAccessible == rhs.darkAccessible &&
        lhs.colorScheme == rhs.colorScheme
    }
    static func != (lhs: Self, rhs: some TrussUIColorSet) -> Bool {
        !(lhs == rhs)
    }
}

// MARK: - EnvironmentValues
internal extension EnvironmentValues {
    private struct TrussUITintKey: EnvironmentKey {
        static let defaultValue: TrussUI.ColorSet? = nil
    }
    
    var trussUITint: TrussUI.ColorSet? {
        get { self[TrussUITintKey.self] }
        set { self[TrussUITintKey.self] = newValue }
    }
}

// MARK: - Playground
internal extension TrussUI.ColorSet {
    static let accent = Self(
        light: .init(hue: 0.08, saturation: 0.5, brightness: 0.7),
        dark: .init(hue: 0.08, saturation: 0.9, brightness: 0.9)
    )
}

internal extension TrussUI.TintedColorSet {
    static let source: Self = .tint(.accent)
    static let dynamic: Self = source.adjust(
        light: { $0
            .multiply(opacity: $0.isSaturated ? 0.1 : 0.5)
            .set(hue: 0.53, brightness: 1)
        },
        dark: { $0
            .multiply(opacity: 0.75)
        }
    ).tint(.primary)
    static let mix: Self = .init(
//        lightSet: .fromColorSet(StaticColorSet.accent).adjust({ $0.set(saturation: 1) }),
        lightSet: .dynamic.tint(.accent).adjust({ $0.set(hue: 0.53, saturation: 0.7) }),
        dark: .dynamic.tint(.accent)
    )
}

public extension TrussUIColorSet {
    func swatch() -> some View {
        HStack {
            let base = TrussUI.Shape.roundedSquare(.regular, size: .regular.offset(.half.down))
                .foregroundStyle(self)
            base._colorScheme(.light)
            base._colorScheme(.dark)
            base._colorScheme(.lightAccessible)
            base._colorScheme(.darkAccessible)
        }
    }
}

struct DynamicColor_Preview: PreviewProvider {
    static let rect: some View = TrussUI.Shape.roundedSquare(.regular, size: .regular)
    static var previews: some View {
        VStack {
            TrussUI.TintedColorSet.mix.swatch()
            TrussUI.ColorSet.primary.swatch()
            TrussUI.TintedColorSet.source.swatch()
            TrussUI.TintedColorSet.dynamic.swatch()
            Divider().frame(width: 200)
            TrussUI.TintedColorSet.background.swatch()
            TrussUI.TintedColorSet.fill.swatch()
            TrussUI.TintedColorSet.solid.swatch()
            TrussUI.TintedColorSet.text.swatch()
            TrussUI.TintedColorSet.textEmphasized.swatch()
        }
        .padding()
        .background {
            Rectangle()
                .padding(-20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .truss(.background().ignoreEdges())
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
