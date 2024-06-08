//
//  ColorTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Extensions
public extension Color {
    typealias foundation = FoundationUI.DynamicColor
}

public extension ShapeStyle {
    typealias foundation = FoundationUI.DynamicColor
}

public protocol DynamicColorDefaults {
    typealias VariationKeyPath = KeyPath<FoundationUI.DynamicColor, FoundationUI.DynamicColor>
    func makeVariation(
        light: FoundationUI.DynamicColor.Adjustment,
        dark: FoundationUI.DynamicColor.Adjustment,
        lightAccessible: FoundationUI.DynamicColor.Adjustment?,
        darkAccessible: FoundationUI.DynamicColor.Adjustment?
    ) -> Self
}

extension FoundationUI.DynamicColor: DynamicColorDefaults {}

/// Tint are static extensions of `DynamicColor`
public extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var primary: Self { .init(
        light: .init(grayscale: 0.5),
        dark: .init(grayscale: 0.57),
        lightAccessible: .init(grayscale: 0.39),
        darkAccessible: .init(grayscale: 0.64)
    ) }
    
    static var clear: Self {
        .init(.init(grayscale: 0, opacity: 0))
    }
    
    static var black: Self {
        .init(.init(grayscale: 0, opacity: 1))
    }
    
    static var white: Self {
        .init(.init(grayscale: 1, opacity: 1))
    }
    
    static var gray: Self {
        .init(.init(grayscale: 0.5, opacity: 1))
    }
}

internal extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var red: Self {
        .init(
            light: .init(red8bit: 255, green: 59, blue: 48),
            dark: .init(red8bit: 255, green: 69, blue: 58)
        )
    }
}

/// Variations are extention of `DynamicColor`
public extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var environmentDefault: Self {
        primary
    }
    
    /// App background
    var backgroundFaded: Self { makeVariation(
        light: { $0.multiply(saturation: 0.03).override(brightness: $0.isSaturated ? 1 : 0.99) },
        dark: { $0.multiply(saturation: 0.3).override(brightness: $0.isSaturated ? 0.06 : 0.05) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Content background
    var background: Self { makeVariation(
        light: { $0.multiply(saturation: 0.06, brightness: 2.18 ) },
        dark: { $0.multiply(saturation: 0.35, brightness: 0.2) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Subtle background
    var backgroundEmphasized: Self { makeVariation(
        light: { $0.multiply( saturation: 0.2, brightness: 2.1 ) },
        dark: { $0.multiply( saturation: 0.45, brightness: 0.25 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// UI element background
    var fillFaded: Self { makeVariation(
        light: { $0.multiply( saturation: 0.3, brightness: 1.9 ) },
        dark: { $0.multiply( saturation: 0.5, brightness: 0.32 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Hovered UI element background
    var fill: Self { makeVariation(
        light: { $0.multiply( saturation: 0.4, brightness: 1.8 ) },
        dark: { $0.multiply( saturation: 0.6, brightness: 0.45 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Active / Selected UI element background
    var fillEmphasized: Self { makeVariation(
        light: { $0.multiply( saturation: 0.5, brightness: 1.7 )},
        dark: { $0.multiply( saturation: 0.7, brightness: 0.55 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Subtle borders and separators
    var borderFaded: Self { makeVariation(
        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// UI element border and focus rings
    var border: Self { makeVariation(
        light: { $0.multiply( saturation: 0.8, brightness: 1.4 ) },
        dark: { $0.multiply( saturation: 0.85, brightness: 0.8 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Hovered UI element border
    var borderEmphasized: Self { makeVariation(
        light: { $0.multiply(saturation: 0.9, brightness: 1.1 ) },
        dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Solid backgrounds
    var solid: Self { self }
    /// Hovered solid backgrounds
    var solidEmphasized: Self { makeVariation(
        light: { $0.multiply(saturation: 1.1, brightness: 0.9) },
        dark: { $0.multiply(saturation: 0.95, brightness: 1.1) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Low-contrast text
    var textFaded: Self { solidEmphasized }
    /// Normal text
    var text: Self { makeVariation(
        light: { $0.multiply(saturation: 0.9, brightness: 0.76) },
        dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// High-contrast text
    var textEmphasized: Self { makeVariation(
        light: { $0.multiply(saturation: 0.95, brightness: 0.35) },
        dark: { $0.multiply(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    
    var clear: Self { makeVariation(
        light: { $0.override(opacity: 0) },
        dark: { $0.override(opacity: 0) },
        lightAccessible: { $0.override(opacity: 0) },
        darkAccessible: { $0.override(opacity: 0) }
    ) }
}

// MARK: - Preview

internal extension DynamicColorDefaults {
    var defaultScale: [Self.VariationKeyPath] { [
         \.backgroundFaded, \.background, \.backgroundEmphasized,
         \.fillFaded, \.fill, \.fillEmphasized,
         \.borderFaded, \.border, \.borderEmphasized,
         \.solid, \.solidEmphasized,
         \.text, \.textEmphasized
    ]}
}

// MARK: - Color Variable

//public protocol FoundationUIColorSetDefaults {
//    static var primary: FoundationUI.ColorSet { get }
//}
//public extension FoundationUIColorSetDefaults {
//    static var primary: FoundationUI.ColorSet { .init(
//        light: .init(grayscale: 0.5),
//        dark: .init(grayscale: 0.57),
//        lightAccessible: .init(grayscale: 0.39),
//        darkAccessible: .init(grayscale: 0.64)
//    ) }
//    
//    static var white: FoundationUI.ColorSet { .init(universal: .init(grayscale: 1)) }
//    static var black: FoundationUI.ColorSet { .init(universal: .init(grayscale: 0)) }
//    static var gray: FoundationUI.ColorSet { .init(universal: .init(grayscale: 0.5)) }
//    
//    static var clear: FoundationUI.ColorSet {
//        .init(universal: .init(grayscale: 0, opacity: 0))
//    }
//}
//
//extension FoundationUI.ColorSet: FoundationUIColorSetDefaults {}
//
//// MARK: - Color Variable Scale
//
//public protocol FoundationUITintedColorSetDefaults {}
//
//public extension FoundationUITintedColorSetDefaults {
//    internal static var defaultTint: FoundationUI.TintedColorSet { .tint(.primary) }
//    
//    /// App background
//    static var backgroundFaded: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
//        dark: { $0.multiply(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
//    ) }
//    /// Content background
//    static var background: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply(saturation: 0.06, brightness: 2.18 ) },
//        dark: { $0.multiply(saturation: 0.35, brightness: 0.2)}
//    ) }
//    /// Subtle background
//    static var backgroundEmphasized: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.2, brightness: 2.1 ) },
//        dark: { $0.multiply( saturation: 0.45, brightness: 0.25 ) }
//    ) }
//    /// UI element background
//    static var fillFaded: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.3, brightness: 1.9 ) },
//        dark: { $0.multiply( saturation: 0.5, brightness: 0.32 ) }
//    ) }
//    /// Hovered UI element background
//    static var fill: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.4, brightness: 1.8 ) },
//        dark: { $0.multiply( saturation: 0.6, brightness: 0.45 ) }
//    ) }
//    /// Active / Selected UI element background
//    static var fillEmphasized: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.5, brightness: 1.7 )},
//        dark: { $0.multiply( saturation: 0.7, brightness: 0.55 ) }
//    ) }
//    /// Subtle borders and separators
//    static var borderFaded: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
//        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
//    ) }
//    /// Subtle borders and separators
//    static var borderFaded_: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
//        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
//    ) }
//    /// UI element border and focus rings
//    static var border: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply( saturation: 0.8, brightness: 1.4 ) },
//        dark: { $0.multiply( saturation: 0.85, brightness: 0.8 ) }
//    ) }
//    /// Hovered UI element border
//    static var borderEmphasized: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply(saturation: 0.9, brightness: 1.1 ) },
//        dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) }
//    ) }
//    /// Solid backgrounds
//    static var solid: FoundationUI.TintedColorSet {
//        Self.defaultTint
//    }
//    /// Hovered solid backgrounds
//    static var solidEmphasized: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply(saturation: 1.1, brightness: 0.9) },
//        dark: { $0.multiply(saturation: 0.95, brightness: 1.1) }
//    ) }
//    /// Low-contrast text
//    static var textFaded: FoundationUI.TintedColorSet { Self.solidEmphasized }
//    /// Normal text
//    static var text: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply(saturation: 0.9, brightness: 0.76) },
//        dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
//    ) }
//    /// High-contrast text
//    static var textEmphasized: FoundationUI.TintedColorSet { defaultTint.adjust(
//        light: { $0.multiply(saturation: 0.95, brightness: 0.35) },
//        dark: { $0.multiply(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
//    ) }
//}
//
//extension FoundationUI.TintedColorSet: FoundationUITintedColorSetDefaults {}
//
//// MARK: - Preview
//
//internal extension FoundationUI.TintedColorSet {
//    static let all: [Self] = [
//        Self.backgroundFaded, Self.background, Self.backgroundEmphasized,
//        Self.fillFaded, Self.fill, Self.fillEmphasized,
//        Self.borderFaded, Self.border, Self.borderEmphasized,
//        Self.solid, Self.solidEmphasized, /*.textFaded,*/
//        Self.text, Self.textEmphasized
//    ]
//}
//
//private extension FoundationUI.Variable.Font {
//    static let captionMono = Self(.caption.monospaced())
//    static let colorComponentsMono = Self(.system(size: 5).monospaced())
//}
//
//@available(macOS 14.0, iOS 17.0, *)
//struct ColorThemePreview: PreviewProvider {
//    struct ColorScale: View {
//        @Environment(\.self) private var env
//        
//        var colorScheme: FoundationUI.ColorScheme {
//            .init(env)
//        }
//        var body: some View {
//            VStack(spacing: 0) {
//                Text(colorScheme.rawValue)
//                    .foundation(.foreground(.text))
//                    .foundation(.padding(.regular).edges(.bottom))
//                    .foundation(.font(.captionMono))
//                HStack(spacing: 0) {
//                    ForEach(FoundationUI.TintedColorSet.all, id: \.self) { sample in
//                        Rectangle().foundation(.size(width: .small,height: .small))
//                            .foundation(.foreground(sample))
////                            .overlay {
////                                VStack {
////                                    Text(String(format: "%.2f", sample.components(.init(env)).hue))
////                                    Text(String(format: "%.2f", sample.components(.init(env)).saturation))
////                                    Text(String(format: "%.2f", sample.components(.init(env)).brightness))
////                                    Text(String(format: "%.2f", sample.components(.init(env)).opacity))
////                                }
////                                .foundation(.font(.colorComponentsMono))
////                                .padding(.trailing, 2)
////                            }
//                    }
//                }
//            }
//            .foundation(.padding(.regular).edges(.vertical))
//            .foundation(.padding(.large).edges(.horizontal))
//            .foundation(.background(.backgroundFaded))
//            .fixedSize()
//        }
//    }
//    
//    static var previews: some View {
//        let tintColor = FoundationUI.ColorSet(color: .accentColor)
//        VStack(spacing: 0) {
//            VStack(spacing: 0) {
//                ColorScale()
//                ColorScale().foundation(.tint(tintColor))
//            }
//            ._colorScheme(.light)
//            VStack(spacing: 0) {
//                ColorScale()
//                ColorScale().foundation(.tint(tintColor))
//            }
//            ._colorScheme(.lightAccessible)
//            VStack(spacing: 0) {
//                ColorScale()
//                ColorScale().foundation(.tint(tintColor))
//            }
//            ._colorScheme(.dark)
//            VStack(spacing: 0) {
//                ColorScale()
//                ColorScale().foundation(.tint(tintColor))
//            }
//            ._colorScheme(.darkAccessible)
//        }
//    }
//}
