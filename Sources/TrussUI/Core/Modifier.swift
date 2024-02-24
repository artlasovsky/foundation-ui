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
    static func shadow(color colorVariable: TrussUI.ColorVariable = .Scale.backgroundFaded,
                       tint: TrussUI.Tint = .primary,
                       radius: CGFloat,
                       x: CGFloat = 0,
                       y: CGFloat = 0
    ) -> Self {
        TrussUI.Modifier.ShadowModifier(
            configuration: ShadowConfiguration(
                radius: radius,
                colorVariable: colorVariable,
                tint: tint,
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
                        color: configuration.colorVariable
                            .tint(configuration.tint)
                            .resolve(in: environment),
                        radius: configuration.radius,
                        x: configuration.x,
                        y: configuration.y)
            }
        }
    }
}

public struct ShadowConfiguration: Hashable, Equatable {
    var radius: CGFloat
    var colorVariable: TrussUI.ColorVariable = .Scale.backgroundFaded
    var tint: TrussUI.Tint = .primary
    var x: CGFloat = 0
    var y: CGFloat = 0
}

// MARK: - Color
public extension TrussUIModifier where Self == TrussUI.Modifier.ColorModifier {
    static func tint(_ variable: TrussUI.Tint?) -> Self {
        TrussUI.Modifier.ColorModifier(type: .tint(variable))
    }
    @available(macOS 14.0, *)
    static func tint(color: Color?) -> Self {
        let tint: TrussUI.Tint?
        if let color {
            tint = .init(color: color)
        } else {
            tint = nil
        }
        return TrussUI.Modifier.ColorModifier(type: .tint(tint))
    }
    
    static func foreground(_ variable: TrussUI.ColorVariable) -> Self {
        TrussUI.Modifier.ColorModifier(type: .foreground(variable))
    }
    static func foreground(color: Color) -> Self {
        TrussUI.Modifier.ColorModifier(type: .foregroundColor(color))
    }
    static func background(
        _ variable: TrussUI.ColorVariable = .Scale.background,
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
            case tint(_ variable: TrussUI.Tint?)
            case foreground(_ variable: TrussUI.ColorVariable)
            case foregroundColor(_ color: Color)
            case background(_ variable: TrussUI.ColorVariable, cornerRadius: TrussUI.Variable.Radius?, shadow: TrussUI.Variable.Shadow?, gradientMask: TrussUI.Gradient?)
        }
        public func body(content: Content) -> some View {
            switch type {
            case .tint(let variable):
                content.environment(\.TrussUITint, variable)
            case .foreground(let variable):
                content.foregroundStyle(variable)
            case .foregroundColor(let color):
                content.foregroundStyle(color)
            case .background(let variable, let cornerRadius, let shadow, let gradientMask):
                content.modifier(BackgroundModifier(colorVariable: variable, cornerRadius: cornerRadius, shadow: shadow, gradientMask: gradientMask))
            }
        }
    }
}

extension TrussUI.Modifier.ColorModifier {
    struct BackgroundModifier: ViewModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        
        let colorVariable: TrussUI.ColorVariable
        let cornerRadius: TrussUI.Variable.Radius?
        let shadow: TrussUI.Variable.Shadow?
        let gradientMask: TrussUI.Gradient?
        
        public func body(content: Content) -> some View {
            content.background {
                TrussUI.Component.roundedRectangle(radius)
                    .fill(colorVariable)
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
        _ variable: TrussUI.ColorVariable = .Scale.border,
        width: CGFloat = 1,
        placement: BorderPlacement = .inside,
        cornerRadius: TrussUI.Variable.Radius? = nil,
        gradientMask: TrussUI.Gradient? = nil
    ) -> Self {
        TrussUI.Modifier.BorderModifier(colorVariable: variable, width: width, placement: placement, cornerRadius: cornerRadius, gradientMask: gradientMask)
    }
}

public extension TrussUI.Modifier {
    struct BorderModifier: TrussUIModifier {
        @Environment(\.self) private var environment
        
        let colorVariable: TrussUI.ColorVariable
        let width: CGFloat
        let placement: BorderPlacement
        let cornerRadius: TrussUI.Variable.Radius?
        let gradientMask: TrussUI.Gradient?
        
        public func body(content: Content) -> some View {
            content.overlay {
                TrussUI.Component.roundedRectangle(radius)
                    .stroke(lineWidth: width)
                    .foregroundStyle(colorVariable)
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
    static func clip(_ cornerRadius: TrussUI.Variable.Radius) -> Self {
        TrussUI.Modifier.ClipModifier(cornerRadius: cornerRadius)
    }
}

public extension TrussUI.Modifier {
    struct ClipModifier: TrussUIModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        let cornerRadius: TrussUI.Variable.Radius
        
        public func body(content: Content) -> some View {
            content.clipShape(TrussUI.Component.roundedRectangle(envCornerRadius ?? cornerRadius.value))
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


#Preview(body: {
    VStack {
        Text("Hello!")
            .truss(.font(.large))
            .truss(.size(width: .regular, height: .small))
            .truss(.border(.Scale.border))
    }
    .truss(.size(.large))
    .truss(.padding(.regular))
})
