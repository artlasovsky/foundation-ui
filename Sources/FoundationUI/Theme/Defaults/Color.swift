//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
    public struct Color: FoundationColorVariable {
        public var color: DynamicColor
        private var variant: Variant?
        private var colorScheme: FoundationColorScheme?
        
        public init(_ color: DynamicColor) {
            self.color = color
        }
        
        public static func from(color: SwiftUI.Color) -> Self {
            self.init(.from(color: color))
        }
    }
}

// MARK: Initializers
public extension Theme.Color {
    init(_ universal: ColorComponents) {
        color = .init(universal)
    }
    
    init(light: ColorComponents, dark: ColorComponents, lightAccessible: ColorComponents? = nil, darkAccessible: ColorComponents? = nil) {
        color = .init(
            light: light,
            dark: dark,
            lightAccessible: lightAccessible,
            darkAccessible: darkAccessible
        )
    }
}

// MARK: Adjust Components
public extension Theme.Color {
    private func updateValue(_ value: DynamicColor) -> Self {
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
    
    func colorScheme(_ colorScheme: FoundationColorScheme) -> Self {
        var copy = updateValue(color.colorScheme(colorScheme))
        copy.colorScheme = colorScheme
        return copy
    }
    
    func blendMode(_ mode: BlendMode) -> Self {
        updateValue(color.blendMode(mode))
    }
    
    func blendMode(_ mode: DynamicColor.ExtendedBlendMode) -> Self {
        updateValue(color.blendMode(mode))
    }
}

// MARK: Conform to ShapeStyle
extension Theme.Color {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        resolveColorValue(in: environment)
    }
    
    public func resolveColor(in environment: EnvironmentValues) -> SwiftUI.Color {
        resolveColorValue(in: environment).resolveColor(in: environment)
    }
    
    private func resolveColorValue(in environment: EnvironmentValues) -> ColorValue {
        if let variant {
            let tint = environment.dynamicTint.color
            var adjusted = variant.adjust(tint)
            let components = color.resolveComponents(in: .init(environment))
            if components.hue != 1 {
                adjusted = adjusted.hue(components.hue)
            }
            if components.saturation != 1 {
                adjusted = adjusted.saturation(components.saturation)
            }
            if components.brightness != 1 {
                adjusted = adjusted.brightness(components.brightness)
            }
            if components.opacity != 1 {
                adjusted = adjusted.opacity(components.opacity)
            }
            if let colorScheme {
                adjusted = adjusted.colorScheme(colorScheme)
            }
            return adjusted.copyBlendMode(from: color)
        } else {
            return color
        }
    }
}

// MARK: Modifiers
extension Theme.Color {
    public static func modified(_ universal: Variant.Modifier) -> Self {
        .dynamic(.modified(universal))
    }
    
    public static func modified(
        light: Variant.Modifier,
        dark: Variant.Modifier,
        lightAccessible: Variant.Modifier? = nil,
        darkAccessible: Variant.Modifier? = nil
    ) -> Self {
        .dynamic(
            .modified(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
    
    public static func modifiedColor(_ universal: Theme.Color) -> Self {
        .dynamic(.modifiedColor(universal))
    }
    
    public static func modifiedColor(
        light: Theme.Color,
        dark: Theme.Color,
        lightAccessible: Theme.Color? = nil,
        darkAccessible: Theme.Color? = nil
    ) -> Self {
        .dynamic(
            .modifiedColor(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
    
    public static func modifiedSource(_ universal: @escaping Variant.ComponentAdjust) -> Self {
        .dynamic(.modifiedSource(universal))
    }
    
    public static func modifiedSource(
        light: @escaping Variant.ComponentAdjust,
        dark: @escaping Variant.ComponentAdjust,
        lightAccessible: Variant.ComponentAdjust? = nil,
        darkAccessible: Variant.ComponentAdjust? = nil
    ) -> Self {
        .dynamic(
            .modifiedSource(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
}

// MARK: Equatable
extension Theme.Color: Equatable {
    public static func == (lhs: Theme.Color, rhs: Theme.Color) -> Bool {
        if let lhsVariant = lhs.variant, let rhsVariant = rhs.variant {
            lhsVariant.adjust(lhs.color) == rhsVariant.adjust(rhs.color)
        } else {
            lhs.color == rhs.color
        }
    }
}

// MARK: - Variant

public extension Theme.Color {
    struct Variant: Sendable {
        public typealias ColorValue = DynamicColor
        public typealias ComponentAdjust = (ColorValue.Components) -> ColorValue.Components
        
        var adjust: @Sendable (ColorValue) -> ColorValue
        
        private init(adjust: @escaping @Sendable (ColorValue) -> ColorValue) {
            self.adjust = adjust
        }
        
        private init(
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

extension Theme.Color.Variant: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(adjust(.from(color: .accentColor)))
        hasher.combine(adjust(.from(color: .gray)))
    }
}

extension Theme.Color.Variant {
    public typealias Variant = Theme.Color.Variant
    public enum Modifier {
        case source(ComponentAdjust)
        case color(Theme.Color)
        
        func resolve(_ source: ColorComponents, in colorScheme: FoundationColorScheme) -> ColorComponents {
            switch self {
            case .source(let adjust):
                return adjust(source)
            case .color(let color):
                var environment: EnvironmentValues = .init(colorScheme: colorScheme.colorScheme, colorSchemeContrast: colorScheme.colorSchemeContrast)
                environment.dynamicTint = .init(source)
                let components = color.resolveColorValue(in: environment).resolveComponents(in: colorScheme)
                return source.changes.apply(to: components)
            }
        }
    }
    
    public static func modified(
        light: Modifier,
        dark: Modifier,
        lightAccessible: Modifier? = nil,
        darkAccessible: Modifier? = nil
    ) -> Theme.Color.Variant {
        self.init(
            light: { light.resolve($0, in: .light) },
            dark: { dark.resolve($0, in: .dark) },
            lightAccessible: { (lightAccessible ?? light).resolve($0, in: .lightAccessible) },
            darkAccessible: { (darkAccessible ?? dark).resolve($0, in: .darkAccessible) }
        )
    }
    
    public static func modified(_ modifier: Modifier) -> Variant {
        .modified(
            light: modifier,
            dark: modifier
        )
    }
    
    public static func modifiedColor(_ color: Theme.Color) -> Variant {
        .modified(.color(color))
    }
    
    public static func modifiedColor(
        light: Theme.Color,
        dark: Theme.Color,
        lightAccessible: Theme.Color? = nil,
        darkAccessible: Theme.Color? = nil
    ) -> Variant {
        .modified(
            light: .color(light),
            dark: .color(dark),
            lightAccessible: .color(lightAccessible ?? light),
            darkAccessible: .color(darkAccessible ?? dark)
        )
    }
    
    public static func modifiedSource(_ adjust: @escaping Variant.ComponentAdjust) -> Variant {
        .modified(.source(adjust))
    }
    
    public static func modifiedSource(
        light: @escaping Variant.ComponentAdjust,
        dark: @escaping Variant.ComponentAdjust,
        lightAccessible: Variant.ComponentAdjust? = nil,
        darkAccessible: Variant.ComponentAdjust? = nil
    ) -> Variant {
        .modified(
            light: .source(light),
            dark: .source(dark),
            lightAccessible: .source(lightAccessible ?? light),
            darkAccessible: .source(darkAccessible ?? dark)
        )
    }
}

// MARK: - Defaults

public protocol FoundationColorDefaultValues {
    static var primary: Self { get }
}

public extension FoundationColorDefaultValues where Self == Theme.Color {
    static var primary: Self {
        .init(
            light: .init(grayscale: 0.5),
            dark: .init(grayscale: 0.57)
        )
    }
}

extension Theme.Color: FoundationColorDefaultValues {
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

internal extension Theme.Color {
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

extension Theme.Color.Variant: FoundationColorDefaultVariant {}

public extension FoundationColorDefaultVariant where Self == Theme.Color.Variant {
    static var backgroundSubtle: Self {
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
    static var solid: Self { .modifiedSource { $0 } }
    
    static var textSubtle: Self {
        .modifiedSource(
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
        .modifiedSource(
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
        .modifiedSource(
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
        let color: Theme.Color
        var body: some View {
            RoundedRectangle.foundation(.regular)
                .foundation(.foreground(color))
                .foundation(.size(.small))
        }
    }
    struct Scale: View {
        @Environment(\.dynamicTint) private var tint
        private let defaultScale: [Theme.Color.Variant] = [
            .backgroundSubtle, .background, .backgroundProminent,
            .fillSubtle, .fill, .fillProminent,
            .borderSubtle, .border, .borderProminent,
            .solid,
            .textSubtle, .text, .textProminent
        ]
        struct ScaleSwatch: View {
            @Environment(\.dynamicTint) private var tint
            let variant: Theme.Color.Variant
            
            init(_ variant: Theme.Color.Variant) {
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
                let color = Theme.default.color(.primary)
                
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
