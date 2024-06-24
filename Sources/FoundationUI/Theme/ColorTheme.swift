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
}

extension FoundationUI.DynamicColor: DynamicColorDefaults {}

/// Tint are static extensions of `DynamicColor`
public extension DynamicColorDefaults where Self == FoundationUI.DynamicColor {
    #warning("TODO: Accessible Variants")
    static var primary: Self {
        .init(
            light: .init(grayscale: 0.5),
            dark: .init(grayscale: 0.57)
        )
    }
    
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
    var backgroundFaded: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.98 : 0.97 }, method: .override)
                .saturation(0.02),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.1 : 0.05 }, method: .override)
        )
    }
    /// Content background
    var background: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.975 : 0.95 }, method: .override)
                .saturation(0.06),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.18 : 0.12 }, method: .override)
        )
    }
    /// Subtle background
    var backgroundEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.96 : 0.92 }, method: .override)
                .saturation(0.1)
            ,
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.32 : 0.18 }, method: .override)
        )
    }
    /// UI element background
    var fillFaded: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.9 }, method: .override)
                .saturation(0.18),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.44 : 0.22 }, method: .override)
        )
    }
    /// Hovered UI element background
    var fill: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.94 : 0.87 }, method: .override)
                .saturation(0.35),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.61 : 0.27 }, method: .override)
        )
    }
    /// Active / Selected UI element background
    var fillEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.92 : 0.83 }, method: .override)
                .saturation(0.5),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.68 : 0.32 }, method: .override)
        )
    }
    /// Subtle borders and separators
    var borderFaded: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.82 : 0.77 }, method: .override)
                .saturation(0.58),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.72 : 0.37 }, method: .override)
                .saturation(0.97)
        )
    }
    /// UI element border and focus rings
    var border: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.78 : 0.7 }, method: .override)
                .saturation(0.8),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.8 : 0.42 }, method: .override)
                .saturation(0.95)
        )
    }
    /// Hovered UI element border
    var borderEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.65 : 0.6 }, method: .override)
                .saturation(0.8),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.85 : 0.48 }, method: .override)
                .saturation(0.9)
        )
    }
    /// Solid backgrounds
    var solid: Self { self }
    /// Low-contrast text
    var textFaded: Self { 
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.6 : 0.35 }, method: .override)
                .saturation(1),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.85 }, method: .override)
                .saturation(0.25)
        )
    }
    /// Normal text
    var text: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.45 : 0.24 }, method: .override)
                .saturation(0.95),
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.92 }, method: .override)
                .saturation(0.15)
        )
    }
    /// High-contrast text
    var textEmphasized: Self {
        .init(
            light: self.light
                .brightness(dynamic: { $0.isSaturated ? 0.35 : 0.12 }, method: .override)
                .saturation(0.8)
            ,
            dark: self.dark
                .brightness(dynamic: { $0.isSaturated ? 0.95 : 0.98 }, method: .override)
                .saturation(0.05)
        )
    }
    
    var clear: Self {
        self.opacity(0)
    }
}

// MARK: - Preview

internal extension DynamicColorDefaults {
    var defaultScale: [Self.VariationKeyPath] { [
         \.backgroundFaded, \.background, \.backgroundEmphasized,
         \.fillFaded, \.fill, \.fillEmphasized,
         \.borderFaded, \.border, \.borderEmphasized,
         \.solid,
         \.textFaded, \.text, \.textEmphasized
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
                            .foundation(.size([\.solid, \.border, \.fill, \.background, \.text].contains(variant) ? .small.offset(.quarter.up) : .small))
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
                            .foundation(.foreground(\.backgroundFaded))
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
                .foundation(.foreground(\.text))
                .foundation(.font(.small))
        }
    }
    
    struct ScaleSet: View {
        var body: some View {
            HStack(spacing: 0) {
//                Scale()._colorScheme(.light)
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
