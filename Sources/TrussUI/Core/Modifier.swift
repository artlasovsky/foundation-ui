//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension TrussUI {
    public struct Modifier<ModifierContent: View> {
        public typealias Tint = TrussUI.Tint
        public typealias ColorVariable = TrussUI.ColorVariable
        public var content: ModifierContent
        internal init(_ content: ModifierContent) {
            self.content = content
        }
    }
}

// MARK: - View extension
public extension View {
    func theme() -> TrussUI.Modifier<some View> { TrussUI.Modifier(self) }
}

// MARK: - Font
public extension TrussUI.Modifier {
    @ViewBuilder
    func font(_ font: Font) -> some View {
        content.font(font)
    }
    @ViewBuilder
    func font(_ variable: TrussUI.Variable.Font) -> some View {
        self.font(.theme(variable))
    }
}

// MARK: - Shadow
public struct ShadowConfiguration: Hashable, Equatable {
    var radius: CGFloat
    var colorVariable: TrussUI.ColorVariable = .Scale.backgroundFaded
    var tint: TrussUI.Tint = .primary
    var x: CGFloat = 0
    var y: CGFloat = 0
}

private struct Shadow: ViewModifier {
    @Environment(\.self) private var environment
    let configuration: ShadowConfiguration
    func body(content: Content) -> some View {
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

public extension TrussUI.Modifier {
    @ViewBuilder
    func shadow(_ configuration: ShadowConfiguration) -> some View {
        content.modifier(Shadow(configuration: configuration))
    }
    
    @ViewBuilder
    func shadow(_ variable: ColorVariable = .Scale.backgroundFaded, tint: Tint = .primary, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        content.modifier(Shadow(configuration: .init(radius: radius, colorVariable: variable, tint: tint, x: x, y: y)))
    }
    
    @ViewBuilder
    func shadow(_ variable: TrussUI.Variable.Shadow? = nil) -> some View {
        if let variable {
            let configuration = variable.value
            shadow(configuration.colorVariable,
                   tint: configuration.tint,
                   radius: configuration.radius,
                   x: configuration.x,
                   y: configuration.y)
        } else {
            content
        }
    }
}

// MARK: - Color
public extension TrussUI.Modifier {
    @ViewBuilder
    func tint(_ tint: Tint?) -> some View {
        if let tint {
            content
                .environment(\.TrussUITint, tint)
        } else {
            content
        }
    }
    
    @available(macOS 14.0, *)
    @ViewBuilder
    func tintColor(_ color: Color?) -> some View {
        if let color {
            content
                .environment(\.TrussUITint, .init(lightColor: color))
        } else {
            content
        }
    }
    
    @ViewBuilder
    func foreground(_ style: some ShapeStyle) -> some View {
        content
            .foregroundStyle(style)
    }
    @ViewBuilder
    func foreground(_ variable: ColorVariable) -> some View {
        content
            .foregroundStyle(variable)
    }
    @ViewBuilder
    func foregroundColor(_ color: Color) -> some View {
        content
            .foregroundStyle(color)
    }
}

// MARK: - Padding
public extension TrussUI.Modifier {
    @ViewBuilder
    func padding(_ length: CGFloat, _ edges: Edge.Set = .all) -> some View {
        content.padding(edges, length)
    }
    @ViewBuilder
    func padding(_ padding: TrussUI.Variable.Padding = .regular, _ edges: Edge.Set = .all) -> some View {
        self.padding(.theme.padding(padding), edges)
    }
}

// MARK: - Mask
public extension TrussUI.Modifier {
    @ViewBuilder
    func mask(_ gradient: TrussUI.Gradient?) -> some View {
        if let gradient {
            content.mask {
                Color.clear
                    .overlay(gradient)
            }
        } else {
            content
        }
    }
}

// MARK: - Border
public enum BorderPlacement {
    case inside
    case outside
    case center
}

private struct Border: ViewModifier {
    let placement: BorderPlacement
    let side: Edge.Set
    let style: AnyShapeStyle
    let width: CGFloat
    let cornerRadius: CGFloat
    let mask: TrussUI.Gradient?
    init(style: any ShapeStyle, width: CGFloat, placement: BorderPlacement, cornerRadius: CGFloat, side: Edge.Set = .all, mask: TrussUI.Gradient?) {
        self.placement = placement
        self.style = AnyShapeStyle(style)
        self.width = width
        self.cornerRadius = cornerRadius
        self.side = side
        self.mask = mask
    }
    
    @Environment(\.self) private var environment
    
    func body(content: Content) -> some View {
        content.overlay {
            TrussUI.Component.roundedRectangle(radius)
                .stroke(lineWidth: width)
                .foregroundStyle(style)
                .padding(placementPadding)
                .theme().mask(mask)
        }
    }
    
    private var radius: CGFloat {
        (environment.TrussUICornerRadius ?? cornerRadius) - placementPadding
    }
    
    private var placementPadding: CGFloat {
        switch placement {
        case .inside: width / 2
        case .outside: -width / 2
        case .center: 0
        }
    }
}

public extension TrussUI.Modifier {
    @ViewBuilder
    func border(
        _ style: any ShapeStyle = .Scale.border,
        width: CGFloat = 1,
        placement: BorderPlacement = .inside,
        cornerRadius: CGFloat = 0,
        mask: TrussUI.Gradient? = nil
    ) -> some View {
        content.modifier(Border(style: style, width: width, placement: placement, cornerRadius: cornerRadius, mask: mask))
    }
}

// MARK: - Background
struct Background: ViewModifier {
    let style: AnyShapeStyle
    let cornerRadius: CGFloat
    let shadow: TrussUI.Variable.Shadow?
    let mask: TrussUI.Gradient?
    init(style: some ShapeStyle, cornerRadius: CGFloat, shadow: TrussUI.Variable.Shadow?, mask: TrussUI.Gradient?) {
        self.style = AnyShapeStyle(style)
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.mask = mask
    }
    
    @Environment(\.TrussUICornerRadius) private var envCornerRadius
    
    public func body(content: Content) -> some View {
        content.background {
            TrussUI.Component.roundedRectangle(radius)
                .fill(style)
                .theme().mask(mask)
                .theme().shadow(shadow)
        }
    }
    
    private var radius: CGFloat {
        envCornerRadius ?? cornerRadius
    }
}

public extension TrussUI.Modifier {
    @ViewBuilder
    func background(
        _ style: some ShapeStyle = .Scale.background,
        cornerRadius: CGFloat = 0,
        shadow: TrussUI.Variable.Shadow? = nil,
        mask: TrussUI.Gradient? = nil
    ) -> some View {
        content.modifier(Background(style: style, cornerRadius: cornerRadius, shadow: shadow, mask: mask))
    }
    @ViewBuilder
    func background(
        _ style: some ShapeStyle = .Scale.background,
        cornerRadius: TrussUI.Variable.Radius,
        shadow: TrussUI.Variable.Shadow? = nil,
        mask: TrussUI.Gradient? = nil
    ) -> some View {
        content.modifier(Background(style: style, cornerRadius: cornerRadius.value, shadow: shadow, mask: mask))
    }
}

// MARK: - Clip
private struct Clip: ViewModifier {
    struct Configuration {
        let cornerRadius: CGFloat
        init(cornerRadius: CGFloat) {
            self.cornerRadius = cornerRadius
        }
    }
    
    let configuration: Configuration
    
    @Environment(\.TrussUICornerRadius) private var envCornerRadius
    
    func body(content: Content) -> some View {
        content
            .clipShape(TrussUI.Component.roundedRectangle(envCornerRadius ?? configuration.cornerRadius))
    }
}

public extension TrussUI.Modifier {
    @ViewBuilder
    func clip(
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Clip(configuration: .init(cornerRadius: cornerRadius)))
    }
    @ViewBuilder
    func clip(
        cornerRadius: TrussUI.Variable.Radius
    ) -> some View {
        self.clip(cornerRadius: .theme.radius(cornerRadius))
    }
}

// MARK: - Corner Radius
private struct CornerRadius: ViewModifier {
    let cornerRadius: CGFloat?

    func body(content: Content) -> some View {
        content
            .environment(\.TrussUICornerRadius, cornerRadius)
    }
}

public extension TrussUI.Modifier {
    @ViewBuilder
    func cornerRadius(
        _ cornerRadius: CGFloat?
    ) -> some View {
        content.modifier(CornerRadius(cornerRadius: cornerRadius))
    }
    @ViewBuilder
    func cornerRadius(
        _ cornerRadius: TrussUI.Variable.Radius
    ) -> some View {
        self.cornerRadius(.theme.radius(cornerRadius))
    }
}

// MARK: - Size
private struct Size: ViewModifier {
    let width: CGFloat?
    let height: CGFloat?
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        if width == .infinity || height == .infinity {
            content.frame(maxWidth: width, maxHeight: height, alignment: alignment)
        } else {
            content.frame(width: width, height: height, alignment: alignment)
        }
    }
}

public extension TrussUI.Modifier {
    @ViewBuilder
    func size(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        content.modifier(Size(width: width, height: height, alignment: alignment))
    }
    @ViewBuilder
    func size(
        width: TrussUI.Variable.Size? = nil,
        height: TrussUI.Variable.Size? = nil,
        alignment: Alignment = .center
    ) -> some View {
        let width: CGFloat? = switch width {
        case .some(let width): .theme.size(width)
        case .none: nil
        }
        let height: CGFloat? = switch height {
        case .some(let height): .theme.size(height)
        case .none: nil
        }
        self.size(width: width, height: height, alignment: alignment)
    }
    @ViewBuilder
    func size(
        _ side: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        self.size(width: side, height: side, alignment: alignment)
    }
    @ViewBuilder
    func size(
        _ side: TrussUI.Variable.Size,
        alignment: Alignment = .center
    ) -> some View {
        let side: CGFloat = .theme.size(side)
        self.size(width: side, height: side, alignment: alignment)
    }
}


#Preview(body: {
    VStack {
        Text("Hello!")
            .theme().font(.regular)
            .theme().size(.large)
            .theme().padding(.regular)
    }
})
