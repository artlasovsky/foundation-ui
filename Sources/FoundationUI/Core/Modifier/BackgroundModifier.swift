//
//  BackgroundModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<FoundationUI.Theme.Color> {
    static func background(_ color: FoundationUI.Theme.Color) -> Self {
        .init(style: color)
    }
    
    static func backgroundTinted(_ token: FoundationUI.Theme.Color.Token) -> Self {
        .init(token: token)
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<Material> {
    static func backgroundMaterial(_ material: Material) -> Self {
        FoundationUI.Modifier.BackgroundModifier(style: material)
    }
}

@available(macOS 13.0, *)
public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<Gradient> {
    static func backgroundGradient(_ gradient: Gradient) -> Self {
        FoundationUI.Modifier.BackgroundModifier(style: gradient)
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.BackgroundModifier<Color> {
    static func backgroundColor(_ color: Color) -> Self {
        FoundationUI.Modifier.BackgroundModifier(style: color)
    }
}

public extension FoundationUI.Modifier {
    struct BackgroundModifier<S: ShapeStyle>: FoundationUIModifier {
        @DynamicShapeView<S> private var shapeView
        
        public init(style: S) {
            self._shapeView = .init(style: style)
        }
        
        public init(token: FoundationUI.Theme.Color.Token) where S == FoundationUI.Theme.Color {
            self._shapeView = .init(token: token)
        }
        
        public func body(content: Content) -> some View {
            content.background(shapeView)
        }
        
        /// Setting the `cornerRadius` for the background shape.
        /// > Note: It will override environment value set by `.foundation(cornerRadius:)`
        ///
        /// > Note: While using with `.padding()` modifier it will adjust the cornerRadius `foundation(.background().padding())`
        public func cornerRadius(_ cornerRadius: FoundationUI.Theme.Radius.Token) -> Self {
            var copy = self
            copy._shapeView.cornerRadiusToken = cornerRadius
            return copy
        }
        
        public func shadow(_ shadow: FoundationUI.Theme.Shadow.Token) -> Self {
            var copy = self
            copy._shapeView.shadow = shadow
            return copy
        }
        
        public func gradientMask(_ gradientMask: FoundationUI.Theme.LinearGradient.Token) -> Self {
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
        
        public func padding(_ padding: FoundationUI.Theme.Padding.Token) -> Self {
            var copy = self
            copy._shapeView.paddingToken = padding
            return copy
        }
    }
}

struct BackgroundModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Basic")
                .foundation(.padding(.regular))
                .foundation(.background(.primary.scale(.fillEmphasized)))
            Text("Tinted")
                .foundation(.padding(.regular))
                .foundation(.backgroundTinted(.fillEmphasized))
            VStack {
                Text("Radius")
                    .foundation(.padding(.large))
                    .foundation(.backgroundTinted(.fillEmphasized).padding(.small))
            }
            .foundation(.background(.primary.scale(.fill)))
            .foundation(.cornerRadius(.regular))
            Text("Adj")
                .border(.white.opacity(0.2))
                .foundation(.padding(.small))
                .foundation(.backgroundTinted(.fillEmphasized)
                    .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                    .shadow(.regular)
                    .cornerRadius(.regular)
                    .padding(.regular.negative())
                )
                .foundation(.padding(.regular).edges(.vertical))
        }
        .foundation(.tint(.red))
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
