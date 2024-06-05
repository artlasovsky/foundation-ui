//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.BorderModifier<TrussUI.DynamicColor> {
    static func border(_ tint: TrussUI.DynamicColor) -> Self {
        TrussUI.Modifier.BorderModifier(tint: tint, keyPath: nil)
    }
    static func border(_ keyPath: TrussUI.DynamicColor.VariationKeyPath = \.border) -> Self {
        TrussUI.Modifier.BorderModifier(tint: nil, keyPath: keyPath)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BorderModifier<LinearGradient> {
    static func borderGradient(_ gradient: LinearGradient) -> Self {
        TrussUI.Modifier.BorderModifier(fill: gradient)
    }
}


public extension TrussUI.Modifier {
    struct BorderModifier<S: ShapeStyle>: TrussUIModifier {
        @DynamicShapeView<S> private var shapeView

        init(tint: TrussUI.DynamicColor?, keyPath: TrussUI.DynamicColor.VariationKeyPath?) where S == TrussUI.DynamicColor {
            _shapeView = .init(tint: tint, keyPath: keyPath)
            _shapeView.stroke = .init(width: 1, placement: .inside)
        }
        
        init(fill: S) {
            _shapeView = .init(fill: fill)
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

        public func cornerRadius(_ cornerRadius: TrussUI.Variable.Radius?) -> Self {
            var copy = self
            copy._shapeView.cornerRadius = cornerRadius
            return copy
        }

        public func gradientMask(_ gradientMask: TrussUI.Variable.LinearGradient) -> Self {
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

struct BorderModifier_Preview: PreviewProvider {
    struct Test: View {
        @Environment(\.self) private var env
        let tint: TrussUI.DynamicColor? = nil
        let gradientVariation: [TrussUI.DynamicColor.VariationKeyPath] = [\.clear, \.text]
        
        var color: TrussUI.DynamicColor {
            tint ?? env.dynamicColorTint
        }
        
        var body: some View {
            ZStack {
                Text("")
                    .truss(.size(.regular))
                    .truss(.border(.primary).width(2).placement(.inside).gradientMask(.init([.black, .clear])))
                    .truss(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("Border")
                    .truss(.size(.regular))
                    .truss(.border().width(2).placement(.center).gradientMask(.init([.black, .clear])))
                    .truss(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("")
                    .truss(.size(.regular))
                    .truss(.border(\.fill).width(2).placement(.outside).gradientMask(.init([.black, .clear])))
                    .truss(.cornerRadius(.regular))
                    .opacity(0.5)
            }
        }
    }
    static var previews: some View {
        ZStack {
            Test()
            Test().truss(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
