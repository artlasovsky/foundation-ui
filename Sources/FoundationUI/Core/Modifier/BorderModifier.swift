//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BorderModifier<FoundationUI.DynamicColor> {
    static func border(_ color: FoundationUI.Theme.Color) -> Self {
        Self(style: color)
    }
    static func borderTinted(_ token: FoundationUI.Theme.Color.Token) -> Self {
        Self(token: token)
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BorderModifier<LinearGradient> {
    static func borderGradient(_ gradient: LinearGradient) -> Self {
        FoundationUI.Modifier.BorderModifier(style: gradient)
    }
}


public extension FoundationUI.Modifier {
    struct BorderModifier<S: ShapeStyle>: FoundationUIModifier {
        @DynamicShapeView<S> private var shapeView
        
        init(style: S) {
            _shapeView = .init(style: style)
            _shapeView.stroke = .init(width: 1, placement: .center)
        }
        
        public init(token: FoundationUI.Theme.Color.Token) where S == FoundationUI.Theme.Color {
            _shapeView = .init(token: token)
            _shapeView.stroke = .init(width: 1, placement: .center)
        }
        
        private var placement: BorderPlacement = .inside

        public func body(content: Content) -> some View {
            content.overlay { shapeView }
        }

        public func width(_ width: CGFloat) -> Self {
            var copy = self
            copy._shapeView.stroke?.width = width
            return copy
        }

        public func placement(_ placement: Stroke.Placement) -> Self {
            var copy = self
            copy._shapeView.stroke?.placement = placement
            return copy
        }

        public func cornerRadius(_ cornerRadius: FoundationUI.Theme.Radius.Token?) -> Self {
            var copy = self
            copy._shapeView.cornerRadiusToken = cornerRadius
            return copy
        }

        public func gradientMask(_ gradientMask: FoundationUI.Theme.LinearGradient.Token) -> Self {
            var copy = self
            copy._shapeView.gradientMask = gradientMask
            return copy
        }
    }
}

public enum BorderPlacement {
    case inside
    case outside
    case center
}

#if DEBUG
struct BorderModifier_Preview: PreviewProvider {
    struct Test: View {
        @Environment(\.self) private var env
        let tint: FoundationUI.DynamicColor? = nil
        
        var color: FoundationUI.DynamicColor {
            tint ?? env.dynamicColorTint
        }
        
        var body: some View {
            ZStack {
                Text("")
                    .foundation(.size(.regular))
                    .foundation(
                        .border(.primary).width(2)
                        .placement(.inside)
                        .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                    )
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("Border")
                    .foundation(.size(.regular))
                    .foundation(
                        .border(.primary)
                        .width(2)
                        .placement(.center)
                        .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                    )
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("")
                    .foundation(.size(.regular))
//                    .foundation(.backgroundTinted(.fillFaded))
                    .foundation(
                        .borderTinted(.fill)
                        .width(2)
                        .placement(.outside)
                        .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                    )
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
            }
        }
    }
    static var previews: some View {
        ZStack {
            Test()
            Test().foundation(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
#endif
