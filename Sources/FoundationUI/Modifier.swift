//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

//extension FoundationUI {
//    public struct Modifier {
//        public var content: AnyView
//        internal init(_ content: some View) {
//            self.content = AnyView(content)
//        }
//    }
//}

// MARK: - View extension
public extension View {
    var theme: FoundationUI.Modifier { self.foundation }
    var foundation: FoundationUI.Modifier { .init(self) }
}

// MARK: - Shadow
extension FoundationUI.Modifier {
    public var padding: Padding { Padding(content) }
    public func padding(_ edges: Edge.Set) -> Padding { .init(content, edges: edges) }
    
    public struct Padding: VariableFunctionScale {
        private let view: AnyView
        private var edges: Edge.Set = .all
        private var length: CGFloat = 0
        
        init(_ view: some View, edges: Edge.Set = .all) {
            self.view = AnyView(view)
            self.edges = edges
        }
        
        public func custom(_ length: CGFloat) -> some View {
            modifier(length)()
        }
        
        public var config: VariableFunctionConfig<some View> {
            .init(
                xxSmall: modifier(.theme.padding.xxSmall),
                xSmall: modifier(.theme.padding.xxSmall),
                small: modifier(.theme.padding.xxSmall),
                regular: modifier(.theme.padding.regular),
                large: modifier(.theme.padding.xxSmall),
                xLarge: modifier(.theme.padding.xxSmall),
                xxLarge: modifier(.theme.padding.xxSmall)
            )
        }
        @ViewBuilder private func body() -> some View {
            view.modifier(PaddingModifier(length, edges: edges))
        }
        private func modifier(_ length: CGFloat) -> () -> some View {
            var copy = self
            copy.length = length
            return copy.body
        }
        
        private struct PaddingModifier: ViewModifier {
            @Environment(\.self) private var env
            let length: CGFloat
            let edges: Edge.Set
            init(_ length: CGFloat, edges: Edge.Set) {
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
}

// MARK: - Shadow
public extension FoundationUI.Modifier {
    var shadow: Shadow { Shadow(content) }
    
    struct Shadow: VariableFunctionScale {
        public struct Style {
            var radius: CGFloat
            var color: FoundationUI.Color = .theme.primary.text.opacity(1)
            var x: CGFloat = 0
            var y: CGFloat = 0
        }
        
        private let view: AnyView
        private var style: Style = .init(radius: 0)
        
        init(_ view: some View) {
            self.view = AnyView(view)
        }
        
        public var config: VariableFunctionConfig<some View> {
            .init(
                xxSmall: modifier(.init(radius: 1)),
                xSmall: modifier(.init(radius: 2)),
                small: modifier(.init(radius: 3)),
                regular: modifier(.init(radius: 4)),
                large: modifier(.init(radius: 6)),
                xLarge: modifier(.init(radius: 7)),
                xxLarge: modifier(.init(radius: 8)))
        }
        
        public func custom(_ style: Style) -> some View {
            modifier(style)()
        }
        
        @ViewBuilder
        private func body() -> some View {
            view.modifier(ShadowModifier(style))
        }
        
        private func modifier(_ style: Style) -> () -> some View {
            var copy = self
            copy.style = style
            return copy.body
        }
        private struct ShadowModifier: ViewModifier {
            @Environment(\.self) private var env
            let style: Shadow.Style
            init(_ style: Shadow.Style) {
                self.style = style
            }
            public func body(content: Content) -> some View {
                content
                    .shadow(color: style.color.light,
                            radius: style.radius,
                            x: style.x,
                            y: style.y)
            }
        }
    }
}

// MARK: - Border
extension FoundationUI.Modifier {
    var border: some View { Border(content, width: 1, placement: .inside).view }
    func border(_ style: any ShapeStyle = .theme.primary.border, width: CGFloat = 1, placement: Border.Modifier.Placement = .inside) -> some View {
        Border(content, width: width, style: style, placement: placement).view
    }
    struct Border {
        let placement: Modifier.Placement
        let style: any ShapeStyle
        let width: CGFloat
        let content: AnyView
        
        init(_ content: some View, width: CGFloat, style: any ShapeStyle = .theme.primary.border, placement: Modifier.Placement) {
            self.style = style
            self.content = AnyView(content)
            self.placement = placement
            self.width = width
        }
        
        @ViewBuilder
        var view: some View {
            content.modifier(Modifier(style: style, width: width, placement: placement))
        }
        public struct Modifier: ViewModifier {
            public enum Placement {
                case inside
                case outside
                case center
            }
            @Environment(\.foundationRadius) private var env
            @Environment(\.foundationPadding) private var envPadding
            @Environment(\.colorScheme) private var colorScheme
    
            private let style: AnyShapeStyle
            private let width: CGFloat
            private let placement: Placement
            // TODO: Change blend to `vibrant`?
            private let blend: Bool
    
            public init(style: any ShapeStyle, width: CGFloat = 1, placement: Placement = .inside, blend: Bool = false) {
                self.style = AnyShapeStyle(style)
                self.width = width
                self.placement = placement
                self.blend = blend
            }
    
            public func body(content: Content) -> some View {
                content.overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: env?.style ?? .continuous)
                        .stroke(lineWidth: width)
                        .foregroundStyle(style)
                        .padding(placementPadding)
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
        
//        static let `default` = Self.init(content)
        
        //    public func border(_ style: any ShapeStyle = Color.white.opacity(0.2), width: CGFloat = 1, placement: Border.Placement = .inside) -> some View {
        //        content.modifier(Border(style: style, width: width, placement: placement, blend: false))
        //    }
        //}
    }
}



// MARK: - LEGACY

// TODO: Animations
// TODO: ForegroundColor

extension View {
//    public var theme: FoundationUI.Modifier { FoundationUI.Modifier(self) }
//    public var foundation: FoundationUI.Modifier { FoundationUI.Modifier(self) }
}
//
//extension FoundationUI.Modifier {
//    public func border(_ style: any ShapeStyle = Color.white.opacity(0.2), width: CGFloat = 1, placement: Border.Placement = .inside) -> some View {
//        content.modifier(Border(style: style, width: width, placement: placement, blend: false))
//    }
//    public struct Border: ViewModifier {
//        public enum Placement {
//            case inside
//            case outside
//            case center
//        }
//        @Environment(\.foundationRadius) private var env
//        @Environment(\.foundationPadding) private var envPadding
//        @Environment(\.colorScheme) private var colorScheme
//        
//        private let style: AnyShapeStyle
//        private let width: CGFloat
//        private let placement: Placement
//        private let blend: Bool
//        
//        public init(style: any ShapeStyle, width: CGFloat = 1, placement: Placement = .inside, blend: Bool = false) {
//            self.style = AnyShapeStyle(style)
//            self.width = width
//            self.placement = placement
//            self.blend = blend
//        }
//        
//        public func body(content: Content) -> some View {
//            content.overlay {
//                RoundedRectangle(cornerRadius: cornerRadius, style: env?.style ?? .continuous)
//                    .stroke(lineWidth: width)
//                    .foregroundStyle(style)
//                    .padding(placementPadding)
//                    .blendMode(blendMode)
//            }
//        }
//        
//        private var placementPadding: CGFloat {
//            switch placement {
//            case .inside:   width / 2
//            case .outside:  -width / 2
//            case .center:   0
//            }
//        }
//        private var cornerRadius: CGFloat {
//            env?.radius ?? 0 - placementPadding
//        }
//        private var blendMode: BlendMode {
//            blend ? colorScheme == .dark ? .plusLighter : .plusDarker : .normal
//        }
//    }
//}
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
