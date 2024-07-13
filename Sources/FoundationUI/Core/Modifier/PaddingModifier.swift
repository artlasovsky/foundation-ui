//
//  PaddingModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.ModifierLibrary {
    struct PaddingModifier: ViewModifier {
        let padding: CGFloat
        let edges: Edge.Set
        let adjustNestedCornerRadius: AdjustNestedCornerRadius?
        func body(content: Content) -> some View {
            content.padding(edges, padding)
                .transformEnvironment(\.dynamicCornerRadius) { radius in
                    if let cornerRadius = radius, let adjustNestedCornerRadius {
                        var minCornerRadius: CGFloat = 0
                        switch adjustNestedCornerRadius {
                        case .minimum(let radius):
                            minCornerRadius = radius
                        case .soft:
                            minCornerRadius = 2
                        case .sharp:
                            minCornerRadius = 0
                        }
                        radius = max(cornerRadius - padding, minCornerRadius)
                    }
                }
        }
        
        enum AdjustNestedCornerRadius {
            case minimum(CGFloat = 2)
            case soft
            case sharp
        }
    }
}

extension FoundationUI.Modifier {
    static func padding(_ token: FoundationUI.Theme.Padding = .regular, _ edges: Edge.Set = .all, adjustNestedCornerRadius: Library.PaddingModifier.AdjustNestedCornerRadius? = .none) -> Modifier<Library.PaddingModifier> {
        .init(.init(padding: theme.padding(token), edges: edges, adjustNestedCornerRadius: adjustNestedCornerRadius))
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
                    .foundation(.padding(.init(value: FoundationUI.theme.padding(.regular)), .horizontal))
                    .foundation(.padding(.regular, .vertical))
                    .foundation(.size(.regular))
                    .foundation(.foreground(.white))
                FoundationUI.Shape.roundedRectangle(.regular)
                    .foundation(.padding(.init(value: FoundationUI.theme.padding(.regular.up(.half))), .horizontal))
                    .foundation(.padding(.regular, .vertical))
                    .foundation(.size(.regular))
                    .foundation(.foreground(.gray.token(.fill)))
            }
    }.padding()
}
