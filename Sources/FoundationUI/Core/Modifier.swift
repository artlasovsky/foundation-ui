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
        public typealias Tint = FoundationUI.Tint
        public typealias ColorScale = FoundationUI.ColorScale
        public typealias Scale = FoundationUI.Scale
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
    func font(_ scale: Scale.Font.KeyPath) -> some View {
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
    func shadow(_ scale: ColorScale = .backgroundFaded, tint: Tint = .primary, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        content.modifier(Shadow(configuration: .init(radius: radius, scale: scale, tint: tint, x: x, y: y)))
    }
    
    @ViewBuilder
    func shadow(_ variable: Scale.Shadow.KeyPath? = nil) -> some View {
        if let variable {
            let configuration = Scale.shadow[keyPath: variable]
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
            var scale: ColorScale = .backgroundFaded
            var tint: Tint = .primary
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

// MARK: - Color
public extension FoundationUI.Modifier {
    @ViewBuilder
    func tint(_ tint: Tint) -> some View {
        content
            .environment(\.foundationUITint, tint)
    }
    @ViewBuilder
    func tint(color: Color) -> some View {
        content
            .environment(\.foundationUITint, .init(color))
    }
    @ViewBuilder
    func foreground(_ scale: ColorScale) -> some View {
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
    func padding(_ padding: Scale.Padding.KeyPath = \.regular, _ edges: Edge.Set = .all) -> some View {
        self.padding(.theme.padding[keyPath: padding], edges)
    }
    static func getPadding(_ padding: Scale.Padding.KeyPath = \.regular, _ edges: Edge.Set = .all) -> CGFloat {
        .theme.padding[keyPath: padding]
    }
    @ViewBuilder
    func padding(_ length: CGFloat, _ edges: Edge.Set = .all) -> some View {
        content.padding(edges, length)
    }
}

// MARK: - Mask
public extension FoundationUI.Modifier {
    func mask(_ gradient: FoundationUI.Gradient?) -> some View {
        content.mask {
            if let gradient {
                Color.clear
                    .overlay(gradient)
            } else {
                Color.black
            }
        }
    }
}

// MARK: - Border
public extension FoundationUI.Modifier {
    func border(
        _ scale: ColorScale = .border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: CGFloat = 0,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        content.modifier(Border(configuration: .init(style: scale, width: width, placement: placement, cornerRadius: cornerRadius, mask: mask)))
    }
    func border(
        _ style: any ShapeStyle = .scale.border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: CGFloat = 0,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        content.modifier(Border(configuration: .init(style: style, width: width, placement: placement, cornerRadius: cornerRadius, mask: mask)))
    }
    func border(
        _ style: ColorScale = .border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: Scale.Radius.KeyPath,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        self.border(
            style,
            width: width,
            placement: placement,
            cornerRadius: .theme.radius[keyPath: cornerRadius],
            mask: mask
        )
    }
    func border(
        _ style: any ShapeStyle = .scale.border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: Scale.Radius.KeyPath,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        self.border(
            style,
            width: width,
            placement: placement,
            cornerRadius: .theme.radius[keyPath: cornerRadius],
            mask: mask
        )
    }
    struct Border: ViewModifier {
        public struct Configuration {
            public enum Placement {
                case inside
                case outside
                case center
            }
            let placement: Placement
            let side: Edge.Set
            let style: AnyShapeStyle
            let width: CGFloat
            let cornerRadius: CGFloat
            let mask: FoundationUI.Gradient?
            init(style: any ShapeStyle, width: CGFloat, placement: Placement, cornerRadius: CGFloat, side: Edge.Set = .all, mask: FoundationUI.Gradient?) {
                self.placement = placement
                self.style = AnyShapeStyle(style)
                self.width = width
                self.cornerRadius = cornerRadius
                self.side = side
                self.mask = mask
            }
        }
        
        public let configuration: Configuration
        
        @Environment(\.self) private var environment
        
        public func body(content: Content) -> some View {
            content.overlay {
                RoundedRectangle.foundation(cornerRadius - placementPadding)
                    .stroke(lineWidth: configuration.width)
                    .foregroundStyle(configuration.style)
                    .padding(placementPadding)
                    .theme().mask(configuration.mask)
            }
        }
        
        private var cornerRadius: CGFloat {
            environment.foundationUICornerRadius ?? configuration.cornerRadius
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
        cornerRadius: CGFloat = 0,
        shadow: Scale.Shadow.KeyPath? = nil,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        content.modifier(Background(configuration: .init(style: style, cornerRadius: cornerRadius, shadow: nil, mask: mask)))
    }
    @ViewBuilder
    func background(
        _ scale: ColorScale = .background,
        cornerRadius: CGFloat = 0,
        shadow: Scale.Shadow.KeyPath? = nil,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        content.modifier(Background(configuration: .init(style: scale, cornerRadius: cornerRadius, shadow: nil, mask: mask)))
    }
    @ViewBuilder
    func background(
        style: any ShapeStyle = .scale.background,
        cornerRadius: Scale.Radius.KeyPath,
        shadow: Scale.Shadow.KeyPath? = nil,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        self.background(style: style, cornerRadius: .theme.radius[keyPath: cornerRadius], shadow: shadow, mask: mask)
    }
    @ViewBuilder
    func background(
        _ style: ColorScale = .background,
        cornerRadius: Scale.Radius.KeyPath,
        shadow: Scale.Shadow.KeyPath? = nil,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        content.modifier(Background(configuration: .init(
            style: style,
            cornerRadius: .theme.radius[keyPath: cornerRadius],
            shadow: shadow,
            mask: mask
        )))
    }
    @ViewBuilder
    func background(
        _ style: any ShapeStyle = .scale.background,
        cornerRadius: Scale.Radius.KeyPath,
        shadow: Scale.Shadow.KeyPath? = nil,
        mask: FoundationUI.Gradient? = nil
    ) -> some View {
        content.modifier(Background(configuration: .init(
            style: style,
            cornerRadius: .theme.radius[keyPath: cornerRadius],
            shadow: shadow,
            mask: mask
        )))
    }
    struct Background: ViewModifier {
        public struct Configuration {
            let style: AnyShapeStyle
            let cornerRadius: CGFloat
            let shadow: Scale.Shadow.KeyPath?
            let mask: FoundationUI.Gradient?
            init(style: any ShapeStyle, cornerRadius: CGFloat, shadow: Scale.Shadow.KeyPath?, mask: FoundationUI.Gradient?) {
                self.style = AnyShapeStyle(style)
                self.cornerRadius = cornerRadius
                self.shadow = shadow
                self.mask = mask
            }
        }
        
        @Environment(\.foundationUICornerRadius) private var envCornerRadius
        
        public let configuration: Configuration
        
        public func body(content: Content) -> some View {
            content.background {
                RoundedRectangle.foundation(cornerRadius)
                    .fill(configuration.style)
                    .theme().mask(configuration.mask)
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
        cornerRadius: Scale.Radius.KeyPath
    ) -> some View {
        self.clip(cornerRadius: .theme.radius[keyPath: cornerRadius])
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
        _ cornerRadius: Scale.Radius.KeyPath
    ) -> some View {
        self.cornerRadius(.theme.radius[keyPath: cornerRadius])
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

// MARK: - Size
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
        width: FoundationUI.Scale.Size.KeyPath? = nil,
        height: FoundationUI.Scale.Size.KeyPath? = nil,
        alignment: Alignment = .center
    ) -> some View {
        let width: CGFloat? = switch width {
        case .some(let width): .theme.size[keyPath: width]
        case .none: nil
        }
        let height: CGFloat? = switch height {
        case .some(let height): .theme.size[keyPath: height]
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
        _ side: Scale.Size.KeyPath,
        alignment: Alignment = .center
    ) -> some View {
        let side: CGFloat = .theme.size[keyPath: side]
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
            if configuration.width == .infinity || configuration.height == .infinity {
                content.frame(maxWidth: configuration.width, maxHeight: configuration.height, alignment: configuration.alignment)
            } else {
                content.frame(width: configuration.width, height: configuration.height, alignment: configuration.alignment)                
            }
        }
    }
}
