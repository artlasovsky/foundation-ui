//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Extension
public extension Color {
    typealias scale = FoundationUI.ColorScale
    typealias tint = FoundationUI.Tint
}

public extension ShapeStyle {
    typealias scale = FoundationUI.ColorScale
    typealias tint = FoundationUI.Tint
    typealias gradient = FoundationUI.Gradient
}

// MARK: - Theme
// TODO: Extract it to the "Theme"
public extension FoundationUI.Tint {
    static var primary: FoundationUI.Tint {
        FoundationUI.Tint(
            light: Color(hue: 0, saturation: 0, brightness: 0.43),
            dark: Color(hue: 0, saturation: 0, brightness: 0.55))
    }
    static var gray: FoundationUI.Tint {
        FoundationUI.Tint(
            light: Color(hue: 0, saturation: 0, brightness: 0.43),
            dark: Color(hue: 0, saturation: 0, brightness: 0.55))
    }
    static var darkGray: FoundationUI.Tint {
        FoundationUI.Tint(
            light: Color(hue: 0, saturation: 0, brightness: 0.43),
            dark: Color(hue: 0, saturation: 0, brightness: 0.55))
    }
    static var lightGray: FoundationUI.Tint {
        FoundationUI.Tint(
            light: Color(hue: 0, saturation: 0, brightness: 0.43),
            dark: Color(hue: 0, saturation: 0, brightness: 0.55))
    }
    static let accent = Self(.blue)
}
public extension FoundationUI.ColorScale {
    /// Transparent
    static let clear = FoundationUI.ColorScale(
        light: { $0.set(alpha: 0) },
        dark: { $0.set(alpha: 0) }
    )
    /// App background
    static let backgroundFaded = FoundationUI.ColorScale(
        light: { $0.multiply(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
        dark: { $0.multiply(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
    )
    /// Content background
    static let background = FoundationUI.ColorScale(
        light: { $0.multiply(saturation: 0.06, brightness: 2.18 ) },
        dark: { $0.multiply(saturation: 0.35, brightness: 0.2)}
    )
    /// Subtle background
    static let backgroundEmphasized = FoundationUI.ColorScale(
        light: { $0.multiply( saturation: 0.2, brightness: 2.1 ) },
        dark: { $0.multiply( saturation: 0.45, brightness: 0.25 ) }
    )
    /// UI element background
    static let fillFaded = FoundationUI.ColorScale(
        light: { $0.multiply( saturation: 0.3, brightness: 1.9 ) },
        dark: { $0.multiply( saturation: 0.5, brightness: 0.32 ) }
    )
    /// Hovered UI element background
    static let fill = FoundationUI.ColorScale(
        light: { $0.multiply( saturation: 0.4, brightness: 1.8 ) },
        dark: { $0.multiply( saturation: 0.6, brightness: 0.45 ) }
    )
    /// Active / Selected UI element background
    static let fillEmphasized = FoundationUI.ColorScale(
        light: { $0.multiply( saturation: 0.5, brightness: 1.7 )},
        dark: { $0.multiply( saturation: 0.7, brightness: 0.55 ) }
    )
    /// Subtle borders and separators
    static let borderFaded = FoundationUI.ColorScale(
        light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
        dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
    )
    /// UI element border and focus rings
    static let border = FoundationUI.ColorScale(
        light: { $0.multiply( saturation: 0.8, brightness: 1.4 ) },
        dark: { $0.multiply( saturation: 0.85, brightness: 0.8 ) }
    )
    /// Hovered UI element border
    static let borderEmphasized = FoundationUI.ColorScale(
        light: { $0.multiply(saturation: 0.9, brightness: 1.1 ) },
        dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) }
    )
    /// Solid backgrounds
    static let solid = FoundationUI.ColorScale(
        light: { $0 },
        dark: { $0 }
    )
    /// Hovered solid backgrounds
    static let solidEmphasized = FoundationUI.ColorScale(
        light: { $0.multiply(saturation: 1.1, brightness: 0.9) },
        dark: { $0.multiply(saturation: 0.95, brightness: 1.1) }
    )
    /// Low-contrast text
    static let textFaded = FoundationUI.ColorScale.solidEmphasized
    /// Normal text
    static let text = FoundationUI.ColorScale(
        light: { $0.multiply(saturation: 0.9, brightness: 0.76) },
        dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
    )
    /// High-contrast text
    static let textEmphasized = FoundationUI.ColorScale(
        light: { $0.multiply(saturation: 0.95, brightness: 0.35) },
        dark: { $0.multiply(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
    )
    
    static internal let all: [FoundationUI.ColorScale] = [
        .backgroundFaded, .background, .backgroundEmphasized,
        .fillFaded, .fill, .fillEmphasized,
        .borderFaded, .border, .borderEmphasized,
        .solid, .solidEmphasized, /*.textFaded,*/
        .text, .textEmphasized
    ]
}

#Preview {
    struct ColorScale: View {
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.self) private var env
        var body: some View {
            VStack(spacing: 0) {
                Text(colorScheme == .dark ? "Dark" : "Light")
                    .theme().foreground(.text)
                    .theme().padding(\.regular, .bottom)
                    .font(.caption.monospaced())
                ForEach(Array(FoundationUI.ColorScale.all.enumerated()), id: \.offset) { _, sample in
                    HStack(spacing: 0) {
                        VStack {
                            Text(String(format: "%.2f", sample.resolveComponents(in: env)?.hue ?? 0))
                            Text(String(format: "%.2f", sample.resolveComponents(in: env)?.saturation ?? 0))
                            Text(String(format: "%.2f", sample.resolveComponents(in: env)?.brightness ?? 0))
                            Text(String(format: "%.2f", sample.resolveComponents(in: env)?.alpha ?? 0))
                        }
                        .font(.system(size: 7).monospaced())
                        .padding(.trailing, 2)
                        Rectangle().frame(width: 40, height: 40)
                            .foregroundStyle(sample)
                    }
                }
            }
            .theme().padding(\.large)
            .theme().background(.backgroundFaded)
        }
    }
    
    return HStack(spacing: 0) {
        ColorScale().environment(\.colorScheme, .light)
        ColorScale().environment(\.colorScheme, .light)
            .theme().tint(color: .blue)
        ColorScale().environment(\.colorScheme, .light)
            .theme().tint(color: .orange)
        ColorScale().environment(\.colorScheme, .dark)
        ColorScale().environment(\.colorScheme, .dark)
            .theme().tint(color: .blue)
    }
}
