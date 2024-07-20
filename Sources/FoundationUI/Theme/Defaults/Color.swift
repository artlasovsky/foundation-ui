//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var color: Variable.Color { .primary }
}

extension Color {
    static let theme = FoundationUI.theme.color
}

extension FoundationUI.DefaultTheme.Variable {
    public struct Color: FoundationColorVariable {
        public var color: FoundationUI.DynamicColor
        private var variant: Variant?
        private var colorScheme: FoundationUI.ColorScheme?
        
        public init(_ color: FoundationUI.DynamicColor) {
            self.color = color
        }
        
        public static func from(color: SwiftUI.Color) -> Self {
            self.init(.from(color: color))
        }
    }
}

public extension FoundationUI.DefaultTheme.Variable.Color {
    struct Variant: Sendable {
        public typealias ColorValue = FoundationUI.DynamicColor
        public typealias ComponentAdjust = (ColorValue.Components) -> ColorValue.Components
        
        var adjust: @Sendable (ColorValue) -> ColorValue
        
        public init(adjust: @escaping @Sendable (ColorValue) -> ColorValue) {
            self.adjust = adjust
        }
        
        public init(
            light: @escaping ComponentAdjust,
            dark: @escaping ComponentAdjust,
            lightAccessible: ComponentAdjust? = nil,
            darkAccessible: ComponentAdjust? = nil
        ) {
            self.init { source in
                .init(
                    light: light(source.light),
                    dark: dark(source.dark),
                    lightAccessible: (lightAccessible ?? light)(source.lightAccessible),
                    darkAccessible: (darkAccessible ?? dark)(source.darkAccessible)
                )
            }
        }
    }
    func variant(_ variant: Variant) -> Self {
        .init(variant.adjust(color).copyBlendMode(from: color))
    }
    
    static func dynamic(_ variant: Variant) -> Self {
        /// the color itself will be replaces with by the enviroment tint (`.dynamicTint`)
        /// adjustment applied to this color will be applied to the environment tint
        var color: Self = .init(.init(hue: 1, saturation: 1, brightness: 1))
        color.variant = variant
        return color
    }
}

extension FoundationUI.DefaultTheme.Variable.Color.Variant {
    public typealias Variant = FoundationUI.DefaultTheme.Color.Variant
    public enum Modifier {
        typealias ColorComponents = FoundationUI.ColorComponents
        case adjust(ComponentAdjust)
        case color(FoundationUI.Theme.Color)
        
        func resolve(_ source: ColorComponents, in colorScheme: FoundationUI.ColorScheme) -> ColorComponents {
            switch self {
            case .adjust(let adjust):
                return adjust(source)
            case .color(let color):
                var environment: EnvironmentValues = .init(colorScheme: colorScheme.colorScheme, colorSchemeContrast: colorScheme.colorSchemeContrast)
                environment.dynamicTint = .init(source)
                let components = color.resolveColorValue(in: environment).resolveComponents(in: colorScheme)
                return source.changes.apply(to: components)
//                return components
            }
        }
    }
    
    public static func modifier(light: Modifier, dark: Modifier, lightAccessible: Modifier? = nil, darkAccessible: Modifier? = nil) -> FoundationUI.DefaultTheme.Variable.Color.Variant {
        self.init(
            light: { light.resolve($0, in: .light) },
            dark: { dark.resolve($0, in: .dark) },
            lightAccessible: { (lightAccessible ?? light).resolve($0, in: .lightAccessible) },
            darkAccessible: { (darkAccessible ?? dark).resolve($0, in: .darkAccessible) }
        )
    }
    
    public static func modifier(_ modifier: Modifier) -> Variant {
        .modifier(
            light: modifier,
            dark: modifier
        )
    }
    
    public static func modifierColor(_ color: FoundationUI.DefaultTheme.Color) -> Variant {
        .modifier(.color(color))
    }
    
    public static func modifierColor(light: FoundationUI.Theme.Color, dark: FoundationUI.Theme.Color, lightAccessible: FoundationUI.Theme.Color? = nil, darkAccessible: FoundationUI.Theme.Color? = nil) -> Variant {
        .modifier(
            light: .color(light),
            dark: .color(dark),
            lightAccessible: .color(lightAccessible ?? light),
            darkAccessible: .color(darkAccessible ?? dark)
        )
    }
    
    public static func modifierAdjust(_ adjust: @escaping Variant.ComponentAdjust) -> Variant {
        .modifier(.adjust(adjust))
    }
    
    public static func modifierAdjust(light: @escaping Variant.ComponentAdjust, dark: @escaping Variant.ComponentAdjust, lightAccessible: Variant.ComponentAdjust? = nil, darkAccessible: Variant.ComponentAdjust? = nil) -> Variant {
        .modifier(
            light: .adjust(light),
            dark: .adjust(dark),
            lightAccessible: .adjust(lightAccessible ?? light),
            darkAccessible: .adjust(darkAccessible ?? dark)
        )
    }
}

extension FoundationUI.DefaultTheme.Variable.Color {
    public static func modifier(_ universal: Variant.Modifier) -> Self {
        .dynamic(.modifier(universal))
    }
    
    public static func modifier(light: Variant.Modifier, dark: Variant.Modifier, lightAccessible: Variant.Modifier? = nil, darkAccessible: Variant.Modifier? = nil) -> Self {
        .dynamic(
            .modifier(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
    
    public static func modifierColor(_ universal: FoundationUI.Theme.Color) -> Self {
        .dynamic(.modifierColor(universal))
    }
    
    public static func modifierColor(light: FoundationUI.Theme.Color, dark: FoundationUI.Theme.Color, lightAccessible: FoundationUI.Theme.Color? = nil, darkAccessible: FoundationUI.Theme.Color? = nil) -> Self {
        .dynamic(
            .modifierColor(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
    
    public static func modifierColor(_ universal: @escaping Variant.ComponentAdjust) -> Self {
        .dynamic(.modifierAdjust(universal))
    }
    
    public static func modifierAdjust(light: @escaping Variant.ComponentAdjust, dark: @escaping Variant.ComponentAdjust, lightAccessible: Variant.ComponentAdjust? = nil, darkAccessible: Variant.ComponentAdjust? = nil) -> Self {
        .dynamic(
            .modifierAdjust(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
}

extension FoundationUI.DefaultTheme.Variable.Color: Equatable {
    public static func == (lhs: FoundationUI.DefaultTheme.Variable.Color, rhs: FoundationUI.DefaultTheme.Variable.Color) -> Bool {
        if let lhsVariant = lhs.variant, let rhsVariant = rhs.variant {
            lhsVariant.adjust(lhs.color) == rhsVariant.adjust(rhs.color)
        } else {
            lhs.color == rhs.color
        }
    }
}

public extension FoundationUI.DefaultTheme.Variable.Color {
    private func updateValue(_ value: FoundationUI.DynamicColor) -> Self {
        var copy = self
        copy.color = value
        return copy
    }
    
    func hue(_ value: CGFloat) -> Self {
        updateValue(color.hue(value))
    }
    
    func brightness(_ value: CGFloat) -> Self {
        updateValue(color.brightness(value))
    }
    
    func saturation(_ value: CGFloat) -> Self {
        updateValue(color.saturation(value))
    }
    
    func opacity(_ value: CGFloat) -> Self {
        updateValue(color.opacity(value))
    }
    
    func colorScheme(_ colorScheme: FoundationUI.ColorScheme) -> Self {
        var copy = updateValue(color.colorScheme(colorScheme))
        copy.colorScheme = colorScheme
        return copy
    }
    
    func blendMode(_ mode: BlendMode) -> Self {
        updateValue(color.blendMode(mode))
    }
    
    func blendMode(_ mode: FoundationUI.DynamicColor.ExtendedBlendMode) -> Self {
        updateValue(color.blendMode(mode))
    }
}

public extension FoundationUI.DefaultTheme.Variable.Color {
    init(_ universal: FoundationUI.ColorComponents) {
        color = .init(universal)
    }
    
    init(light: FoundationUI.ColorComponents, dark: FoundationUI.ColorComponents, lightAccessible: FoundationUI.ColorComponents? = nil, darkAccessible: FoundationUI.ColorComponents? = nil) {
        color = .init(
            light: light,
            dark: dark,
            lightAccessible: lightAccessible,
            darkAccessible: darkAccessible
        )
    }
}

// MARK: - Conform to ShapeStyle
extension FoundationUI.DefaultTheme.Variable.Color {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        resolveColorValue(in: environment)
    }
    
    public func resolveColor(in environment: EnvironmentValues) -> SwiftUI.Color {
        resolveColorValue(in: environment).resolveColor(in: environment)
    }
    
    private func resolveColorValue(in environment: EnvironmentValues) -> ColorValue {
        if let variant {
            var tint = environment.dynamicTint.color
            if color.light.hue != 1 {
                tint = tint.hue(color.light.hue)
            }
            if color.light.saturation != 1 {
                tint = tint.saturation(color.light.saturation)
            }
            if color.light.brightness != 1 {
                tint = tint.brightness(color.light.brightness)
            }
            if color.light.opacity != 1 {
                tint = tint.opacity(color.light.opacity, method: .multiply)
            }
            if color.light.opacity != 1 {
                tint = tint.opacity(color.light.opacity)
            }
            var adjusted = variant.adjust(tint).copyBlendMode(from: color)
            if let colorScheme {
                adjusted = adjusted.colorScheme(colorScheme)
            }
            return adjusted
        } else {
            return color
        }
    }
}

// MARK: - Defaults

public protocol FoundationColorDefaultValues {
    static var primary: Self { get }
}

public extension FoundationColorDefaultValues where Self == FoundationUI.DefaultTheme.Variable.Color {
    static var primary: Self {
        .init(
            light: .init(grayscale: 0.5),
            dark: .init(grayscale: 0.57)
        )
    }
}

extension FoundationUI.DefaultTheme.Variable.Color: FoundationColorDefaultValues {
    public static var clear: Self {
        .init(.init(grayscale: 0, opacity: 0))
    }
    
    public static var black: Self {
        .init(.init(grayscale: 0, opacity: 1))
    }
    
    public static var white: Self {
        .init(.init(grayscale: 1, opacity: 1))
    }
    
    public static var gray: Self {
        .init(.init(grayscale: 0.5, opacity: 1))
    }
}

internal extension FoundationUI.DefaultTheme.Variable.Color {
    static var blue: Self {
        .init(
            light: .init(red8bit: 0, green: 122, blue: 255),
            dark: .init(red8bit: 10, green: 132, blue: 255)
        )
    }
    static var orange: Self {
        .init(
            light: .init(red8bit: 255, green: 149, blue: 0),
            dark: .init(red8bit: 255, green: 159, blue: 10)
        )
    }
    static var red: Self {
        .init(
            light: .init(red8bit: 255, green: 59, blue: 48),
            dark: .init(red8bit: 255, green: 69, blue: 58)
        )
    }
}

public protocol FoundationColorDefaultVariant {
    static var backgroundSubtle: Self { get }
    static var background: Self { get }
    static var backgroundProminent: Self { get }
    
    static var fillSubtle: Self { get }
    static var fill: Self { get }
    static var fillProminent: Self { get }
    
    static var borderSubtle:Self { get }
    static var border: Self { get }
    static var borderProminent: Self { get }
    
    static var solid: Self { get }
    
    static var textSubtle: Self { get }
    static var text: Self { get }
    static var textProminent: Self { get }
}

extension FoundationUI.DefaultTheme.Variable.Color.Variant: FoundationColorDefaultVariant {}

public extension FoundationColorDefaultVariant where Self == FoundationUI.DefaultTheme.Variable.Color.Variant {
    static var backgroundSubtle: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.98 : 0.97 }, method: .override)
                .saturation(0.02)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.07 : 0.05 }, method: .override)
                .saturation(0.5)
            }
        )
    }
    static var background: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.975 : 0.95 }, method: .override)
                .saturation(0.06)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.18 : 0.12 }, method: .override)
            }
        )
    }
    static var backgroundProminent: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.96 : 0.92 }, method: .override)
                .saturation(0.1)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.32 : 0.18 }, method: .override)
            }
        )
    }
    static var fillSubtle: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.9 }, method: .override)
                .saturation(0.18)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.44 : 0.22 }, method: .override)
            }
        )
    }
    static var fill: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.94 : 0.87 }, method: .override)
                .saturation(0.35)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.49 : 0.27 }, method: .override)
                .saturation(1)
            }
        )
    }
    static var fillProminent: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.92 : 0.83 }, method: .override)
                .saturation(0.5)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.54 : 0.32 }, method: .override)
                .saturation(1)
            }
        )
    }
    static var borderSubtle: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.82 : 0.77 }, method: .override)
                .saturation(0.58)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.62 : 0.4 }, method: .override)
                .saturation(1)
            }
        )
    }
    static var border: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.78 : 0.7 }, method: .override)
                .saturation(0.8)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.7 : 0.45 }, method: .override)
                .saturation(0.99)
            }
        )
    }
    static var borderProminent: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.7 : 0.6 }, method: .override)
                .saturation(0.9)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.76 : 0.49 }, method: .override)
                .saturation(1)
            }
        )
    }
    static var solid: Self { .init { $0 } }
    
    static var textSubtle: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.6 : 0.35 }, method: .override)
                .saturation(1)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.85 }, method: .override)
                .saturation(0.25)
            }
        )
    }
    
    static var text: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.38 : 0.24 }, method: .override)
                .saturation(0.95)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.96 : 0.95 }, method: .override)
                .saturation(0.15)
            }
        )
    }
    
    static var textProminent: Self {
        .init(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.24 : 0.12 }, method: .override)
                .saturation(0.8)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.97 : 0.99 }, method: .override)
                .saturation(0.05)
            }
        )
    }
}

// MARK: - Previews

struct ColorScalePreview: PreviewProvider {
    struct ColorPatch: View {
        let color: FoundationUI.Theme.Color
        var body: some View {
            FoundationUI.Shape.roundedRectangle(.regular)
                .foundation(.foreground(color))
                .foundation(.size(.small))
        }
    }
    struct Scale: View {
        @Environment(\.dynamicTint) private var tint
        private let defaultScale: [FoundationUI.Theme.Color.Variant] = [
            .backgroundSubtle, .background, .backgroundProminent,
            .fillSubtle, .fill, .fillProminent,
            .borderSubtle, .border, .borderProminent,
            .solid,
            .textSubtle, .text, .textProminent
        ]
        struct ScaleSwatch: View {
            @Environment(\.dynamicTint) private var tint
            let variant: FoundationUI.Theme.Color.Variant
            
            init(_ variant: FoundationUI.Theme.Color.Variant) {
                self.variant = variant
            }

            var body: some View {
                ZStack {
                    Rectangle()
                        .foundation(.foreground(.dynamic(variant)))
                        .foundation(.size(isSolid ? .small.up(.quarter) : .small))
                    if isSolid {
                        VStack {
                            let tint = tint.variant(variant)
                            let color = tint.color
                            let h = String(format: "%.2f", color.light.saturation)
                            let s = String(format: "%.2f", color.light.saturation)
                            let b = String(format: "%.2f", color.light.brightness)
                            let o = String(format: "%.2f", color.light.opacity)
                            Text(h).fixedSize()
                            Text(s).fixedSize()
                            Text(b).fixedSize()
                            Text(o).fixedSize()
                        }
                        .foundation(.font(.init(.system(size: 7))))
                        .foundation(.foreground(.dynamic(.backgroundSubtle)))
                    }
                }
            }
            
            private var isSolid: Bool {
                let color = Theme.color(.primary)
                
                return color.variant(.solid) == color.variant(variant)
            }
        }
        var body: some View {
            VStack(spacing: 0) {
                TextSample()
                Divider()
                    .foundation(.size(width: .small))
                    .foundation(.foreground(.dynamic(.borderSubtle)))
                ScaleSwatch(.backgroundSubtle)
                ScaleSwatch(.background)
                ScaleSwatch(.backgroundProminent)
                ScaleSwatch(.fillSubtle)
                ScaleSwatch(.fill)
                ScaleSwatch(.fillProminent)
                ScaleSwatch(.borderSubtle)
                ScaleSwatch(.border)
                ScaleSwatch(.borderProminent)
                ScaleSwatch(.solid)
                ScaleSwatch(.textSubtle)
                ScaleSwatch(.text)
                ScaleSwatch(.textProminent)
                
            }
            .foundation(.padding(.regular))
            .foundation(.background(.dynamic(.backgroundSubtle)))
        }
    }
    
    struct TextSample: View {
        var body: some View {
            Text("Text")
                .foundation(.padding(.regular))
                .foundation(.foreground(.dynamic(.text)))
                .foundation(.font(.small))
                .fixedSize()
        }
    }
    
    struct ScaleSet: View {
        var body: some View {
            HStack(spacing: 0) {
                Scale()._colorScheme(.light)
//                Scale()._colorScheme(.lightAccessible)
                Scale()._colorScheme(.dark)
//                Scale()._colorScheme(.darkAccessible)
            }
        }
    }
    
    static var previews: some View {
        HStack(spacing: 0) {
            ScaleSet()
                .foundation(.tint(.red))
            if #available(macOS 14.0, *) {
                ScaleSet()
                    .foundation(.tintColor(.accentColor))
                ScaleSet()
                    .foundation(.tintColor(.orange))
                ScaleSet()
                    .foundation(.tintColor(.brown))
                ScaleSet()
                    .foundation(.tintColor(.indigo))
                ScaleSet()
                    .foundation(.tintColor(.purple))
                ScaleSet()
                    .foundation(.tintColor(.pink))
                ScaleSet()
                    .foundation(.tintColor(.yellow))
                ScaleSet()
                    .foundation(.tintColor(.cyan))
                ScaleSet()
                    .foundation(.tintColor(.mint))
                ScaleSet()
                    .foundation(.tintColor(.teal))
                ScaleSet()
                    .foundation(.tint(.init(.init(hue: 0.4, saturation: 0.5, brightness: 0.75))))
            }
            ScaleSet()
                .foundation(.tint(.primary))
        }
        .foundation(.clip(.rect(cornerRadius: 8)))
        .scenePadding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

extension FoundationUI.DefaultTheme.Variable.Color.Variant {
    static let bg = Self.modifier(
        light: .adjust({ $0.brightness(1.2).saturation(0.8) }),
        dark: .adjust({ $0.brightness(0.2) })
    )
    
    static let bg2 = Self.modifier(
        light: .adjust({ $0.brightness(0.2) }),
        dark: .color(.orange.opacity(0.5))
    )
}

struct ThemeColorPreview: PreviewProvider {
    private static func test(_ value: FoundationUI.DefaultTheme.Variable.Color) -> FoundationUI.DefaultTheme.Variable.Color {
        value
    }
    static var previews: some View {
        VStack {
            HStack {
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.blue.variant(.bg2).opacity(0.4).colorScheme(.light)))
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.blue.variant(.bg2).opacity(1).colorScheme(.dark)))
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.dynamic(.bg2).opacity(0.5).colorScheme(.light)))
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.dynamic(.bg2).opacity(0.5).colorScheme(.dark)))
            }
            HStack {
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.primary.variant(.background).colorScheme(.light)))
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.primary.variant(.background).colorScheme(.dark)))
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.dynamic(.background).colorScheme(.light)))
                Rectangle().foundation(.size(.regular)).foundation(.foreground(.dynamic(.background).colorScheme(.dark)))
            }
            // - Blend Mode
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.red).variant(.fill).colorScheme(.light))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.red).variant(.fill))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.dynamic(.fill).colorScheme(.light)))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.dynamic(.fill)))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.red).variant(.fill).blendMode(.softLight))
            Rectangle().foundation(.size(.small)).foregroundStyle(Theme.color(.red.variant(.fill).blendMode(.softLight)))
            Rectangle().foundation(.size(.small)).foregroundStyle(Theme.color(.dynamic(.fill).blendMode(.softLight)))
            Rectangle().foundation(.size(.small)).foregroundStyle(Theme.color(.dynamic(.fill).blendMode(.softLight)))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.red.blendMode(.softLight).variant(.fill)))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.red.variant(.fill).opacity(0.5).blendMode(.softLight)))
            Rectangle().foundation(.size(.small)).foregroundStyle(test(.dynamic(.fill).opacity(0.3).blendMode(.softLight)))
        }
        .foundation(.tint(.red))
//        .colorScheme(.dark)
        .padding()
    }
}
