//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

// TODO: Animations
// TODO: ForegroundColor

extension FoundationUI {
    public struct Modifier {
        public var content: AnyView
        internal init(_ content: some View) {
            self.content = AnyView(content)
        }
    }
}

extension View {
    public var theme: FoundationUI.Modifier { FoundationUI.Modifier(self) }
    public var foundation: FoundationUI.Modifier { FoundationUI.Modifier(self) }
}

extension FoundationUI.Modifier {
    public struct Border: ViewModifier {
        public enum Placement {
            case inside
            case outside
            case center
        }
        @Environment(\.foundationRadius) private var env
        @Environment(\.foundationPadding) private var envPadding
        @Environment(\.colorScheme) private var colorScheme
        
        private let color: SwiftUI.Color
        private let width: CGFloat
        private let placement: Placement
        private let opacity: CGFloat
        private let blend: Bool
        
        public init(color: SwiftUI.Color, width: CGFloat = 1, placement: Placement = .inside, opacity: CGFloat = 0.1, blend: Bool = true) {
            self.color = color
            self.width = width
            self.placement = placement
            self.opacity = opacity
            self.blend = blend
        }
        
        public func body(content: Content) -> some View {
            content.overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: env?.style ?? .continuous)
                    .stroke(lineWidth: width)
                    .padding(placementPadding)
                    .opacity(opacity)
                    .blendMode(blendMode)
            }
        }
        
        private var placementPadding: CGFloat {
            switch placement {
            case .inside:   width / 2
            case .outside:  -width / 2
            case .center:   0
            }
        }
        private var cornerRadius: CGFloat {
            env?.radius ?? 0 - placementPadding
        }
        private var blendMode: BlendMode {
            blend ? colorScheme == .dark ? .plusLighter : .plusDarker : .normal
        }
    }
    public struct Shadow: ViewModifier {
        public let color: SwiftUI.Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
        public init(_ color: SwiftUI.Color = .black, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
        public func body(content: Content) -> some View {
            content.shadow(color: color, radius: radius, x: x, y: y)
        }
    }
    public struct Padding: ViewModifier {
        private let length: CGFloat
        private let edges: Edge.Set
        public init(edges: Edge.Set, length: CGFloat) {
            self.length = length
            self.edges = edges
        }
        public func body(content: Content) -> some View {
            content
                .environment(\.foundationPadding, length)
                .padding(edges, length)
        }
    }
}

extension FoundationUI.Modifier {
    public struct Background: ViewModifier {
        @Environment(\.foundationRadius) private var env
        @Environment(\.foundationPadding) private var envPadding
        @Environment(\.foundationConcentricRadius) private var concentricRadius
        private let style: AnyShapeStyle
        private let _cornerRadius: CGFloat
        private let _cornerRadiusStyle: RoundedCornerStyle
        private let shadow: Shadow?
        
        public init(style: some ShapeStyle, cornerRadius: CGFloat = 0, cornerRadiusStyle: RoundedCornerStyle = .continuous, shadow: Shadow? = nil) {
            self.style = AnyShapeStyle(style)
            self._cornerRadius = cornerRadius
            self._cornerRadiusStyle = cornerRadiusStyle
            self.shadow = shadow
        }
        
        public func body(content: Content) -> some View {
            content
                .environment(\.foundationRadius, (cornerRadius, cornerRadiusStyle))
                .background {
                    roundedRect.foregroundStyle(style)
                        .theme.shadow(shadow)
                }
                .background {
                    roundedRect.foregroundStyle(style)
                }
        }
        
        private var cornerRadius: CGFloat {
            if concentricRadius {
                return (env?.radius ?? _cornerRadius) - (envPadding ?? 0)
            }
            return _cornerRadius
        }
        private var cornerRadiusStyle: RoundedCornerStyle {
            if concentricRadius {
                return env?.style ?? _cornerRadiusStyle
            }
            return _cornerRadiusStyle
        }
        
        private var roundedRect: RoundedRectangle { RoundedRectangle(cornerRadius: cornerRadius, style: cornerRadiusStyle) }
    }
    public func background(
        _ style: some ShapeStyle,
        cornerRadius: CGFloat = 0,
        cornerRadiusStyle: RoundedCornerStyle = .continuous,
        shadow: Shadow? = nil
    ) -> some View {
        content.modifier(Background(style: style,
                                    cornerRadius: cornerRadius,
                                    cornerRadiusStyle: cornerRadiusStyle,
                                    shadow: shadow))
    }
    public enum CornerRadius {
        case concentric
    }
    public func background(
        _ style: some ShapeStyle,
        cornerRadius: CornerRadius,
        cornerRadiusStyle: RoundedCornerStyle = .continuous,
        shadow: Shadow? = nil
    ) -> some View {
        content
            .modifier(Background(style: style,
                                    cornerRadiusStyle: cornerRadiusStyle,
                                    shadow: shadow))
            .environment(\.foundationConcentricRadius, cornerRadius == .concentric)
    }
}

extension FoundationUI.Modifier {
    public func border(color: SwiftUI.Color = .white.opacity(0.2), width: CGFloat = 1) -> some View {
        content.modifier(Border(color: color, width: width))
    }
    public func padding(_ length: CGFloat, _ edges: Edge.Set = .all) -> some View {
        content.modifier(Padding(edges: edges, length: length))
    }
    @ViewBuilder
    public func shadow(_ style: Shadow?) -> some View {
        if let style {
            content.modifier(style)
        }
    }
}

#Preview("Name"){
    VStack {
        VStack {
            Text("Foundation")
                .theme.padding(8)
                .theme.border(color: .white, width: 1)
                .theme.background(.blue, cornerRadius: .concentric)
        }
        .theme.padding(12)
        .theme.border()
        .theme.background(.white.opacity(0.1), cornerRadius: 12)
    }
    .padding()
}

// MARK: - Environment Values
private struct FoundationConcentricRadiusKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct FoundationRadiusKey: EnvironmentKey {
    static let defaultValue: (radius: CGFloat, style: RoundedCornerStyle)? = nil
}

private struct FoundationPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat? = 0
}

extension EnvironmentValues {
    public var foundationRadius: (radius: CGFloat, style: RoundedCornerStyle)? {
        get { self[FoundationRadiusKey.self] }
        set { self[FoundationRadiusKey.self] = newValue }
    }
    public var foundationConcentricRadius: Bool {
        get { self[FoundationConcentricRadiusKey.self] }
        set { self[FoundationConcentricRadiusKey.self] = newValue }
    }
    public var foundationPadding: CGFloat? {
        get { self[FoundationPaddingKey.self] }
        set { self[FoundationPaddingKey.self] = newValue }
    }
}
