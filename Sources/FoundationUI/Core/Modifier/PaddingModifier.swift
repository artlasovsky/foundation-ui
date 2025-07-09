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
		@Environment(\.self) private var environment
		let paddingToken: FoundationUI.Theme.Padding
        let edges: Edge.Set
        let concentricShapeStyle: ConcentricShapeStyle?
        
        public func body(content: Content) -> some View {
			content
				.padding(edges, padding)
                .transformEnvironment(\.dynamicConcentricRoundedRectangle) { concentricRect in
					guard let concentricShapeStyle else { return }
					
					var minCornerRadius: CGFloat = 0
					switch concentricShapeStyle {
					case .minimum(let radius):
						minCornerRadius = radius
					case .soft:
						minCornerRadius = 2
					case .sharp:
						minCornerRadius = 0
					}
					
					if let cornerRadius = concentricRect.cornerRadius.all {
						let adjustedCornerRadius = max(cornerRadius - padding, minCornerRadius)
						concentricRect = .init(cornerRadius: adjustedCornerRadius)
					} else {
						var unevenCornerRadius = concentricRect.cornerRadius
						if let cornerRadius = concentricRect.cornerRadius.topLeading {
							let adjustedCornerRadius = max(cornerRadius - padding, minCornerRadius)
							unevenCornerRadius.topLeading = adjustedCornerRadius
						}
						if let cornerRadius = concentricRect.cornerRadius.topTrailing {
							let adjustedCornerRadius = max(cornerRadius - padding, minCornerRadius)
							unevenCornerRadius.topTrailing = adjustedCornerRadius
						}
						if let cornerRadius = concentricRect.cornerRadius.bottomLeading {
							let adjustedCornerRadius = max(cornerRadius - padding, minCornerRadius)
							unevenCornerRadius.bottomLeading = adjustedCornerRadius
						}
						if let cornerRadius = concentricRect.cornerRadius.bottomTrailing {
							let adjustedCornerRadius = max(cornerRadius - padding, minCornerRadius)
							unevenCornerRadius.bottomTrailing = adjustedCornerRadius
						}
						concentricRect = .init(cornerRadius: unevenCornerRadius)
					}
                }
        }
		
		private var padding: CGFloat {
			paddingToken.resolve(in: environment)
		}
        
        public enum ConcentricShapeStyle {
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
		concentricShapeStyle: FoundationModifierLibrary.PaddingModifier.ConcentricShapeStyle? = .none
    ) -> FoundationModifier<FoundationModifierLibrary.PaddingModifier> {
        .init(
            .init(
                paddingToken: token,
                edges: edges,
				concentricShapeStyle: concentricShapeStyle
            )
        )
    }
}

struct PaddingModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
			Text(Theme.Padding.large.value.description)
			Text(Theme.Padding.regular.up(.half).value.description)
			Text(Theme.Padding.regular.value.description)
			Text(Theme.Padding.regular.down(.half).value.description)
			Text(Theme.Padding.small.value.description)

            RoundedRectangle(cornerRadius: .foundation(.radius(.small)))
				.foundation(.size(square: .regular))
                .overlay {
                    RoundedRectangle(cornerRadius: .foundation(.radius(.regular)))
						.foundation(.padding(.init(value: Theme.Padding.regular.value), .horizontal))
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
