//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BorderModifier<FoundationUI.DynamicColor> {
    static func border(_ tint: FoundationUI.DynamicColor) -> Self {
        FoundationUI.Modifier.BorderModifier(tint: tint, keyPath: nil)
    }
    static func border(_ keyPath: FoundationUI.DynamicColor.VariationKeyPath = \.border) -> Self {
        FoundationUI.Modifier.BorderModifier(tint: nil, keyPath: keyPath)
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

        init(tint: FoundationUI.DynamicColor?, keyPath: FoundationUI.DynamicColor.VariationKeyPath?) where S == FoundationUI.DynamicColor {
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

        public func cornerRadius(_ cornerRadius: FoundationUI.Variable.Radius?) -> Self {
            var copy = self
            copy._shapeView.cornerRadius = cornerRadius
            return copy
        }

        public func gradientMask(_ gradientMask: FoundationUI.Variable.LinearGradient) -> Self {
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
        let tint: FoundationUI.DynamicColor? = nil
        let gradientVariation: [FoundationUI.DynamicColor.VariationKeyPath] = [\.clear, \.text]
        
        var color: FoundationUI.DynamicColor {
            tint ?? env.dynamicColorTint
        }
        
        var body: some View {
            ZStack {
                Text("")
                    .foundation(.size(.regular))
                    .foundation(.border(.primary).width(2).placement(.inside).gradientMask(.init([.black, .clear])))
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("Border")
                    .foundation(.size(.regular))
                    .foundation(.border().width(2).placement(.center).gradientMask(.init([.black, .clear])))
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("")
                    .foundation(.size(.regular))
                    .foundation(.border(\.fill).width(2).placement(.outside).gradientMask(.init([.black, .clear])))
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
