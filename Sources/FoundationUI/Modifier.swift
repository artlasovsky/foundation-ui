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
                RoundedRectangle(cornerRadius: cornerRadius, style: env.style)
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
            env.radius - placementPadding
        }
        private var blendMode: BlendMode {
            blend ? colorScheme == .dark ? .plusLighter : .plusDarker : .normal
        }
    }
    public struct Background: ViewModifier {
        private let style: AnyShapeStyle
        private let cornerRadius: CGFloat
        private let cornerRadiusStyle: RoundedCornerStyle
        
        public init(style: some ShapeStyle, cornerRadius: CGFloat = 0, cornerRadiusStyle: RoundedCornerStyle = .continuous) {
            self.style = AnyShapeStyle(style)
            self.cornerRadius = cornerRadius
            self.cornerRadiusStyle = cornerRadiusStyle
        }
        
        public func body(content: Content) -> some View {
            content
                .environment(\.foundationRadius, (cornerRadius, cornerRadiusStyle))
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: cornerRadiusStyle)
                        .foregroundStyle(style)
                }
        }
    }
    public struct Shadow: ViewModifier {
        private let style: FoundationUI.Shadow
        public init(_ style: FoundationUI.Shadow) {
            self.style = style
        }
        public func body(content: Content) -> some View {
            content.shadow(color: style.color,
                           radius: style.radius,
                           x: style.x,
                           y: style.y)
        }
    }
}

extension FoundationUI.Modifier {
    public func background(_ style: some ShapeStyle, cornerRadius: CGFloat = 0, cornerRadiusStyle: RoundedCornerStyle = .continuous) -> some View {
        content.modifier(Background(style: style, cornerRadius: cornerRadius, cornerRadiusStyle: cornerRadiusStyle))
    }
    public func border(color: SwiftUI.Color, width: CGFloat) -> some View {
        content.modifier(Border(color: color, width: width))
    }
    public func shadow(_ style: FoundationUI.Shadow) -> some View {
        content.modifier(Shadow(style))
    }
}

#Preview("Name"){
    VStack {
        Text("Foundation")
            .padding()
            .theme.border(color: .white, width: 1)
            .theme.background(.blue, cornerRadius: 12)
            .foregroundStyle(.primary)
    }
    .padding()
}

// MARK: - Environment Values
private struct FoundationRadiusKey: EnvironmentKey {
    static let defaultValue: (radius: CGFloat, style: RoundedCornerStyle) = (0, .continuous)
}

private struct FoundationPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    public var foundationRadius: (radius: CGFloat, style: RoundedCornerStyle) {
        get { self[FoundationRadiusKey.self] }
        set { self[FoundationRadiusKey.self] = newValue }
    }
    public var foundationPadding: CGFloat {
        get { self[FoundationPaddingKey.self] }
        set { self[FoundationPaddingKey.self] = newValue }
    }
}
