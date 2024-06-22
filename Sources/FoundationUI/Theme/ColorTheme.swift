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
        dark: .init(grayscale: 0.57)
//        ,
//        lightAccessible: .init(grayscale: 0.39),
//        darkAccessible: .init(grayscale: 0.64)
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

internal extension FoundationUI.ColorComponents {
    func dynamicLight(saturation: CGFloat, brightness: CGFloat) -> Self {
        guard isSaturated else { return multiply(brightness: brightness) }
        if brightness < 1 {
            return multiply(saturation: saturation, brightness: brightness)
        }
        let saturation = saturation * brightness * 0.85
        if self.saturation < 0.5 {
            return self.multiply(saturation: saturation * 1.2, brightness: brightness * 0.8)
        }
        if self.saturation < 0.6 {
            return self.multiply(saturation: saturation * 1.05, brightness: brightness * 0.685)
        }
        if self.saturation < 0.7 {
            if self.brightness < 0.85 {
                return multiply(saturation: saturation / 3, brightness: brightness * 0.61)
            }
            if self.brightness < 0.9 {
                return multiply(saturation: saturation * 0.9, brightness: brightness * 0.6)
            }
            return multiply(saturation: saturation, brightness: brightness * 0.55)
        }
        if self.saturation < 0.9 {
            return multiply(saturation: saturation * 0.92, brightness: brightness * 0.521)
        }
        if self.saturation > 0.9, self.brightness < 0.8 {
            return multiply(saturation: saturation * 0.9, brightness: brightness * 0.667)
        }
            
        return multiply(saturation: saturation, brightness: brightness * 0.53)
    }
}

/// Variations are extention of `DynamicColor`
public extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    static var environmentDefault: Self {
        primary
    }
    
    /// App background
    var backgroundFaded: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.03, brightness: 1.98) },
        dark: { $0.multiply(saturation: 0.3).override(brightness: $0.isSaturated ? 0.14 : 0.08) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Content background
    var background: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.045, brightness: 1.94) },
        dark: { $0.multiply(saturation: 0.35, brightness: 0.2) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Subtle background
    var backgroundEmphasized: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.1, brightness: 1.94) },
        dark: { $0.multiply(saturation: 0.45, brightness: 0.25 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// UI element background
    var fillFaded: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.14, brightness: 1.87) },
        dark: { $0.multiply(saturation: 0.5, brightness: 0.32 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Hovered UI element background
    var fill: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.2, brightness: 1.8) },
        dark: { $0.multiply(saturation: 0.6, brightness: 0.45 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Active / Selected UI element background
    var fillEmphasized: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.3, brightness: 1.73) },
        dark: { $0.multiply(saturation: 0.7, brightness: 0.55 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Subtle borders and separators
    var borderFaded: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.45, brightness: 1.6) },
        dark: { $0.multiply(saturation: 0.75, brightness: 0.7 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// UI element border and focus rings
    var border: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.55, brightness: 1.5) },
        dark: { $0.multiply(saturation: 0.85, brightness: 0.8 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Hovered UI element border
    var borderEmphasized: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.7, brightness: 1.38) },
        dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Solid backgrounds
    var solid: Self { self }
    /// Hovered solid backgrounds
    var solidEmphasized: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.98, brightness: 0.8) },
        dark: { $0.multiply(saturation: 0.95, brightness: 1.1) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// Low-contrast text
    var textFaded: Self { solidEmphasized }
    /// Normal text
    var text: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.95, brightness: 0.52) },
        dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) },
        lightAccessible: nil,
        darkAccessible: nil
    ) }
    /// High-contrast text
    var textEmphasized: Self { makeVariation(
        light: { $0.dynamicLight(saturation: 0.6, brightness: 0.24) },
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

// MARK: - Preview

struct DynamicColorPreview: PreviewProvider {
    struct ColorPatch: View {
        let color: FoundationUI.DynamicColor
        var body: some View {
            FoundationUI.Shape.roundedRectangle(.regular)
                .foundation(.foreground(color))
                .foundation(.size(.small))
        }
    }
    struct Scale: View {
        @Environment(\.dynamicColorTint) private var tint
        var body: some View {
            VStack(spacing: 0) {
                TextSample()
                Divider().foundation(.size(width: .small)).foundation(.foreground(\.borderFaded))
                ForEach(FoundationUI.DynamicColor.primary.defaultScale, id: \.hashValue) { variant in
                    ZStack {
                        Rectangle()
                            .foundation(.foreground(variant))
                            .foundation(.size(variant == \.solid ? .small.offset(.quarter.up) : .small))
                        if variant == \.solid {
                            VStack {
                                let tint = tint[keyPath: variant]
                                let h = String(format: "%.2f", tint.light.hue)
                                let s = String(format: "%.2f", tint.light.saturation)
                                let b = String(format: "%.2f", tint.light.brightness)
                                let o = String(format: "%.2f", tint.light.opacity)
                                Text(h).fixedSize()
                                Text(s).fixedSize()
                                Text(b).fixedSize()
                                Text(o).fixedSize()
                            }
                            .foundation(.font(.init(value: .system(size: 7), label: nil)))
                            .foundation(.foreground(\.background))
                        }
                    }
                }
            }
            .foundation(.padding(.regular))
            .foundation(.background(\.backgroundFaded))
        }
    }
    
    struct TextSample: View {
        var body: some View {
            Text("Text")
                .foundation(.padding(.regular))
                .foundation(.foreground(\.textFaded))
                .foundation(.font(.small))
        }
    }
    
    struct ScaleSet: View {
        var body: some View {
            HStack(spacing: 0) {
                Scale()._colorScheme(.light)
//                Scale()._colorScheme(.lightAccessible)
//                Scale()._colorScheme(.dark)
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
        .foundation(.clip(cornerRadius: .regular))
        .scenePadding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}


@available(macOS 14.0, *)
struct Button_Preview: PreviewProvider {
    struct TestButton: View {
        @State private var isHovered: Bool = false
        var body: some View {
            Text("Button")
                .foundation(.padding())
                .foundation(.foreground(\.text))
                .foundation(.background(isHovered ? \.background : \.backgroundEmphasized))
                .foundation(.border(\.borderFaded))
                .foundation(.cornerRadius(.regular))
                .animation(.foundation.animation(.regular), value: isHovered)
                .onHover { isHovered = $0 }
                .foundation(.tint(.from(color: .orange)))
        }
    }
    static var previews: some View {
        VStack {
            TestButton()
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
