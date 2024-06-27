//
//  BackgroundModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<FoundationUI.DynamicColor> {
    static func background(_ tint: FoundationUI.DynamicColor) -> Self {
        .init(tint, keyPath: nil)
    }

    static func background(_ keyPath: FoundationUI.DynamicColor.VariationKeyPath = \.background) -> Self {
        .init(nil, keyPath: keyPath)
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<Material> {
    static func backgroundMaterial(_ material: Material) -> Self {
        FoundationUI.Modifier.BackgroundModifier(fill: material)
    }
}

@available(macOS 13.0, *)
public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<Gradient> {
    static func backgroundGradient(_ gradient: Gradient) -> Self {
        FoundationUI.Modifier.BackgroundModifier(fill: gradient)
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<Color> {
    static func backgroundColor(_ color: Color) -> Self {
        FoundationUI.Modifier.BackgroundModifier(fill: color)
    }
}

public extension FoundationUI.Modifier {
    struct BackgroundModifier<S: ShapeStyle>: FoundationUIModifier {
        @DynamicShapeView<S> private var shapeView
        
        public init(_ tint: FoundationUI.DynamicColor? = nil, keyPath: FoundationUI.DynamicColor.VariationKeyPath? = nil) where S == FoundationUI.DynamicColor {
            self._shapeView = .init(tint: tint, keyPath: keyPath)
        }
        
        public init(fill: S) {
            self._shapeView = .init(fill: fill)
        }
        
        public func body(content: Content) -> some View {
            content.background(shapeView)
        }
        
        /// Setting the `cornerRadius` for the background shape.
        /// > Note: It will override environment value set by `.foundation(cornerRadius:)`
        ///
        /// > Note: While using with `.padding()` modifier it will adjust the cornerRadius `foundation(.background().padding())`
        public func cornerRadius(_ cornerRadius: FoundationUI.Variable.Radius) -> Self {
            var copy = self
            copy._shapeView.cornerRadius = cornerRadius
            return copy
        }
        
        public func shadow(_ shadow: FoundationUI.Token.Shadow.Scale) -> Self {
            var copy = self
            copy._shapeView.shadow = shadow
            return copy
        }
        
        public func gradientMask(_ gradientMask: FoundationUI.Variable.LinearGradient) -> Self {
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
        
        public func padding(_ padding: FoundationUI.Variable.Padding) -> Self {
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
                .foundation(.padding(.regular))
                .foundation(.background(.primary.fillEmphasized))
            Text("Env")
                .foundation(.padding(.regular))
                .foundation(.background(\.fillEmphasized))
            Text("Adj")
                .foundation(.padding(.regular))
                .border(.white.opacity(0.2))
                .foundation(.background(\.fillEmphasized)
                    .gradientMask(.init([.black, .clear]))
                    .shadow(.regular)
                    .cornerRadius(.regular)
                    .padding(.regular.negative())
                )
        }
        .foundation(.tint(.red))
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
