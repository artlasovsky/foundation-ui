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
extension View {
    var theme: FoundationUI.Modifier { self.foundation }
    var foundation: FoundationUI.Modifier { .init(self) }
}

// MARK: - Shadow
extension FoundationUI.Modifier {
    var padding: Padding { self.padding(.all) }
    func padding(_ edges: Edge.Set) -> Padding { .init(content, edges: edges) }
    
    struct Padding: VariableScale {
        private let view: AnyView
        private let edges: Edge.Set
        init(_ view: some View, edges: Edge.Set) {
            self.view = AnyView(view)
            self.edges = edges
        }
        @ViewBuilder
        private func getPaddingView(_ value: CGFloat) -> some View {
            AnyView(view.modifier(PaddingModifier(length: value, edges: edges)))
        }
        internal var config: VariableConfig<some View> {
            .init(
                xxSmall: getPaddingView(.theme.padding.xxSmall),
                xSmall: getPaddingView(.theme.padding.xSmall),
                small: getPaddingView(.theme.padding.small),
                regular: getPaddingView(.theme.padding.regular),
                large: getPaddingView(.theme.padding.large),
                xLarge: getPaddingView(.theme.padding.xLarge),
                xxLarge: getPaddingView(.theme.padding.xxLarge)
            )
        }
        private struct PaddingModifier: ViewModifier {
            @Environment(\.self) private var env
            let length: CGFloat
            let edges: Edge.Set
            public func body(content: Content) -> some View {
                content
                    .environment(\.foundationPadding, length)
                    .padding(edges, length)
            }
        }
    }
}

// MARK: - Shadow
extension FoundationUI.Modifier {
    var shadow: Shadow { Shadow(content) }
    
    struct Shadow: VariableScale {
        private struct Style {
            var radius: CGFloat
            var color: FoundationUI.Color = .theme.primary.solid.opacity(0.5)
            var x: CGFloat = 0
            var y: CGFloat = 0
        }
        
        private let view: AnyView
        init(_ view: some View) {
            self.view = AnyView(view)
        }
        @ViewBuilder
        private func getShadowView(_ style: Style) -> some View {
            AnyView(view.modifier(ShadowModifier(style)))
        }
        internal var config: VariableConfig<some View> {
            .init(
                xxSmall: getShadowView(.init(radius: 1)),
                xSmall: getShadowView(.init(radius: 2)),
                small: getShadowView(.init(radius: 3)),
                regular: getShadowView(.init(radius: 4)),
                large: getShadowView(.init(radius: 6)),
                xLarge: getShadowView(.init(radius: 7)),
                xxLarge: getShadowView(.init(radius: 8)))
        }
        private struct ShadowModifier: ViewModifier {
            @Environment(\.self) private var env
            let style: Shadow.Style
            init(_ style: Shadow.Style) {
                self.style = style
            }
            public func body(content: Content) -> some View {
                content
                    .shadow(color: style.color.resolveColor(in: env),
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
        Border(content, width: 1, style: style, placement: placement).view
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
            content.modifier(Modifier(style: style))
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
