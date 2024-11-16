//
//  PaddingModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct PaddingModifier: ViewModifier {
        let padding: CGFloat
        let edges: Edge.Set
        let adjustNestedCornerRadius: AdjustNestedCornerRadius?
        
        public func body(content: Content) -> some View {
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
        
        public enum AdjustNestedCornerRadius {
            case minimum(CGFloat = 2)
            case soft
            case sharp
        }
    }
}

public extension FoundationModifier {
    static func padding(
        _ token: Theme.Padding,
        _ edges: Edge.Set = .all,
        adjustNestedCornerRadius: FoundationModifierLibrary.PaddingModifier.AdjustNestedCornerRadius? = .none
    ) -> FoundationModifier<FoundationModifierLibrary.PaddingModifier> {
        .init(
            .init(
                padding: .foundation(.padding(token)),
                edges: edges,
                adjustNestedCornerRadius: adjustNestedCornerRadius
            )
        )
    }
}

struct PaddingModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text(Theme.default.padding(.large).description)
            Text(Theme.default.padding(.regular.up(.half)).description)
            Text(Theme.default.padding(.regular).description)
            Text(Theme.default.padding(.regular.down(.half)).description)
            Text(Theme.default.padding(.small).description)

            RoundedRectangle(cornerRadius: .foundation(.radius(.small)))
				.foundation(.size(square: .regular))
                .overlay {
                    RoundedRectangle(cornerRadius: .foundation(.radius(.regular)))
                        .foundation(.padding(.init(value: Theme.default.padding(.regular)), .horizontal))
                        .foundation(.padding(.regular, .vertical))
						.foundation(.size(square: .regular))
                        .foundation(.foreground(.white))
                    RoundedRectangle(cornerRadius: .foundation(.radius(.regular)))
                        .foundation(.padding(.init(value: .foundation(.padding(.regular.up(.half)))), .horizontal))
                        .foundation(.padding(.regular, .vertical))
						.foundation(.size(square: .regular))
                        .foundation(.foreground(.gray.variant(.fill)))
                }
        }.padding()
    }
}
