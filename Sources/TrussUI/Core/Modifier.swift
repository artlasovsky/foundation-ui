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

// MARK: - Foreground
public extension TrussUIModifier where Self == TrussUI.Modifier.ColorModifier {
    static func tint(_ colorSet: TrussUI.ColorSet?) -> Self {
        TrussUI.Modifier.ColorModifier(type: .tint(colorSet))
    }
    @available(macOS 14.0, iOS 17.0, *)
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
}

public extension TrussUI.Modifier {
    struct ColorModifier: TrussUIModifier {
        let type: ModifierType
        enum ModifierType {
            case tint(_ colorSet: TrussUI.ColorSet?)
            case foreground(_ tintedColorSet: TrussUI.TintedColorSet)
            case foregroundColor(_ color: Color)
        }
        public func body(content: Content) -> some View {
            switch type {
            case .tint(let variable):
                content.environment(\.trussUITint, variable)
            case .foreground(let variable):
                content.foregroundStyle(variable)
            case .foregroundColor(let color):
                content.foregroundStyle(color)
            }
        }
    }
}

// MARK: - Background
public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<TrussUI.TintedColorSet> {
    static func background(_ tintedColorSet: TrussUI.TintedColorSet = .background) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: tintedColorSet)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<Material> {
    static func backgroundMaterial(_ material: Material) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: material)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<Gradient> {
    static func backgroundGradient(_ gradient: Gradient) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: gradient)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<Color> {
    static func backgroundColor(_ color: Color) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: color)
    }
}

public extension TrussUI.Modifier {
    struct BackgroundModifier<S: ShapeStyle>: TrussUIModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        
        private let fill: S
        
        init(fill: S) {
            self.fill = fill
        }
        
        private var cornerRadius: TrussUI.Variable.Radius?
        private var shadow: TrussUI.Variable.Shadow?
        private var gradientMask: TrussUI.Gradient?
        
        private var padding: TrussUI.Variable.Padding = .init(value: 0)
        
        private var safeAreaRegions: SafeAreaRegions?
        private var safeAreaEdges: Edge.Set?
        
        public func body(content: Content) -> some View {
            content.background { background() }
        }
        
        @ViewBuilder
        private func background() -> some View {
            let base = TrussUI.Shape.roundedRectangle(radius: radius)
                .fill(fill)
                .truss(.gradientMask(gradientMask))
                .truss(.shadow(shadow))
                .truss(.padding(padding))
            if let safeAreaRegions, let safeAreaEdges {
                base.ignoresSafeArea(safeAreaRegions, edges: safeAreaEdges)
            } else {
                base
            }
        }
        
        /// Setting the `cornerRadius` for the background shape.
        /// > Note: It will override environment value set by `.truss(cornerRadius:)`
        public func cornerRadius(_ cornerRadius: TrussUI.Variable.Radius) -> Self {
            var copy = self
            copy.cornerRadius = cornerRadius
            return copy
        }
        
        public func shadow(_ shadow: TrussUI.Variable.Shadow) -> Self {
            var copy = self
            copy.shadow = shadow
            return copy
        }
        public func gradientMask(_ gradientMask: TrussUI.Gradient) -> Self {
            var copy = self
            copy.gradientMask = gradientMask
            return copy
        }
        
        public func ignoreEdges(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> Self {
            var copy = self
            copy.safeAreaRegions = regions
            copy.safeAreaEdges = edges
            return copy
        }
        
        public func padding(_ padding: TrussUI.Variable.Padding) -> Self {
            var copy = self
            copy.padding = padding
            return copy
        }
        
        private var radius: CGFloat {
            (cornerRadius?.value ?? envCornerRadius ?? 0) - padding.value
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
    static func padding(_ variable: TrussUI.Variable.Padding = .regular) -> Self {
        TrussUI.Modifier.PaddingModifier(variable: variable)
    }
}
public extension TrussUI.Modifier {
    struct PaddingModifier: TrussUIModifier {
        private let variable: TrussUI.Variable.Padding
        
        init(variable: TrussUI.Variable.Padding) {
            self.variable = variable
        }
        
        private var edges: Edge.Set = .all
        
        public func body(content: Content) -> some View {
            content.padding(edges, variable.value)
        }
        
        public func edges(_ edges: Edge.Set) -> Self {
            var copy = self
            copy.edges = edges
            return copy
        }
    }
}

// MARK: - Border
public extension TrussUIModifier where Self == TrussUI.Modifier.BorderModifier<TrussUI.TintedColorSet> {
    static func border(_ tintedColorSet: TrussUI.TintedColorSet = .border) -> Self {
        TrussUI.Modifier.BorderModifier(tintedColorSet)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BorderModifier<TrussUI.Gradient> {
    static func borderGradient(_ gradient: TrussUI.Gradient) -> Self {
        TrussUI.Modifier.BorderModifier(gradient)
    }
}

public extension TrussUI.Modifier {
    struct BorderModifier<S: ShapeStyle>: TrussUIModifier {
        @Environment(\.TrussUICornerRadius) private var envCornerRadius
        
        private let style: S
        public init(_ style: S) {
            self.style = style
        }
        
        private var width: CGFloat = 1
        private var placement: BorderPlacement = .inside
        private var cornerRadius: TrussUI.Variable.Radius? = nil
        private var gradientMask: TrussUI.Gradient? = nil
        
        public func body(content: Content) -> some View {
            content.overlay {
                TrussUI.Shape.roundedRectangle(radius: radius)
                    .stroke(lineWidth: width)
                    .foregroundStyle(style)
                    .padding(placementPadding)
                    .truss(.gradientMask(gradientMask))
            }
        }
        
        public func width(_ width: CGFloat) -> Self {
            var copy = self
            copy.width = width
            return copy
        }
        
        public func placement(_ placement: BorderPlacement) -> Self {
            var copy = self
            copy.placement = placement
            return copy
        }
        
        public func cornerRadius(_ cornerRadius: TrussUI.Variable.Radius?) -> Self {
            var copy = self
            copy.cornerRadius = cornerRadius
            return copy
        }
        
        public func gradientMask(_ gradientMask: TrussUI.Gradient) -> Self {
            var copy = self
            copy.gradientMask = gradientMask
            return copy
        }
        
        private var radius: CGFloat {
            if let cornerRadius = cornerRadius?.value ?? envCornerRadius {
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
            if let cornerRadius = cornerRadius?.value ?? envCornerRadius {
                content.clipShape(TrussUI.Shape.roundedRectangle(radius: cornerRadius))
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
    static func size(width: TrussUI.Variable.Size? = nil, height: TrussUI.Variable.Size? = nil) -> Self {
        TrussUI.Modifier.SizeModifier(width: width, height: height)
    }
    static func size(_ side: TrussUI.Variable.Size) -> Self {
        TrussUI.Modifier.SizeModifier(width: side, height: side)
    }
}

public extension TrussUI.Modifier {
    struct SizeModifier: TrussUIModifier {
        private let width: TrussUI.Variable.Size?
        private let height: TrussUI.Variable.Size?
        
        init(width: TrussUI.Variable.Size?, height: TrussUI.Variable.Size?) {
            self.width = width
            self.height = height
        }
        
        private var alignment: Alignment = .center
        
        public func body(content: Content) -> some View {
            let width = width?.value
            let height = height?.value
            if width == .infinity || height == .infinity {
                content.frame(maxWidth: width, maxHeight: height, alignment: alignment)
            } else {
                content.frame(width: width, height: height, alignment: alignment)
            }
        }
        
        public func alignment(_ alignment: Alignment) -> Self {
            var copy = self
            copy.alignment = alignment
            return copy
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
                Text("Button")
                    .truss(.padding(.regular).edges(.horizontal))
                    .truss(.padding(.small).edges(.vertical))
                    .truss(.font(.regular))
//                    .truss(.size(width: .regular, height: .small))
                    .truss(
                        .background(.fill.opacity(isHovered ? 1 : 0.2))
                        .cornerRadius(.regular)
                        .padding(.regular.negative())
                    )
                    .truss(.border(.border).cornerRadius(.regular))
//                    .truss(.cornerRadius(.large))
            }
            .truss(.size(.large))
            .truss(.padding(.regular))
            .truss(.background())
            .onHover { isHovered = $0 }
        }
    }
    static var previews: some View {
        Preview()
    }
}
