//
//  ColorTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Color Variable

public protocol TrussUIColorSetDefaults {
    static var primary: TrussUI.ColorSet { get }
}
public extension TrussUIColorSetDefaults {
    static var primary: TrussUI.ColorSet { .init(
        light: .init(grayscale: 0.5),
        dark: .init(grayscale: 0.57),
        lightAccessible: .init(grayscale: 0.39),
        darkAccessible: .init(grayscale: 0.64)
    ) }
    
    static var white: TrussUI.ColorSet { .init(.init(grayscale: 1)) }
    static var black: TrussUI.ColorSet { .init(.init(grayscale: 0)) }
    static var gray: TrussUI.ColorSet { .init(.init(grayscale: 0.5)) }
    
    static var clear: TrussUI.ColorSet {
        .init(.init(hue: 0, saturation: 0, brightness: 0, opacity: 0))
    }
}

extension TrussUI.ColorSet: TrussUIColorSetDefaults {}

// MARK: - Color Variable Scale

public protocol TrussUITintedColorSetDefaults {}

public extension TrussUITintedColorSetDefaults {
    internal static var defaultTint: TrussUI.TintedColorSet { .tint(.primary) }
    
    /// App background
    static var backgroundFaded: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
        dark: { $0.multiply(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
    ) }
    /// Content background
    static var background: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply(saturation: 0.06, brightness: 2.18 ) },
        dark: { $0.multiply(saturation: 0.35, brightness: 0.2)}
    ) }
    /// Subtle background
    static var backgroundEmphasized: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.2, brightness: 2.1 ) },
        dark: { $0.multiply( saturation: 0.45, brightness: 0.25 ) }
    ) }
    /// UI element background
    static var fillFaded: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.3, brightness: 1.9 ) },
        dark: { $0.multiply( saturation: 0.5, brightness: 0.32 ) }
    ) }
    /// Hovered UI element background
    static var fill: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.4, brightness: 1.8 ) },
        dark: { $0.multiply( saturation: 0.6, brightness: 0.45 ) }
    ) }
    /// Active / Selected UI element background
    static var fillEmphasized: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.5, brightness: 1.7 )},
        dark: { $0.multiply( saturation: 0.7, brightness: 0.55 ) }
    ) }
    /// Subtle borders and separators
    static var borderFaded: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
    ) }
    /// Subtle borders and separators
    static var borderFaded_: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
    ) }
    /// UI element border and focus rings
    static var border: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply( saturation: 0.8, brightness: 1.4 ) },
        dark: { $0.multiply( saturation: 0.85, brightness: 0.8 ) }
    ) }
    /// Hovered UI element border
    static var borderEmphasized: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply(saturation: 0.9, brightness: 1.1 ) },
        dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) }
    ) }
    /// Solid backgrounds
    static var solid: TrussUI.TintedColorSet {
        Self.defaultTint
    }
    /// Hovered solid backgrounds
    static var solidEmphasized: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply(saturation: 1.1, brightness: 0.9) },
        dark: { $0.multiply(saturation: 0.95, brightness: 1.1) }
    ) }
    /// Low-contrast text
    static var textFaded: TrussUI.TintedColorSet { Self.solidEmphasized }
    /// Normal text
    static var text: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply(saturation: 0.9, brightness: 0.76) },
        dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
    ) }
    /// High-contrast text
    static var textEmphasized: TrussUI.TintedColorSet { defaultTint.adjust(
        light: { $0.multiply(saturation: 0.95, brightness: 0.35) },
        dark: { $0.multiply(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
    ) }
}

extension TrussUI.TintedColorSet: TrussUITintedColorSetDefaults {}

// MARK: - Preview

internal extension TrussUI.TintedColorSet {
    static let all: [Self] = [
        Self.backgroundFaded, Self.background, Self.backgroundEmphasized,
        Self.fillFaded, Self.fill, Self.fillEmphasized,
        Self.borderFaded, Self.border, Self.borderEmphasized,
        Self.solid, Self.solidEmphasized, /*.textFaded,*/
        Self.text, Self.textEmphasized
    ]
}

private extension TrussUI.Variable.Font {
    static let captionMono = Self(.caption.monospaced())
    static let colorComponentsMono = Self(.system(size: 5).monospaced())
}

@available(macOS 14.0, *)
struct ColorThemePreview: PreviewProvider {
    struct ColorScale: View {
        @Environment(\.self) private var env
        
        var colorScheme: TrussUI.ColorScheme {
            .init(env)
        }
        var body: some View {
            VStack(spacing: 0) {
                Text(colorScheme.rawValue)
                    .truss(.foreground(.text))
                    .truss(.padding(.regular, .bottom))
                    .truss(.font(.captionMono))
                HStack(spacing: 0) {
                    ForEach(TrussUI.TintedColorSet.all, id: \.self) { sample in
                        Rectangle().truss(.size(width: .small,height: .small))
                            .truss(.foreground(sample))
//                            .overlay {
//                                VStack {
//                                    Text(String(format: "%.2f", sample.components(.init(env)).hue))
//                                    Text(String(format: "%.2f", sample.components(.init(env)).saturation))
//                                    Text(String(format: "%.2f", sample.components(.init(env)).brightness))
//                                    Text(String(format: "%.2f", sample.components(.init(env)).opacity))
//                                }
//                                .truss(.font(.colorComponentsMono))
//                                .padding(.trailing, 2)
//                            }
                    }
                }
            }
            .truss(.padding(.regular, .vertical))
            .truss(.padding(.large, .horizontal))
            .truss(.background(.backgroundFaded))
            .fixedSize()
        }
    }
    
    static var previews: some View {
        let tintColor = TrussUI.ColorSet(color: .accentColor)
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ColorScale()
                ColorScale().truss(.tint(tintColor))
            }
            ._colorScheme(.light)
            VStack(spacing: 0) {
                ColorScale()
                ColorScale().truss(.tint(tintColor))
            }
            ._colorScheme(.lightAccessible)
            VStack(spacing: 0) {
                ColorScale()
                ColorScale().truss(.tint(tintColor))
            }
            ._colorScheme(.dark)
            VStack(spacing: 0) {
                ColorScale()
                ColorScale().truss(.tint(tintColor))
            }
            ._colorScheme(.darkAccessible)
        }
    }
}
