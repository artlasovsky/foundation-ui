//
//  PaddingModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.PaddingModifier {
    static func padding(_ token: FoundationUI.Theme.Padding.Token) -> Self {
        FoundationUI.Modifier.PaddingModifier(token: token)
    }
}
public extension FoundationUI.Modifier {
    struct PaddingModifier: FoundationUIModifier {
        let token: FoundationUI.Theme.Padding.Token
        
        init(token: FoundationUI.Theme.Padding.Token) {
            self.token = token
        }
        
        private var edges: Edge.Set = .all
        private var affectDynamicCornerRadius: Bool = false
        
        public func body(content: Content) -> some View {
            content
                .padding(edges, FoundationUI.theme.padding(token))
                .transformEnvironment(\.dynamicCornerRadius) { radius in
                    if let dynamicRadius = radius, affectDynamicCornerRadius {
                        let newRadius = dynamicRadius - FoundationUI.theme.padding(token)
                        radius = newRadius
                    }
                }
        }
        
        public func edges(_ edges: Edge.Set) -> Self {
            var copy = self
            copy.edges = edges
            return copy
        }
        
        public func adjustNestedCornerRadius(_ value: Bool) -> Self {
            var copy = self
            copy.affectDynamicCornerRadius = value
            return copy
        }
    }
}

#Preview {
    VStack {
        Text(FoundationUI.theme.padding(.large).description)
        Text(FoundationUI.theme.padding(.regular.up(.half)).description)
        Text(FoundationUI.theme.padding(.regular).description)
        Text(FoundationUI.theme.padding(.regular.down(.half)).description)
        Text(FoundationUI.theme.padding(.small).description)

        FoundationUI.Shape.roundedRectangle(.regular)
            .foundation(.size(.regular))
            .overlay {
                FoundationUI.Shape.roundedRectangle(.regular)
                    .foundation(.padding(.init(value: FoundationUI.theme.padding(.regular))).edges(.horizontal))
                    .foundation(.padding(.regular).edges(.vertical))
                    .foundation(.size(.regular))
                    .foundation(.foreground(.white))
                FoundationUI.Shape.roundedRectangle(.regular)
                    .foundation(.padding(.init(value: FoundationUI.theme.padding(.regular.up(.half)))).edges(.horizontal))
//                    .foundation(.padding_(.init(value: FoundationUI.theme.padding(.regular))).edges(.horizontal))
                    .foundation(.padding(.regular).edges(.vertical))
                    .foundation(.size(.regular))
                    .foundation(.foreground(.gray.token(.fill)))
            }
    }.padding()
}
