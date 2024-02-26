//
//  ColorTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Color Variable

public extension TrussUI.ColorVariable {
    static let clear = Self(.init(hue: 0, saturation: 0, brightness: 0, alpha: 0))
}

// MARK: - Color Variable Scale

public extension TrussUI.ColorScale {
    private static let defaultTint = Self(tint: .primary)
    /// App background
    static let backgroundFaded = defaultTint.adjust(
        light: { $0.multiplied(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
        dark: { $0.multiplied(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
    )
    /// Content background
    static let background = defaultTint.adjust(
        light: { $0.multiplied(saturation: 0.06, brightness: 2.18 ) },
        dark: { $0.multiplied(saturation: 0.35, brightness: 0.2)}
    )
    /// Subtle background
    static let backgroundEmphasized = defaultTint.adjust(
        light: { $0.multiplied( saturation: 0.2, brightness: 2.1 ) },
        dark: { $0.multiplied( saturation: 0.45, brightness: 0.25 ) }
    )
    /// UI element background
    static let fillFaded = defaultTint.adjust(
        light: { $0.multiplied( saturation: 0.3, brightness: 1.9 ) },
        dark: { $0.multiplied( saturation: 0.5, brightness: 0.32 ) }
    )
    /// Hovered UI element background
    static let fill = defaultTint.adjust(
        light: { $0.multiplied( saturation: 0.4, brightness: 1.8 ) },
        dark: { $0.multiplied( saturation: 0.6, brightness: 0.45 ) }
    )
    /// Active / Selected UI element background
    static let fillEmphasized = defaultTint.adjust(
        light: { $0.multiplied( saturation: 0.5, brightness: 1.7 )},
        dark: { $0.multiplied( saturation: 0.7, brightness: 0.55 ) }
    )
    /// Subtle borders and separators
    static let borderFaded = defaultTint.adjust(
        light: { $0.multiplied( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiplied( saturation: 0.75, brightness: 0.7 ) }
    )
    /// UI element border and focus rings
    static let border = defaultTint.adjust(
        light: { $0.multiplied( saturation: 0.8, brightness: 1.4 ) },
        dark: { $0.multiplied( saturation: 0.85, brightness: 0.8 ) }
    )
    /// Hovered UI element border
    static let borderEmphasized = defaultTint.adjust(
        light: { $0.multiplied(saturation: 0.9, brightness: 1.1 ) },
        dark: { $0.multiplied(saturation: 0.9, brightness: 0.9 ) }
    )
    /// Solid backgrounds
    static let solid = defaultTint.adjust(
        light: { $0 },
        dark: { $0 }
    )
    /// Hovered solid backgrounds
    static let solidEmphasized = defaultTint.adjust(
        light: { $0.multiplied(saturation: 1.1, brightness: 0.9) },
        dark: { $0.multiplied(saturation: 0.95, brightness: 1.1) }
    )
    /// Low-contrast text
    static let textFaded = Self.solidEmphasized
    /// Normal text
    static let text = defaultTint.adjust(
        light: { $0.multiplied(saturation: 0.9, brightness: 0.76) },
        dark: { $0.multiplied(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
    )
    /// High-contrast text
    static let textEmphasized = defaultTint.adjust(
        light: { $0.multiplied(saturation: 0.95, brightness: 0.35) },
        dark: { $0.multiplied(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
    )
}


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
                            Text(String(format: "%.2f", sample.components(env).hue))
                            Text(String(format: "%.2f", sample.components(env).saturation))
                            Text(String(format: "%.2f", sample.components(env).brightness))
                            Text(String(format: "%.2f", sample.components(env).alpha))
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
//                .truss(.tint(.systemAccent))
            if #available(macOS 14.0, *) {
                ColorScale().environment(\.colorScheme, .light)
                    .truss(.tint(color: .orange))
            }
            ColorScale().environment(\.colorScheme, .dark)
            if #available(macOS 14.0, *) {
                ColorScale().environment(\.colorScheme, .dark)
                    .truss(.tint(color: .blue))
            }
        }
    }
}
