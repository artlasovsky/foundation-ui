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
    func foundation() -> FoundationUI.Modifier { .init(self) }
    func theme() -> FoundationUI.Modifier { foundation() }
}

// MARK: - Shadow
public extension FoundationUI.Modifier {
    func shadow(_ color: FoundationUI.Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        content.modifier(Shadow(configuration: .init(radius: radius, color: color, x: x, y: y)))
    }
    
    struct Shadow: ViewModifier {
        public struct Configuration {
            var radius: CGFloat
            var color: FoundationUI.Color = .theme.primary.text.opacity(1)
            var x: CGFloat = 0
            var y: CGFloat = 0
        }
        public let configuration: Configuration
        public func body(content: Content) -> some View {
            content
                .shadow(color: configuration.color.light,
                        radius: configuration.radius,
                        x: configuration.x,
                        y: configuration.y)
        }
    }
}

// MARK: - Shadow
public extension FoundationUI.Modifier {
    @ViewBuilder
    func padding(_ length: CGFloat, _ edges: Edge.Set = .all) -> some View {
        content
            .padding(edges, length)
    }
    @ViewBuilder
    func padding(_ padding: KeyPath<FoundationUI.Variable.Padding, CGFloat> = \.regular, _ edges: Edge.Set = .all) -> some View {
        self.padding(FoundationUI.Variable.padding[keyPath: padding], edges)
    }
}

// MARK: - Border
public extension FoundationUI.Modifier {
    func border(
        _ style: any ShapeStyle = .theme.primary.border,
        width: CGFloat = 1,
        placement: Border.Configuration.Placement = .inside,
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Border(configuration: .init(style: style, width: width, placement: placement, cornerRadius: cornerRadius)))
    }
    func border(
        _ style: any ShapeStyle = .theme.primary.border,
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
        public struct Configuration {
            public enum Placement {
                case inside
                case outside
                case center
            }
            let placement: Placement
            let style: AnyShapeStyle
            let width: CGFloat
            let cornerRadius: CGFloat
            init(style: any ShapeStyle, width: CGFloat, placement: Placement, cornerRadius: CGFloat) {
                self.placement = placement
                self.style = AnyShapeStyle(style)
                self.width = width
                self.cornerRadius = cornerRadius
            }
        }
        
        public let configuration: Configuration
        
        public func body(content: Content) -> some View {
            content.overlay {
                RoundedRectangle.foundation(configuration.cornerRadius)
                    .stroke(lineWidth: configuration.width)
                    .foregroundStyle(configuration.style)
                    .padding(placementPadding)
            }
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

// MARK: - Border
public extension FoundationUI.Modifier {
    @ViewBuilder
    func background(
        _ style: any ShapeStyle = .theme.primary.border,
        cornerRadius: CGFloat = 0
    ) -> some View {
        content.modifier(Background(configuration: .init(style: style, cornerRadius: cornerRadius)))
    }
    @ViewBuilder
    func background(
        _ style: any ShapeStyle = .theme.primary.border,
        cornerRadius: KeyPath<FoundationUI.Variable.Radius, CGFloat>
    ) -> some View {
        self.background(style, cornerRadius: FoundationUI.Variable.radius[keyPath: cornerRadius])
    }
    struct Background: ViewModifier {
        public struct Configuration {
            let style: AnyShapeStyle
            let cornerRadius: CGFloat
            init(style: any ShapeStyle, cornerRadius: CGFloat) {
                self.style = AnyShapeStyle(style)
                self.cornerRadius = cornerRadius
            }
        }
        
        public let configuration: Configuration
        
        public func body(content: Content) -> some View {
            content.background {
                RoundedRectangle.foundation(configuration.cornerRadius)
                    .fill(configuration.style)
            }
        }
    }
}

// MARK: - LEGACY
//
//extension FoundationUI.Modifier {
//    public func background(
//        _ style: some ShapeStyle,
//        cornerRadius: CGFloat = 0,
//        cornerRadiusStyle: RoundedCornerStyle = .continuous,
//        shadow: Shadow? = nil
//    ) -> some View {
//        content.modifier(Background(style: style,
//                                    cornerRadius: cornerRadius,
//                                    cornerRadiusStyle: cornerRadiusStyle,
//                                    shadow: shadow))
//    }
//    public enum CornerRadius {
//        case concentric
//    }
//    public func background(
//        _ style: some ShapeStyle,
//        cornerRadius: CornerRadius,
//        cornerRadiusStyle: RoundedCornerStyle = .continuous,
//        shadow: Shadow? = nil
//    ) -> some View {
//        content
//            .modifier(Background(style: style,
//                                    cornerRadiusStyle: cornerRadiusStyle,
//                                    shadow: shadow))
//            .environment(\.foundationConcentricRadius, cornerRadius == .concentric)
//    }
//    public struct Background: ViewModifier {
//        @Environment(\.foundationRadius) private var env
//        @Environment(\.foundationPadding) private var envPadding
//        @Environment(\.foundationConcentricRadius) private var concentricRadius
//        private let style: AnyShapeStyle
//        private let _cornerRadius: CGFloat
//        private let _cornerRadiusStyle: RoundedCornerStyle
//        private let shadow: Shadow?
//        
//        public init(style: some ShapeStyle, cornerRadius: CGFloat = 0, cornerRadiusStyle: RoundedCornerStyle = .continuous, shadow: Shadow? = nil) {
//            self.style = AnyShapeStyle(style)
//            self._cornerRadius = cornerRadius
//            self._cornerRadiusStyle = cornerRadiusStyle
//            self.shadow = shadow
//        }
//        
//        public func body(content: Content) -> some View {
//            content
//                .environment(\.foundationRadius, (cornerRadius, cornerRadiusStyle))
//                .background {
//                    roundedRect.foregroundStyle(style)
////                        .theme.shadow(shadow)
//                }
//                .background {
//                    roundedRect.foregroundStyle(style)
//                }
//        }
//        
//        private var cornerRadius: CGFloat {
//            if concentricRadius {
//                return (env?.radius ?? _cornerRadius) - (envPadding ?? 0)
//            }
//            return _cornerRadius
//        }
//        private var cornerRadiusStyle: RoundedCornerStyle {
//            if concentricRadius {
//                return env?.style ?? _cornerRadiusStyle
//            }
//            return _cornerRadiusStyle
//        }
//        
//        private var roundedRect: RoundedRectangle { RoundedRectangle(cornerRadius: cornerRadius, style: cornerRadiusStyle) }
//    }
//}
//
//extension FoundationUI.Modifier {
//    public func padding(_ length: CGFloat, _ edges: Edge.Set = .all) -> some View {
//        content.modifier(Padding(edges: edges, length: length))
//    }
//    @ViewBuilder
//    public func shadow(_ style: Shadow?) -> some View {
//        if let style {
//            content.modifier(style)
//        }
//    }
//}

//#Preview("Name"){
//    VStack {
//        VStack {
//            Text("Foundation")
//                .theme.padding(8)
//                .theme.border(.white, width: 1)
//                .theme.background(.blue, cornerRadius: .concentric)
//        }
//        .theme.padding(12)
//        .theme.border()
//        .theme.background(.white.opacity(0.1), cornerRadius: 12)
//    }
//    .padding()
//}
