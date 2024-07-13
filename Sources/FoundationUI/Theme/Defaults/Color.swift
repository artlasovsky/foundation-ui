//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

// MARK: - DefaultImplementation
extension FoundationUI.DefaultTheme {
    public var color: Variable.Color { .primary }
}

extension Color {
    static let theme = FoundationUI.theme.color
}

// MARK: - Conform to FoundationColorToken
public extension FoundationUI.DefaultTheme.Variable {
    typealias Color = FoundationUI.DynamicColor
}

extension FoundationUI.DefaultTheme.Variable.Color: FoundationColorVariable {
    public func hue(_ value: CGFloat) -> Self {
        hue(value, method: .multiply)
    }
    public func saturation(_ value: CGFloat) -> Self {
        saturation(value, method: .multiply)
    }
    public func brightness(_ value: CGFloat) -> Self {
        brightness(value, method: .multiply)
    }
    public func opacity(_ value: CGFloat) -> Self {
        opacity(value, method: .multiply)
    }
}

extension FoundationUI.DefaultTheme.Variable.Color {
    public func token(_ token: Token) -> Self {
        token(self)
    }
    
    public func callAsFunction(_ color: Self) -> Self {
        color
    }
    
    public struct Token: DynamicColorToken {
        public var adjust: @Sendable (SourceValue) -> ResultValue
        
        public init(_ adjust: @escaping @Sendable (SourceValue) -> ResultValue) {
            self.adjust = adjust
        }
    }
}

// MARK: - Default Color Tokens
public extension FoundationUI.DefaultTheme.Variable.Color {
    #warning("TODO: Accessible Variants")
    static let primary = Self(
        light: .init(grayscale: 0.5),
        dark: .init(grayscale: 0.57)
    )
    
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
    
    internal static var dynamic: Self {
        primary
    }
}

extension FoundationUI.DefaultTheme.Variable.Color {
    static var red: Self {
        .init(
            light: .init(red8bit: 255, green: 59, blue: 48),
            dark: .init(red8bit: 255, green: 69, blue: 58)
        )
    }
}

// MARK: - Default Color Scale

public protocol DynamicColorToken: FoundationColorVariableToken where SourceValue == FoundationUI.DynamicColor, ResultValue == SourceValue {
    static var backgroundFaded: Self { get }
    static var background: Self { get }
    static var backgroundEmphasized: Self { get }
    
    static var fillFaded: Self { get }
    static var fill: Self { get }
    static var fillEmphasized: Self { get }
    
    static var borderFaded:Self { get }
    static var border: Self { get }
    static var borderEmphasized: Self { get }
    
    static var solid: Self { get }
    
    static var textFaded: Self { get }
    static var text: Self { get }
    static var textEmphasized: Self { get }
    
    static var clear: Self { get }
}

public extension DynamicColorToken {
    typealias Components = FoundationUI.DynamicColor.Components
    typealias ComponentAdjust = (Components) -> Components
    
    static func adjust(
        light: @escaping ComponentAdjust,
        dark: @escaping ComponentAdjust,
        lightAccessible: ComponentAdjust? = nil,
        darkAccessible: ComponentAdjust? = nil
    ) -> Self {
        .init {
            .init(
                light: light($0.light),
                dark: dark($0.dark),
                lightAccessible: (lightAccessible ?? light)($0.lightAccessible),
                darkAccessible: (darkAccessible ?? dark)($0.darkAccessible)
            )
        }
    }
    static var backgroundFaded: Self {
        .adjust(
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
        .adjust(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.975 : 0.95 }, method: .override)
                .saturation(0.06)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.18 : 0.12 }, method: .override)
            }
        )
    }
    static var backgroundEmphasized: Self {
        .adjust(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.96 : 0.92 }, method: .override)
                .saturation(0.1)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.32 : 0.18 }, method: .override)
            }
        )
    }
    static var fillFaded: Self {
        .adjust(
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
        .adjust(
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
    static var fillEmphasized: Self {
        .adjust(
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
    static var borderFaded: Self {
        .adjust(
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
        .adjust(
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
    static var borderEmphasized: Self {
        .adjust(
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
    
    static var textFaded: Self {
        .adjust(
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
        .adjust(
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
    
    static var textEmphasized: Self {
        .adjust(
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
    
    static var clear: Self {
        .init { $0.opacity(0) }
    }
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
        private let defaultScale: [FoundationUI.Theme.Color.Token] = [
            .backgroundFaded, .background, .backgroundEmphasized,
            .fillFaded, .fill, .fillEmphasized,
            .borderFaded, .border, .borderEmphasized,
            .solid,
            .textFaded, .text, .textEmphasized
        ]
        struct ScaleSwatch: View {
            @Environment(\.dynamicColorTint) private var tint
            let scale: FoundationUI.DynamicColor.Token
            
            var isSolid: Bool {
                let color = FoundationUI.DynamicColor.primary
                
                return color.token(.solid) == color.token(scale)
            }
            var body: some View {
                ZStack {
                    Rectangle()
                        .foundation(.foregroundTinted(scale))
                        .foundation(.size(isSolid ? .small.up(.quarter) : .small))
                    if isSolid {
                        VStack {
                            let tint = tint.token(scale)
                            let h = String(format: "%.2f", tint.light.hue)
                            let s = String(format: "%.2f", tint.light.saturation)
                            let b = String(format: "%.2f", tint.light.brightness)
                            let o = String(format: "%.2f", tint.light.opacity)
                            Text(h).fixedSize()
                            Text(s).fixedSize()
                            Text(b).fixedSize()
                            Text(o).fixedSize()
                        }
                        .foundation(.font(.init(.system(size: 7))))
                        .foundation(.foregroundTinted(.backgroundFaded))
                    }
                }
            }
        }
        var body: some View {
            VStack(spacing: 0) {
                TextSample()
                Divider().foundation(.size(width: .small)).foundation(.foregroundTinted(.borderFaded))
                ScaleSwatch(scale: .backgroundFaded)
                ScaleSwatch(scale: .background)
                ScaleSwatch(scale: .backgroundEmphasized)
                ScaleSwatch(scale: .fillFaded)
                ScaleSwatch(scale: .fill)
                ScaleSwatch(scale: .fillEmphasized)
                ScaleSwatch(scale: .borderFaded)
                ScaleSwatch(scale: .border)
                ScaleSwatch(scale: .borderEmphasized)
                ScaleSwatch(scale: .solid)
                ScaleSwatch(scale: .textFaded)
                ScaleSwatch(scale: .text)
                ScaleSwatch(scale: .textEmphasized)
                
            }
            .foundation(.padding(.regular))
            .foundation(.backgroundTinted(.backgroundFaded))
        }
    }
    
    struct TextSample: View {
        var body: some View {
            Text("Text")
                .foundation(.padding(.regular))
                .foundation(.foregroundTinted(.text))
                .foundation(.font(.small))
                .fixedSize()
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
