//
//  ColorTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Extension

public extension Color {
    typealias Variable = TrussUI.ColorVariable
    typealias Scale = TrussUI.ColorVariable.Scale
    typealias Tint = TrussUI.Tint
}

public extension ShapeStyle {
    typealias Variable = TrussUI.ColorVariable
    typealias Scale = TrussUI.ColorVariable.Scale
    typealias Tint = TrussUI.Tint
    typealias Gradient = TrussUI.Gradient
}

// MARK: - Tint

public extension TrussUI.Tint {
    static let white = Self(light: ColorComponents(hue: 0, saturation: 0, brightness: 1))
    static let black = Self(light: ColorComponents(hue: 0, saturation: 0, brightness: 0))
    
    static let clear = Self(light: ColorComponents(hue: 0, saturation: 0, brightness: 0, alpha: 0))
    
    static let primary = Self(
        light: ColorComponents(hue: 0, saturation: 0, brightness: 0.43),
        dark: ColorComponents(hue: 0, saturation: 0, brightness: 0.55))
}

public extension TrussUI.Tint {
    static let systemAccent: Self = {
        if #available(macOS 14.0, *) {
            return Self(lightColor: .accentColor)
        }
        return Self(light: .init(red: 0, green: 0, blue: 1))
    }()
}

// MARK: - Color Variable

public extension TrussUI.ColorVariable {
    /// Transparent
    static let clear = Self(
        light: { $0.set(hue: nil, alpha: 0) },
        dark: { $0.set(hue: nil, alpha: 0) }
    )
    enum Scale {}
}

// MARK: - Color Variable Scale

public extension TrussUI.ColorVariable.Scale {
    typealias ColorVariable = TrussUI.ColorVariable
    /// App background
    static let backgroundFaded = ColorVariable(
        light: { $0.multiplied(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
        dark: { $0.multiplied(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
    )
    /// Content background
    static let background = ColorVariable(
        light: { $0.multiplied(saturation: 0.06, brightness: 2.18 ) },
        dark: { $0.multiplied(saturation: 0.35, brightness: 0.2)}
    )
    /// Subtle background
    static let backgroundEmphasized = ColorVariable(
        light: { $0.multiplied( saturation: 0.2, brightness: 2.1 ) },
        dark: { $0.multiplied( saturation: 0.45, brightness: 0.25 ) }
    )
    /// UI element background
    static let fillFaded = ColorVariable(
        light: { $0.multiplied( saturation: 0.3, brightness: 1.9 ) },
        dark: { $0.multiplied( saturation: 0.5, brightness: 0.32 ) }
    )
    /// Hovered UI element background
    static let fill = ColorVariable(
        light: { $0.multiplied( saturation: 0.4, brightness: 1.8 ) },
        dark: { $0.multiplied( saturation: 0.6, brightness: 0.45 ) }
    )
    /// Active / Selected UI element background
    static let fillEmphasized = ColorVariable(
        light: { $0.multiplied( saturation: 0.5, brightness: 1.7 )},
        dark: { $0.multiplied( saturation: 0.7, brightness: 0.55 ) }
    )
    /// Subtle borders and separators
    static let borderFaded = ColorVariable(
        light: { $0.multiplied( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiplied( saturation: 0.75, brightness: 0.7 ) }
    )
    /// UI element border and focus rings
    static let border = ColorVariable(
        light: { $0.multiplied( saturation: 0.8, brightness: 1.4 ) },
        dark: { $0.multiplied( saturation: 0.85, brightness: 0.8 ) }
    )
    /// Hovered UI element border
    static let borderEmphasized = ColorVariable(
        light: { $0.multiplied(saturation: 0.9, brightness: 1.1 ) },
        dark: { $0.multiplied(saturation: 0.9, brightness: 0.9 ) }
    )
    /// Solid backgrounds
    static let solid = ColorVariable(
        light: { $0 },
        dark: { $0 }
    )
    /// Hovered solid backgrounds
    static let solidEmphasized = ColorVariable(
        light: { $0.multiplied(saturation: 1.1, brightness: 0.9) },
        dark: { $0.multiplied(saturation: 0.95, brightness: 1.1) }
    )
    /// Low-contrast text
    static let textFaded = Self.solidEmphasized
    /// Normal text
    static let text = ColorVariable(
        light: { $0.multiplied(saturation: 0.9, brightness: 0.76) },
        dark: { $0.multiplied(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
    )
    /// High-contrast text
    static let textEmphasized = ColorVariable(
        light: { $0.multiplied(saturation: 0.95, brightness: 0.35) },
        dark: { $0.multiplied(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
    )
}

internal extension TrussUI.ColorVariable.Scale {
    static let all: [ColorVariable] = [
        Self.backgroundFaded, Self.background, Self.backgroundEmphasized,
        Self.fillFaded, Self.fill, Self.fillEmphasized,
        Self.borderFaded, Self.border, Self.borderEmphasized,
        Self.solid, Self.solidEmphasized, /*.textFaded,*/
        Self.text, Self.textEmphasized
    ]
}

#Preview {
    struct ColorScale: View {
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.self) private var env
        var body: some View {
            VStack(spacing: 0) {
                Text(colorScheme == .dark ? "Dark" : "Light")
                    .theme().foreground(.Scale.text)
                    .theme().padding(.regular, .bottom)
                    .font(.caption.monospaced())
                ForEach(TrussUI.ColorVariable.Scale.all, id: \.self) { sample in
                    HStack(spacing: 0) {
                        VStack {
                            Text(String(format: "%.2f", sample.resolveComponents(in: env).hue))
                            Text(String(format: "%.2f", sample.resolveComponents(in: env).saturation))
                            Text(String(format: "%.2f", sample.resolveComponents(in: env).brightness))
                            Text(String(format: "%.2f", sample.resolveComponents(in: env).alpha))
                        }
                        .font(.system(size: 7).monospaced())
                        .padding(.trailing, 2)
                        Rectangle().frame(width: 40, height: 40)
                            .foregroundStyle(sample)
                    }
                }
            }
            .theme().padding(.large)
            .theme().background(.Scale.backgroundFaded)
        }
    }
    
    return HStack(spacing: 0) {
        ColorScale().environment(\.colorScheme, .light)
        ColorScale()
            .environment(\.colorScheme, .light)
            .theme().tint(.systemAccent)
        if #available(macOS 14.0, *) {
            ColorScale().environment(\.colorScheme, .light)
                .theme().tintColor(.orange)
        }
        ColorScale().environment(\.colorScheme, .dark)
        if #available(macOS 14.0, *) {
            ColorScale().environment(\.colorScheme, .dark)
                .theme().tintColor(.blue)
        }
    }
}
