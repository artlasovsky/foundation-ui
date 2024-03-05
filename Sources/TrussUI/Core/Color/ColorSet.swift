//
//  ColorSet.swift
//
//
//  Created by Art Lasovsky on 02/03/2024.
//

import Foundation
import SwiftUI

public protocol TrussUIColorSet: ShapeStyle, Hashable, Equatable { // aka "Destructive"
    typealias Components = TrussUI.DynamicColorComponents
    var light: Components { get }
    var dark: Components { get }
    var lightAccessible: Components { get }
    var darkAccessible: Components { get }
    
    var colorScheme: TrussUI.ColorScheme? { get set }
    
    var blendMode: BlendMode { get set }
    
    init(light: Components, dark: Components, lightAccessible: Components?, darkAccessible: Components?)
    
    func components(_ colorScheme: TrussUI.ColorScheme) -> Components
}

public extension TrussUIColorSet {
    init(_ components: Components) {
        self.init(light: components, dark: components, lightAccessible: components, darkAccessible: components)
    }
    
    init(_ colorSet: Self) {
        self.init( lightSet: colorSet, dark: colorSet, lightAccessible: colorSet, darkAccessible: colorSet)
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

@available(macOS 14.0, *)
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
        components(.init(environment)).shapeStyle().blendMode(blendMode)
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
    func blendMode(_ blendMode: BlendMode) -> Self {
        var copy = self
        copy.blendMode = blendMode
        return copy
    }
}

public extension TrussUI {
    struct ColorSet: TrussUIColorSet {
        public var light: Components
        public var dark: Components
        public var lightAccessible: Components
        public var darkAccessible: Components
        
        public var colorScheme: TrussUI.ColorScheme?
        
        public var blendMode: BlendMode = .normal
        
        public init(light: Components, dark: Components, lightAccessible: Components? = nil, darkAccessible: Components? = nil) {
            self.light = light
            self.dark = dark
            self.lightAccessible = lightAccessible ?? light
            self.darkAccessible = darkAccessible ?? dark
        }
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

public extension TrussUI {
    struct TintedColorSet: TrussUIColorSet {
        public typealias Adjust = @Sendable (Components) -> Components.Adjustments
        public var light: Components { components(.light) }
        public var dark: Components { components(.dark) }
        public var lightAccessible: Components { components(.lightAccessible) }
        public var darkAccessible: Components { components(.darkAccessible) }
        
        public var colorScheme: TrussUI.ColorScheme?
        
        public var blendMode: BlendMode = .normal
        
        private var tint: TrussUI.ColorSet
        
        private var tintIsLocked: Bool = false
        
        private var lightAdjust: Adjust?
        private var darkAdjust: Adjust?
        private var lightAccessibleAdjust: Adjust?
        private var darkAccessibleAdjust: Adjust?
        
        public init(light: Components, dark: Components, lightAccessible: Components? = nil, darkAccessible: Components? = nil) {
            tint = .init(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        }
        
        private init(_ colorSet: TrussUI.ColorSet) {
            self.tint = colorSet
        }
    }
}

public extension TrussUI.TintedColorSet {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        var colorSet = self
        if !tintIsLocked, let envTint = environment.trussUITint {
            colorSet.tint = envTint
        }
        return colorSet.components(.init(environment)).shapeStyle().blendMode(colorSet.blendMode)
    }
    
    func components(_ colorScheme: TrussUI.ColorScheme) -> Components {
        let colorScheme = self.colorScheme ?? colorScheme
        var components = tint.components(colorScheme)
        let adjust = switch colorScheme {
        case .light: lightAdjust
        case .dark: darkAdjust
        case .lightAccessible: lightAccessibleAdjust
        case .darkAccessible: darkAccessibleAdjust
        }
        if let adjust {
            components = adjust(components).applyTo(components)
        }
        return components
    }
}

public extension TrussUI.TintedColorSet {
    func hash(into hasher: inout Hasher) {
        hasher.combine(light)
        hasher.combine(dark)
        hasher.combine(lightAccessible)
        hasher.combine(darkAccessible)
        hasher.combine(blendMode)
        
        hasher.combine(lightAdjust?(light))
        hasher.combine(darkAdjust?(dark))
        hasher.combine(lightAccessibleAdjust?(lightAccessible))
        hasher.combine(darkAccessibleAdjust?(darkAccessible))
    }
    
    static func == (lhs: TrussUI.TintedColorSet, rhs: TrussUI.TintedColorSet) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

public extension TrussUI.TintedColorSet {
    func lockTint(_ lock: Bool) -> Self {
        var copy = self
        copy.tintIsLocked = lock
        return copy
    }
    static func tint(_ colorSet: TrussUI.ColorSet) -> Self {
        .init(colorSet)
    }
    
    func tint(_ colorSet: TrussUI.ColorSet) -> Self {
        var copy = self
        copy.tint = tint
        return copy.lockTint(true)
    }
}

public extension TrussUI.TintedColorSet {
    func adjust(light: @escaping Adjust, dark: @escaping Adjust, lightAccessible: Adjust? = nil, darkAccessible: Adjust? = nil) -> Self {
        var copy = self
        copy.lightAdjust = light
        copy.darkAdjust = dark
        copy.lightAccessibleAdjust = lightAccessible ?? light
        copy.darkAccessibleAdjust = darkAccessible ?? dark
        return copy
    }
    
    func adjust(_ universal: @escaping Adjust) -> Self {
        adjust(light: universal, dark: universal, lightAccessible: universal, darkAccessible: universal)
    }
    
    func hue(_ hue: Double) -> Self {
        adjust { $0.hue(hue) }
    }
    
    func saturation(_ saturation: Double) -> Self {
        adjust { $0.saturation(saturation) }
    }
    
    func brightness(_ brightness: Double) -> Self {
        adjust { $0.brightness(brightness) }
    }
    
    func opacity(_ opacity: Double) -> Self {
        adjust { $0.opacity(opacity) }
    }
}

private extension TrussUI.ColorSet {
    static let accent = Self(
        light: .init(hue: 0.08, saturation: 0.5, brightness: 0.7),
        dark: .init(hue: 0.08, saturation: 0.9, brightness: 0.9)
    )
}

extension TrussUI.TintedColorSet {
    private static let source: Self = .init(.accent)
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

struct DynamicColor_Preview: PreviewProvider {
    static let rect: some View = TrussUI.Component.roundedRectangle(.regular).truss(.size(.regular))
    static var previews: some View {
        HStack {
//            rect.foregroundStyle(.tint)
            VStack {
                rect
                    .truss(.foreground(.fill))
                    .environment(\.colorScheme, .light)
                rect
                    .truss(.foreground(.fill))
                    .environment(\.colorScheme, .dark)
                rect
                    .truss(.foreground(.fill))
                    .environment(\.colorScheme, .light)
                    .environment(\._colorSchemeContrast, .increased)
                rect
                    .truss(.foreground(.fill))
                    .environment(\.colorScheme, .dark)
                    .environment(\._colorSchemeContrast, .increased)
            }
            .truss(.tint(.accent))
            if #available(macOS 14.0, *) {
                let tintedColorSet = TrussUI.TintedColorSet.background
                VStack {
                    rect
                        .truss(.foreground(tintedColorSet))
                        .environment(\.colorScheme, .light)
                    rect
                        .truss(.foreground(tintedColorSet))
                        .environment(\.colorScheme, .dark)
                    rect
                        .truss(.foreground(tintedColorSet))
                        .environment(\.colorScheme, .light)
                        .environment(\._colorSchemeContrast, .increased)
                    rect
                        .truss(.foreground(tintedColorSet))
                        .environment(\.colorScheme, .dark)
                        .environment(\._colorSchemeContrast, .increased)
                }
                .truss(.tintColor(.accentColor))
            }
            VStack {
//                ZStack {
//                    rect
//                        .truss(.foreground(.solid))
//                    rect.offset(x: 15, y: 15)
//                        .truss(.foreground(.solid.blendMode(.plusLighter)))
//                }
                rect
                    .foregroundStyle(TrussUI.ColorSet.from(.background))
                rect
                    .foregroundStyle(TrussUI.TintedColorSet.background)
                rect
                    .foregroundStyle(TrussUI.ColorSet.from(.text))
                rect
                    .foregroundStyle(TrussUI.TintedColorSet.text)
//                    .truss(.foreground(.tint(.from(.background))))
//                    .truss(.tint(.from(.background)))
            }
//            VStack {
//                rect
//                    .foregroundStyle(TintedColorSet.dynamic)
//                    .environment(\.colorScheme, .light)
//                rect
//                    .foregroundStyle(TintedColorSet.dynamic)
//                    .environment(\.colorScheme, .dark)
//            }
//            VStack {
//                rect
//                    .foregroundStyle(TintedColorSet.mix)
//                    .environment(\.colorScheme, .light)
//                rect
//                    .foregroundStyle(TintedColorSet.mix)
//                    .environment(\.colorScheme, .dark)
//            }
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

// MARK: - EnvironmentValues
private struct TrussUITintKey: EnvironmentKey {
    static let defaultValue: TrussUI.ColorSet? = nil
}
internal extension EnvironmentValues {
    var trussUITint: TrussUI.ColorSet? {
        get { self[TrussUITintKey.self] }
        set { self[TrussUITintKey.self] = newValue }
    }
}
