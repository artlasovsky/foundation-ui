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
        Self(fill: color)
    }
    static func borderTinted(_ scale: FoundationUI.Theme.Color.Scale) -> Self {
        Self(scale: scale)
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BorderModifier<LinearGradient> {
    static func borderGradient(_ gradient: LinearGradient) -> Self {
        FoundationUI.Modifier.BorderModifier(fill: gradient)
    }
}


public extension FoundationUI.Modifier {
    struct BorderModifier<S: ShapeStyle>: FoundationUIModifier {
        @DynamicShapeView<S> private var shapeView
        
        init(fill: S) {
            _shapeView = .init(fill: fill)
            _shapeView.stroke = .init(width: 1, placement: .center)
        }
        
        public init(scale: FoundationUI.Theme.Color.Scale) where S == FoundationUI.Theme.Color {
            _shapeView = .init(scale: scale)
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

        public func placement(_ placement: Stroke.StrokePlacement) -> Self {
            var copy = self
            copy._shapeView.stroke?.placement = placement
            return copy
        }

        public func cornerRadius(_ cornerRadius: FoundationUI.Theme.Radius.Scale?) -> Self {
            var copy = self
            copy._shapeView = copy._shapeView.cornerRadius(scale: cornerRadius)
            return copy
        }

        public func gradientMask(_ gradientMask: FoundationUI.Theme.LinearGradient.Scale) -> Self {
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
        let gradientVariation: [FoundationUI.DynamicColor.VariationKeyPath] = [\.clear, \.text]
        
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
