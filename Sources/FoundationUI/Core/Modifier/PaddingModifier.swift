//
//  PaddingModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.PaddingModifier {
    static func padding(_ scale: FoundationUI.Theme.Padding.Scale) -> Self {
        FoundationUI.Modifier.PaddingModifier(scale: scale)
    }
}
public extension FoundationUI.Modifier {
    struct PaddingModifier: FoundationUIModifier {
        let scale: FoundationUI.Theme.Padding.Scale
        
        init(scale: FoundationUI.Theme.Padding.Scale) {
            self.scale = scale
        }
        
        private var edges: Edge.Set = .all
        
        public func body(content: Content) -> some View {
            content.padding(edges, FoundationUI.theme.padding(scale))
        }
        
        public func edges(_ edges: Edge.Set) -> Self {
            var copy = self
            copy.edges = edges
            return copy
        }
    }
}

#Preview {
    VStack {
        Text(FoundationUI.theme.padding(.large).description)
//        Text(FoundationUI.theme.padding(.regular.up(.half)).description)
        Text(FoundationUI.theme.padding(.regular).description)
//        Text(FoundationUI.theme.padding(.regular.down(.half)).description)
        Text(FoundationUI.theme.padding(.small).description)

        FoundationUI.Shape.roundedRectangle(.regular)
            .foundation(.size(.regular))
            .overlay {
                FoundationUI.Shape.roundedRectangle(.regular)
                    .foundation(.padding(.init(value: .theme.padding(.regular))).edges(.horizontal))
                    .foundation(.padding(.regular).edges(.vertical))
                    .foundation(.size(.regular))
                    .foundation(.foreground(.white))
                FoundationUI.Shape.roundedRectangle(.regular)
                    .foundation(.padding(.init(value: .theme.padding(.regular.up(.half)))).edges(.horizontal))
//                    .foundation(.padding_(.init(value: FoundationUI.theme.padding(.regular))).edges(.horizontal))
                    .foundation(.padding(.regular).edges(.vertical))
                    .foundation(.size(.regular))
                    .foundation(.foreground(.gray.scale(.fill)))
            }
    }.padding()
}
