//
//  ColorTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Color Variable

public protocol TrussUIColorVariableDefaults {
    static var primary: TrussUI.ColorVariable { get }
}
public extension TrussUIColorVariableDefaults {
    static var primary: TrussUI.ColorVariable { .init(
        light: .init(grayscale: 0.5),
        dark: .init(grayscale: 0.57),
        lightAccessible: .init(grayscale: 0.39),
        darkAccessible: .init(grayscale: 0.64)
    ) }
    
    static var white: TrussUI.ColorVariable { .init(.init(grayscale: 1)) }
    static var black: TrussUI.ColorVariable { .init(.init(grayscale: 0)) }
    static var gray: TrussUI.ColorVariable { .init(.init(grayscale: 0.5)) }
    
    static var clear: TrussUI.ColorVariable {
        .init(.init(hue: 0, saturation: 0, brightness: 0, alpha: 0))
    }
}

extension TrussUI.ColorVariable: TrussUIColorVariableDefaults {}

// MARK: - Color Variable Scale

public protocol TrussUIColorScaleDeaults {}

public extension TrussUIColorScaleDeaults {
    internal static var defaultTint: TrussUI.ColorScale { .variable(.primary) }
    
    /// App background
    static var backgroundFaded: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
        dark: { $0.multiply(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
    ) }
    /// Content background
    static var background: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply(saturation: 0.06, brightness: 2.18 ) },
        dark: { $0.multiply(saturation: 0.35, brightness: 0.2)}
    ) }
    /// Subtle background
    static var backgroundEmphasized: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.2, brightness: 2.1 ) },
        dark: { $0.multiply( saturation: 0.45, brightness: 0.25 ) }
    ) }
    /// UI element background
    static var fillFaded: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.3, brightness: 1.9 ) },
        dark: { $0.multiply( saturation: 0.5, brightness: 0.32 ) }
    ) }
    /// Hovered UI element background
    static var fill: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.4, brightness: 1.8 ) },
        dark: { $0.multiply( saturation: 0.6, brightness: 0.45 ) }
    ) }
    /// Active / Selected UI element background
    static var fillEmphasized: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.5, brightness: 1.7 )},
        dark: { $0.multiply( saturation: 0.7, brightness: 0.55 ) }
    ) }
    /// Subtle borders and separators
    static var borderFaded: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
    ) }
    /// Subtle borders and separators
    static var borderFaded_: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
    ) }
    /// UI element border and focus rings
    static var border: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply( saturation: 0.8, brightness: 1.4 ) },
        dark: { $0.multiply( saturation: 0.85, brightness: 0.8 ) }
    ) }
    /// Hovered UI element border
    static var borderEmphasized: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply(saturation: 0.9, brightness: 1.1 ) },
        dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) }
    ) }
    /// Solid backgrounds
    static var solid: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.adjustments },
        dark: { $0.adjustments }
    ) }
    /// Hovered solid backgrounds
    static var solidEmphasized: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply(saturation: 1.1, brightness: 0.9) },
        dark: { $0.multiply(saturation: 0.95, brightness: 1.1) }
    ) }
    /// Low-contrast text
    static var textFaded: TrussUI.ColorScale { Self.solidEmphasized }
    /// Normal text
    static var text: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply(saturation: 0.9, brightness: 0.76) },
        dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
    ) }
    /// High-contrast text
    static var textEmphasized: TrussUI.ColorScale { defaultTint.adjustments(
        light: { $0.multiply(saturation: 0.95, brightness: 0.35) },
        dark: { $0.multiply(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
    ) }
}

extension TrussUI.ColorScale: TrussUIColorScaleDeaults {}

// MARK: - Preview

internal extension TrussUI.ColorScale {
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
}

struct ColorThemePreview: PreviewProvider {
    struct ColorScale: View {
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.self) private var env
        var body: some View {
            VStack(spacing: 0) {
                Text(colorScheme == .dark ? "Dark" : "Light")
                    .truss(.foreground(.text))
                    .truss(.padding(.regular, .bottom))
                    .truss(.font(.captionMono))
                ForEach(TrussUI.ColorScale.all, id: \.self) { sample in
                    HStack(spacing: 0) {
                        VStack {
                            Text(String(format: "%.2f", sample.components(in: env).hue))
                            Text(String(format: "%.2f", sample.components(in: env).saturation))
                            Text(String(format: "%.2f", sample.components(in: env).brightness))
                            Text(String(format: "%.2f", sample.components(in: env).alpha))
                        }
                        .font(.system(size: 7).monospaced())
                        .padding(.trailing, 2)
                        Rectangle().frame(width: 40, height: 40)
                            .foregroundStyle(sample)
                    }
                }
            }
            .truss(.padding(.large))
            .truss(.background(.backgroundFaded))
        }
    }
    
    static var previews: some View {
        HStack(spacing: 0) {
            ColorScale().environment(\.colorScheme, .light)
            ColorScale()
                .environment(\.colorScheme, .light)
            if #available(macOS 14.0, *) {
                ColorScale().environment(\.colorScheme, .light)
                    .truss(.tintColor(.orange))
            }
            ColorScale().environment(\.colorScheme, .dark)
            if #available(macOS 14.0, *) {
                ColorScale().environment(\.colorScheme, .dark)
                    .truss(.tintColor(.blue))
            }
        }
    }
}
