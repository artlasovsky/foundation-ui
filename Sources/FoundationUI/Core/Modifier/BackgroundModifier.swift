//
//  BackgroundModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct BackgroundModifier<Style: ShapeStyle, S: Shape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        @Environment(\.dynamicCornerRadiusStyle) private var dynamicCornerRadiusStyle
        let style: Style
        let shape: S
        
        public func body(content: Content) -> some View {
            content
                .background {
                    ShapeBuilder.resolveShape(
                        shape,
                        dynamicCornerRadius: dynamicCornerRadius,
                        dynamicCornerRadiusStyle: dynamicCornerRadiusStyle
                    )
                    .foregroundStyle(style)
                }
        }
    }
}


public extension FoundationModifier {
    static func background<S: Shape, VM: ViewModifier>(
        _ color: Theme.Color,
        in shape: S = .concentricShape(),
        modifier: VM = EmptyModifier()
    ) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Theme.Color, S>> {
        .init(.init(style: color, shape: shape))
    }
    
    static func backgroundStyle<Style: ShapeStyle, S: Shape, VM: ViewModifier>(
        _ style: Style,
        in shape: S = .concentricShape(),
        modifier: VM = EmptyModifier()
    ) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Style, S>> {
        .init(.init(style: style, shape: shape))
    }
    
    static func backgroundColor<S: Shape, VM: ViewModifier>(
        _ color: Color,
        in shape: S = .concentricShape(),
        modifier: VM = EmptyModifier()
    ) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Color, S>> {
        .init(.init(style: color, shape: shape))
    }
	
	static func backgroundGradient<S: Shape, VM: ViewModifier>(
		_ gradient: Theme.Gradient,
		in shape: S = .concentricShape(),
		modifier: VM = EmptyModifier()
	) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Theme.Gradient, S>> {
		.init(.init(style: gradient, shape: shape))
	}
}

struct BackgroundModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Basic")
                .foundation(.padding(.regular))
                .foundation(.background(.primary.variant(.fillProminent)))
            Text("Tinted")
                .foundation(.padding(.regular))
                .foundation(.background(.dynamic(.fillProminent)))
            Text("Shadow")
                .foundation(.padding(.regular))
                .foundation(.background(.primary.variant(.background), in: .roundedRectangle(.regular)))
                .foundation(.backgroundShadow(.regular, in: .roundedRectangle(.regular)))
            //
            VStack {
                Text("Concentric")
                    .foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent), in: .concentricShape()))
					.foundation(.padding(.small.up(.half), concentricShapeStyle: .sharp))
					.foundation(.background(.primary, in: .concentricShape()))
					.foundation(.border(.red))
				Text("Concentric")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent), in: .concentricShape(padding: .small.up(.half))))
					.foundation(.background(.primary, in: .concentricShape()))
					.foundation(.border(.red))
				Text("Concentric")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent), in: .concentricShape()))
					.foundation(.background(.primary, in: .concentricShape(padding: .small.up(.half).negative())))
					.foundation(.border(.red))
            }
            .foundation(.cornerRadius(.xLarge))
            Text("Adj")
                .border(.blue.opacity(0.5))
                .foundation(.padding(.regular))
                .border(.green.opacity(0.5))
                .foundation(.background(.dynamic(.fillProminent))
//                    .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
//                    .shadow(.regular)
//                    .cornerRadius(.regular)
                )
        }
        .foundation(.tint(.red))
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
