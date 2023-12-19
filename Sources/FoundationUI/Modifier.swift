//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension FoundationUI {
    public struct Modifier {
        public var content: AnyView
        internal init(_ content: some View) {
            self.content = AnyView(content)
        }
    }
}

// MARK: - View extension
public extension View {
    func foundation() -> FoundationUI.Modifier { FoundationUI.Modifier(self) }
    func theme() -> FoundationUI.Modifier { FoundationUI.Modifier(self) }
}

// MARK: - Font
public extension FoundationUI.Modifier {
    @ViewBuilder
    func font(_ scale: KeyPath<FoundationUI.Variable.Font, Font>) -> some View {
        self.font(.theme[keyPath: scale])
    }
    
    @ViewBuilder
    func font(_ font: Font) -> some View {
        content.font(font)
    }
}

// MARK: - Shadow
public extension FoundationUI.Modifier {
    @ViewBuilder
    func shadow(_ scale: FoundationUI.ColorScale = .backgroundFaded, tint: FoundationUI.Tint = .primary, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        content.modifier(Shadow(configuration: .init(radius: radius, scale: scale, tint: tint, x: x, y: y)))
    }
    
    @ViewBuilder
    func shadow(_ variable: KeyPath<FoundationUI.Variable.Shadow, Shadow.Configuration>? = nil) -> some View {
        if let variable {
            let configuration = FoundationUI.Variable.shadow[keyPath: variable]
            shadow(configuration.scale,
                   tint: configuration.tint,
                   radius: configuration.radius,
                   x: configuration.x,
                   y: configuration.y)
        } else {
            content
        }
    }
    
    struct Shadow: ViewModifier {
        @Environment(\.self) private var environment
        public struct Configuration {
            var radius: CGFloat
            var scale: FoundationUI.ColorScale = .backgroundFaded
            var tint: FoundationUI.Tint = .primary
            var x: CGFloat = 0
            var y: CGFloat = 0
        }
        public let configuration: Configuration
        public func body(content: Content) -> some View {
            content
                .shadow(color: configuration.scale.tint(configuration.tint).resolveColor(in: environment),
                        radius: configuration.radius,
                        x: configuration.x,
                        y: configuration.y)
        }
    }
}

extension FoundationUI.Variable {
    public struct Shadow: VariableScale {
        public typealias Value = FoundationUI.Modifier.Shadow.Configuration
        public var config: VariableConfig<Value>
        public init(_ config: VariableConfig<Value>) {
            self.config = config
        }
    }
}

// MARK: - Color
public extension FoundationUI.Modifier {
    @ViewBuilder
    func tint(_ tint: FoundationUI.Tint) -> some View {
        content
            .environment(\.foundationUITint, tint)
    }
    @ViewBuilder
    func tint(color: Color) -> some View {
        content
            .environment(\.foundationUITint, .init(color))
    }
    @ViewBuilder
    func foreground(_ scale: FoundationUI.ColorScale) -> some View {
        content
            .foregroundStyle(scale)
    }
    @ViewBuilder
    func foreground(color: Color) -> some View {
        content
            .foregroundStyle(color)
    }
}

// MARK: - Padding
public extension FoundationUI.Modifier {
    @ViewBuilder
    func padding(_ padding: KeyPath<FoundationUI.Variable.Padding, CGFloat> = \.regular, _ edges: Edge.Set = .all) -> some View {
        self.padding(FoundationUI.Variable.padding[keyPath: padding], edges)
    }
    @ViewBuilder
    func padding(_ length: CGFloat, _ edges: Edge.Set = .all) -> some View {
        content.padding(edges, length)
    }
}

// MARK: - Border
public extension FoundationUI.Modifier {
    func border(
        gradient: Border.Configuration.Gradient,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>? = nil
    ) -> some View {
        var cornerRadiusValue: CGFloat = 0
        if let cornerRadius {
            cornerRadiusValue = FoundationUI.Variable.radius[keyPath: cornerRadius]
        }
        return content.modifier(Border(
            configuration: .init(gradient: gradient,
                                 width: width,
                                 placement: placement,
                                 cornerRadius: cornerRadiusValue)))
    }
    func border(
        _ scale: FoundationUI.ColorScale = .border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Border(configuration: .init(style: scale, width: width, placement: placement, cornerRadius: cornerRadius)))
    }
    func border(
        _ style: any ShapeStyle = .scale.border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Border(configuration: .init(style: style, width: width, placement: placement, cornerRadius: cornerRadius)))
    }
    func border(
        _ style: FoundationUI.ColorScale = .border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.border(
            style,
            width: width,
            placement: placement,
            cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    func border(
        _ style: any ShapeStyle = .scale.border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.border(
            style,
            width: width,
            placement: placement,
            cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    struct Border: ViewModifier {
        public enum GradientPoint {
            case top
            case bottom
            case leading
            case trailing
            case topLeading
            case topTrailing
            case bottomLeading
            case bottomTrailing
            
            var opposite: Self {
                switch self {
                case .top:
                    return .bottom
                case .bottom:
                    return .top
                case .leading:
                    return .trailing
                case .trailing:
                    return .leading
                case .topLeading:
                    return .bottomTrailing
                case .topTrailing:
                    return .bottomLeading
                case .bottomLeading:
                    return .topTrailing
                case .bottomTrailing:
                    return .topLeading
                }
            }
            var unitPoint: UnitPoint {
                switch self {
                case .top:
                    return .top
                case .bottom:
                    return .bottom
                case .leading:
                    return .leading
                case .trailing:
                    return .trailing
                case .topLeading:
                    return .topLeading
                case .topTrailing:
                    return .topTrailing
                case .bottomLeading:
                    return .bottomLeading
                case .bottomTrailing:
                    return .bottomTrailing
                }
            }
        }
        public struct Configuration {
            public struct Gradient {
                let colors: [FoundationUI.ColorScale]
                let swiftUIColors: [Color]
                let startPoint: GradientPoint
                // TODO: Add stops (% of full height & absolute value)
                
                init(_ colors: [FoundationUI.ColorScale], startPoint: GradientPoint) {
                    self.colors = colors
                    self.swiftUIColors = []
                    self.startPoint = startPoint
                }
                init(colors: [Color], startPoint: GradientPoint) {
                    self.colors = []
                    self.swiftUIColors = colors
                    self.startPoint = startPoint
                }
            }
            public enum Placement {
                case inside
                case outside
                case center
            }
            let placement: Placement
            let side: Edge.Set
            let style: AnyShapeStyle
            let gradient: Gradient?
            let width: CGFloat
            let cornerRadius: CGFloat
            init(style: any ShapeStyle, width: CGFloat, placement: Placement, cornerRadius: CGFloat, side: Edge.Set = .all) {
                self.placement = placement
                self.style = AnyShapeStyle(style)
                self.width = width
                self.cornerRadius = cornerRadius
                self.side = side
                self.gradient = nil
            }
            init(gradient: Gradient, width: CGFloat, placement: Placement, cornerRadius: CGFloat, side: Edge.Set = .all) {
                self.placement = placement
                self.style = AnyShapeStyle(Color.clear)
                self.gradient = gradient
                self.width = width
                self.cornerRadius = cornerRadius
                self.side = side
            }
        }
        
        public let configuration: Configuration
        
        @Environment(\.self) private var environment
        
        public func body(content: Content) -> some View {
            content.overlay {
                RoundedRectangle.foundation(cornerRadius - placementPadding)
                    .stroke(lineWidth: configuration.width)
                    .foregroundStyle(foregroundStyle)
                    .padding(placementPadding)
            }
        }
        
        private var cornerRadius: CGFloat {
            environment.foundationUICornerRadius ?? configuration.cornerRadius
        }
        
        private var foregroundStyle: AnyShapeStyle {
            if let gradient = configuration.gradient {
                let startPoint = gradient.startPoint.unitPoint
                let endPoint = gradient.startPoint.opposite.unitPoint
                
                var colors: [Color] {
                    gradient.swiftUIColors.isEmpty 
                    ? gradient.colors.map({ $0.resolveColor(in: environment) })
                    : gradient.swiftUIColors
                }
                
                return AnyShapeStyle(LinearGradient(
                    colors: colors,
                    startPoint: startPoint,
                    endPoint: endPoint))
            }
            return configuration.style
        }
        
        private var placementPadding: CGFloat {
            switch configuration.placement {
            case .inside: configuration.width / 2
            case .outside: -configuration.width / 2
            case .center: 0
            }
        }
    }
}

// MARK: - Background
public extension FoundationUI.Modifier {
    @ViewBuilder
    func background(
        style: any ShapeStyle = .scale.background,
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Background(configuration: .init(style: style, cornerRadius: cornerRadius)))
    }
    @ViewBuilder
    func background(
        _ scale: FoundationUI.ColorScale = .background,
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Background(configuration: .init(style: scale, cornerRadius: cornerRadius)))
    }
    @ViewBuilder
    func background(
        style: any ShapeStyle = .scale.background,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.background(style: style, cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    @ViewBuilder
    func background(
        _ scale: FoundationUI.ColorScale = .background,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.background(scale, cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    @ViewBuilder
    func background(
        _ style: FoundationUI.ColorScale = .background,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>,
        shadow: KeyPath<FoundationUI.Variable.Shadow, Shadow.Configuration>? = nil
    ) -> some View {
        content.modifier(Background(configuration: .init(
            style: style,
            cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius],
            shadow: shadow
        )))
    }
    @ViewBuilder
    func background(
        _ style: any ShapeStyle = .scale.background,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>,
        shadow: KeyPath<FoundationUI.Variable.Shadow, Shadow.Configuration>? = nil
    ) -> some View {
        content.modifier(Background(configuration: .init(
            style: style,
            cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius],
            shadow: shadow
        )))
    }
    struct Background: ViewModifier {
        public struct Configuration {
            let style: AnyShapeStyle
            let cornerRadius: CGFloat
            let shadow: KeyPath<FoundationUI.Variable.Shadow, Shadow.Configuration>?
            init(style: any ShapeStyle, cornerRadius: CGFloat, shadow: KeyPath<FoundationUI.Variable.Shadow, Shadow.Configuration>? = nil) {
                self.style = AnyShapeStyle(style)
                self.cornerRadius = cornerRadius
                self.shadow = shadow
            }
        }
        
        @Environment(\.foundationUICornerRadius) private var envCornerRadius
        
        public let configuration: Configuration
        
        public func body(content: Content) -> some View {
            content.background {
                RoundedRectangle.foundation(cornerRadius)
                    .fill(configuration.style)
                    .theme().shadow(configuration.shadow)
            }
        }
        
        private var cornerRadius: CGFloat {
            envCornerRadius ?? configuration.cornerRadius
        }
    }
}

// MARK: - Clip
public extension FoundationUI.Modifier {
    @ViewBuilder
    func clip(
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Clip(configuration: .init(cornerRadius: cornerRadius)))
    }
    @ViewBuilder
    func clip(
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.clip(cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    struct Clip: ViewModifier {
        public struct Configuration {
            let cornerRadius: CGFloat
            init(cornerRadius: CGFloat) {
                self.cornerRadius = cornerRadius
            }
        }
        
        public let configuration: Configuration
        
        @Environment(\.foundationUICornerRadius) private var envCornerRadius
        
        public func body(content: Content) -> some View {
            content
                .clipShape(RoundedRectangle.foundation(envCornerRadius ?? configuration.cornerRadius))
        }
    }
}

// MARK: - Corner Radius
public extension FoundationUI.Modifier {
    @ViewBuilder
    func cornerRadius(
        _ cornerRadius: CGFloat?
    ) -> some View {
        content.modifier(CornerRadius(configuration: .init(cornerRadius: cornerRadius)))
    }
    @ViewBuilder
    func cornerRadius(
        _ cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.cornerRadius(FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    struct CornerRadius: ViewModifier {
        public struct Configuration {
            let cornerRadius: CGFloat?
            init(cornerRadius: CGFloat?) {
                self.cornerRadius = cornerRadius
            }
        }
        
        public let configuration: Configuration
        
        public func body(content: Content) -> some View {
            content
                .environment(\.foundationUICornerRadius, configuration.cornerRadius)
        }
    }
}

// MARK: - Frame
public extension FoundationUI.Modifier {
    @ViewBuilder
    func size(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        content.modifier(Size(configuration: .init(width: width, height: height, alignment: alignment)))
    }
    @ViewBuilder
    func size(
        width: KeyPath<FoundationUI.Variable.Size, CGFloat>? = nil,
        height: KeyPath<FoundationUI.Variable.Size, CGFloat>? = nil,
        alignment: Alignment = .center
    ) -> some View {
        let width: CGFloat? = switch width {
        case .some(let width): FoundationUI.Variable.size[keyPath: width]
        case .none: nil
        }
        let height: CGFloat? = switch height {
        case .some(let height): FoundationUI.Variable.size[keyPath: height]
        case .none: nil
        }
        content.modifier(Size(configuration: .init(width: width, height: height, alignment: alignment)))
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
        _ side: KeyPath<FoundationUI.Variable.Size, CGFloat>,
        alignment: Alignment = .center
    ) -> some View {
        let side = FoundationUI.Variable.size[keyPath: side]
        self.size(width: side, height: side, alignment: alignment)
    }
    struct Size: ViewModifier {
        public struct Configuration {
            let width: CGFloat?
            let height: CGFloat?
            let alignment: Alignment
        }
        
        public let configuration: Configuration
        
        public func body(content: Content) -> some View {
            content.frame(width: configuration.width, height: configuration.height, alignment: configuration.alignment)
        }
    }
}
