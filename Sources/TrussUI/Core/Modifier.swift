//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension TrussUI {
    public enum Modifier {}
}

public protocol TrussUIModifier: ViewModifier {}

// MARK: - View extension
public extension View {
    func truss(_ modifier: some TrussUIModifier) -> some View {
        self.modifier(modifier)
    }
}

// MARK: - Font
public extension TrussUIModifier where Self == TrussUI.Modifier.FontModifier {
    static func font(_ variable: TrussUI.Variable.Font) -> Self {
        TrussUI.Modifier.FontModifier(font: variable.value)
    }
}

public extension TrussUI.Modifier {
    struct FontModifier: TrussUIModifier {
        public let font: Font
        public func body(content: Content) -> some View {
            content.font(font)
        }
    }
}

// MARK: - Shadow
public extension TrussUIModifier where Self == TrussUI.Modifier.ShadowModifier {
    static func shadow(configuration: ShadowConfiguration) -> Self {
        TrussUI.Modifier.ShadowModifier(configuration: configuration)
    }
    static func shadow(color colorVariable: TrussUI.TintedColorSet = .backgroundFaded.tint(.primary),
                       radius: CGFloat,
                       x: CGFloat = 0,
                       y: CGFloat = 0
    ) -> Self {
        TrussUI.Modifier.ShadowModifier(
            configuration: ShadowConfiguration(
                radius: radius,
                colorVariable: colorVariable,
                x: x,
                y: y)
        )
    }
    static func shadow(_ variable: TrussUI.Variable.Shadow?) -> Self {
        TrussUI.Modifier.ShadowModifier(configuration: variable?.value)
    }
}

public extension TrussUI.Modifier {
    struct ShadowModifier: TrussUIModifier {
        @Environment(\.self) private var environment
        public let configuration: ShadowConfiguration?
        public func body(content: Content) -> some View {
            if let configuration {
                content
                    .shadow(
                        color: configuration.colorVariable.color(in: environment),
                        radius: configuration.radius,
                        x: configuration.x,
                        y: configuration.y)
            } else {
                content
            }
        }
    }
}

public struct ShadowConfiguration: Hashable, Equatable {
    var radius: CGFloat
    var colorVariable: TrussUI.TintedColorSet
    var x: CGFloat = 0
    var y: CGFloat = 0
}

// MARK: - Color
public extension TrussUIModifier where Self == TrussUI.Modifier.ColorModifier {
    static func tint(_ colorSet: TrussUI.ColorSet?) -> Self {
        TrussUI.Modifier.ColorModifier(type: .tint(colorSet))
    }
    @available(macOS 14.0, *)
    static func tintColor(_ color: Color?) -> Self {
        let tint: TrussUI.ColorSet?
        if let color {
            tint = .init(color: color)
        } else {
            tint = nil
        }
        return TrussUI.Modifier.ColorModifier(type: .tint(tint))
    }
    
    static func foreground(_ variable: TrussUI.TintedColorSet) -> Self {
        TrussUI.Modifier.ColorModifier(type: .foreground(variable))
    }
    static func foregroundColor(_ color: Color) -> Self {
        TrussUI.Modifier.ColorModifier(type: .foregroundColor(color))
    }
    static func background(
        _ variable: TrussUI.TintedColorSet = .background,
        cornerRadius: TrussUI.Variable.Radius? = nil,
        shadow: TrussUI.Variable.Shadow? = nil,
        gradientMask: TrussUI.Gradient? = nil
    ) -> Self {
        TrussUI.Modifier.ColorModifier(type: .background(variable, cornerRadius: cornerRadius, shadow: shadow, gradientMask: gradientMask))
    }
}


public extension TrussUI.Modifier {
    struct ColorModifier: TrussUIModifier {
        let type: ModifierType
        enum ModifierType {
            case tint(_ colorSet: TrussUI.ColorSet?)
            case foreground(_ tintedColorSet: TrussUI.TintedColorSet)
            case foregroundColor(_ color: Color)
            case background(_ tintedColorSet: TrussUI.TintedColorSet, cornerRadius: TrussUI.Variable.Radius?, shadow: TrussUI.Variable.Shadow?, gradientMask: TrussUI.Gradient?)
        }
        public func body(content: Content) -> some View {
            switch type {
            case .tint(let variable):
                content.environment(\.trussUITint, variable)
            case .foreground(let variable):
                content.foregroundStyle(variable)
            case .foregroundColor(let color):
                content.foregroundStyle(color)
            case .background(let tintedColorSet, let cornerRadius, let shadow, let gradientMask):
                content.modifier(BackgroundModifier(tintedColorSet: tintedColorSet, cornerRadius: cornerRadius, shadow: shadow, gradientMask: gradientMask))
            }
        }
    }
}

extension TrussUI.Modifier.ColorModifier {
    struct BackgroundModifier: ViewModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        
        let tintedColorSet: TrussUI.TintedColorSet
        let cornerRadius: TrussUI.Variable.Radius?
        let shadow: TrussUI.Variable.Shadow?
        let gradientMask: TrussUI.Gradient?
        
        public func body(content: Content) -> some View {
            content.background {
                TrussUI.Component.roundedRectangle(radius)
                    .fill(tintedColorSet)
                    .truss(.gradientMask(gradientMask))
                    .truss(.shadow(shadow))
            }
        }
        
        private var radius: CGFloat {
            envCornerRadius ?? cornerRadius?.value ?? 0
        }
    }
}

// MARK: - Mask
public extension TrussUIModifier where Self == TrussUI.Modifier.MaskModifier {
    static func gradientMask(_ gradient: TrussUI.Gradient?) -> Self {
        TrussUI.Modifier.MaskModifier(gradient: gradient)
    }
}

public extension TrussUI.Modifier {
    struct MaskModifier: TrussUIModifier {
        let gradient: TrussUI.Gradient?
        public func body(content: Content) -> some View {
            if let gradient {
                content.mask {
                    Color.clear.overlay(gradient)
                }
            } else {
                content
            }
        }
    }
}

// MARK: - Padding
public extension TrussUIModifier where Self == TrussUI.Modifier.PaddingModifier {
    static func padding(_ variable: TrussUI.Variable.Padding = .regular, _ edges: Edge.Set = .all) -> Self {
        TrussUI.Modifier.PaddingModifier(variable: variable, edges: edges)
    }
}
public extension TrussUI.Modifier {
    struct PaddingModifier: TrussUIModifier {
        let variable: TrussUI.Variable.Padding
        let edges: Edge.Set
        public func body(content: Content) -> some View {
            content.padding(edges, variable.value)
        }
    }
}

// MARK: - Border
public extension TrussUIModifier where Self == TrussUI.Modifier.BorderModifier {
    static func border(
        _ tintedColorSet: TrussUI.TintedColorSet = .border,
        width: CGFloat = 1,
        placement: BorderPlacement = .inside,
        cornerRadius: TrussUI.Variable.Radius? = nil,
        gradientMask: TrussUI.Gradient? = nil
    ) -> Self {
        TrussUI.Modifier.BorderModifier(tintedColorSet: tintedColorSet, width: width, placement: placement, cornerRadius: cornerRadius, gradientMask: gradientMask)
    }
}

public extension TrussUI.Modifier {
    struct BorderModifier: TrussUIModifier {
        @Environment(\.self) private var environment
        
        let tintedColorSet: TrussUI.TintedColorSet
        let width: CGFloat
        let placement: BorderPlacement
        let cornerRadius: TrussUI.Variable.Radius?
        let gradientMask: TrussUI.Gradient?
        
        public func body(content: Content) -> some View {
            content.overlay {
                TrussUI.Component.roundedRectangle(radius)
                    .stroke(lineWidth: width)
                    .foregroundStyle(tintedColorSet)
                    .padding(placementPadding)
                    .truss(.gradientMask(gradientMask))
            }
        }
        
        private var radius: CGFloat {
            if let cornerRadius = environment.TrussUICornerRadius ?? cornerRadius?.value {
                return cornerRadius - placementPadding
            }
            return 0
        }
        
        private var placementPadding: CGFloat {
            switch placement {
            case .inside: width / 2
            case .outside: -width / 2
            case .center: 0
            }
        }
    }
}

public enum BorderPlacement {
    case inside
    case outside
    case center
}

// MARK: - Clip
public extension TrussUIModifier where Self == TrussUI.Modifier.ClipModifier {
    static func clip(cornerRadius: TrussUI.Variable.Radius? = nil) -> Self {
        TrussUI.Modifier.ClipModifier(cornerRadius: cornerRadius)
    }
}

public extension TrussUI.Modifier {
    struct ClipModifier: TrussUIModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        let cornerRadius: TrussUI.Variable.Radius?
        
        public func body(content: Content) -> some View {
            if let cornerRadius = envCornerRadius ?? cornerRadius?.value {
                content.clipShape(TrussUI.Component.roundedRectangle(cornerRadius))
            } else {
                content
            }
        }
    }
}

// MARK: - Corner Radius
public extension TrussUIModifier where Self == TrussUI.Modifier.CornerRadius {
    static func cornerRadius(_ variable: TrussUI.Variable.Radius?) -> Self {
        TrussUI.Modifier.CornerRadius(variable: variable)
    }
}
public extension TrussUI.Modifier {
    struct CornerRadius: TrussUIModifier {
        let variable: TrussUI.Variable.Radius?
        
        public func body(content: Content) -> some View {
            content.environment(\.TrussUICornerRadius, variable?.value)
        }
    }
}

// MARK: - Size
public extension TrussUIModifier where Self == TrussUI.Modifier.SizeModifier {
    static func size(width: TrussUI.Variable.Size? = nil, height: TrussUI.Variable.Size? = nil, alignment: Alignment = .center) -> Self {
        TrussUI.Modifier.SizeModifier(width: width, height: height, alignment: alignment)
    }
    static func size(_ side: TrussUI.Variable.Size, alignment: Alignment = .center) -> Self {
        TrussUI.Modifier.SizeModifier(width: side, height: side, alignment: alignment)
    }
}

public extension TrussUI.Modifier {
    struct SizeModifier: TrussUIModifier {
        let width: TrussUI.Variable.Size?
        let height: TrussUI.Variable.Size?
        let alignment: Alignment
        
        public func body(content: Content) -> some View {
            let width = width?.value
            let height = height?.value
            if width == .infinity || height == .infinity {
                content.frame(maxWidth: width, maxHeight: height, alignment: alignment)
            } else {
                content.frame(width: width, height: height, alignment: alignment)
            }
        }
    }
}


// MARK: - EnvironmentValues
private struct TrussUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

internal extension EnvironmentValues {
    var TrussUICornerRadius: CGFloat? {
        get { self[TrussUICornerRadiusKey.self] }
        set { self[TrussUICornerRadiusKey.self] = newValue }
    }
}

// MARK: - Preview

struct ModifierPreview: PreviewProvider {
    struct Preview: View {
        @State private var isHovered: Bool = false
        var body: some View {
            VStack {
                Text("Hello!")
                    .truss(.font(.large))
                    .truss(.size(width: .regular, height: .small))
                    .truss(.background(.fill.opacity(isHovered ? 1 : 0.2), cornerRadius: .regular))
                    .truss(.border(.border, cornerRadius: .regular))
            }
            .truss(.size(.large))
            .truss(.padding(.regular))
            .onHover { isHovered = $0 }
        }
    }
    static var previews: some View {
        Preview()
    }
}
