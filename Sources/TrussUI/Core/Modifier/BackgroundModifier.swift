//
//  BackgroundModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<TrussUI.DynamicColor> {
    static func background(_ tint: TrussUI.DynamicColor) -> Self {
        .init(tint, keyPath: nil)
    }

    static func background(_ keyPath: TrussUI.DynamicColor.VariationKeyPath = \.background) -> Self {
        .init(nil, keyPath: keyPath)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<Material> {
    static func backgroundMaterial(_ material: Material) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: material)
    }
}

@available(macOS 13.0, *)
public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<Gradient> {
    static func backgroundGradient(_ gradient: Gradient) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: gradient)
    }
}

public extension TrussUIModifier where Self == TrussUI.Modifier.BackgroundModifier<Color> {
    static func backgroundColor(_ color: Color) -> Self {
        TrussUI.Modifier.BackgroundModifier(fill: color)
    }
}

public extension TrussUI.Modifier {
    struct BackgroundModifier<S: ShapeStyle>: TrussUIModifier {
        @DynamicShapeView<S> private var shapeView
        
        public init(_ tint: TrussUI.DynamicColor? = nil, keyPath: TrussUI.DynamicColor.VariationKeyPath? = nil) where S == TrussUI.DynamicColor {
            self._shapeView = .init(tint: tint, keyPath: keyPath)
        }
        
        public init(fill: S) {
            self._shapeView = .init(fill: fill)
        }
        
        public func body(content: Content) -> some View {
            content.background(shapeView)
        }
        
        /// Setting the `cornerRadius` for the background shape.
        /// > Note: It will override environment value set by `.truss(cornerRadius:)`
        ///
        /// > Note: While using with `.padding()` modifier it will adjust the cornerRadius `truss(.background().padding())`
        public func cornerRadius(_ cornerRadius: TrussUI.Variable.Radius) -> Self {
            var copy = self
            copy._shapeView.cornerRadius = cornerRadius
            return copy
        }
        
        public func shadow(_ shadow: TrussUI.Variable.Shadow) -> Self {
            var copy = self
            copy._shapeView.shadow = shadow
            return copy
        }
        
        public func gradientMask(_ gradientMask: TrussUI.Variable.LinearGradient) -> Self {
            var copy = self
            copy._shapeView.gradientMask = gradientMask
            return copy
        }
        
        public func ignoreEdges(_ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> Self {
            var copy = self
            copy._shapeView.safeAreaRegions = regions
            copy._shapeView.safeAreaEdges = edges
            return copy
        }
        
        public func padding(_ padding: TrussUI.Variable.Padding) -> Self {
            var copy = self
            copy._shapeView.padding = padding
            return copy
        }
    }
}

struct BackgroundModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Basic")
                .truss(.padding())
                .truss(.background(.primary.fillEmphasized))
            Text("Env")
                .truss(.padding())
                .truss(.background(\.fillEmphasized))
            Text("Adj")
                .truss(.padding())
                .border(.white.opacity(0.2))
                .truss(.background(\.fillEmphasized)
                    .gradientMask(.init([.black, .clear]))
                    .shadow(.regular)
                    .cornerRadius(.regular)
                    .padding(.regular.negative())
                )
        }
        .truss(.tint(.red))
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
