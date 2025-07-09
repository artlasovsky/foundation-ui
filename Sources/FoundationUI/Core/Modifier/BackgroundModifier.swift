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
		@Environment(\.dynamicConcentricRoundedRectangle) private var dynamicConcentricRoundedRectangle
        let style: Style
        let shape: S
		
		@ShapeBuilder
		var resolvedShape: some Shape {
			if shape is DynamicConcentricRoundedRectangle {
				dynamicConcentricRoundedRectangle
			} else {
				shape
			}
		}
        
        public func body(content: Content) -> some View {
            content
                .background { resolvedShape.foregroundStyle(style) }
        }
    }
}


public extension FoundationModifier {
    static func background<S: Shape, VM: ViewModifier>(
        _ color: Theme.Color,
        in shape: S = .dynamicConcentricRoundedRectangle(),
        modifier: VM = EmptyModifier()
    ) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Theme.Color, S>> {
        .init(.init(style: color, shape: shape))
    }
    
    static func backgroundStyle<Style: ShapeStyle, S: Shape, VM: ViewModifier>(
        _ style: Style,
        in shape: S = .dynamicConcentricRoundedRectangle(),
        modifier: VM = EmptyModifier()
    ) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Style, S>> {
        .init(.init(style: style, shape: shape))
    }
    
    static func backgroundColor<S: Shape, VM: ViewModifier>(
        _ color: Color,
        in shape: S = .dynamicConcentricRoundedRectangle(),
        modifier: VM = EmptyModifier()
    ) -> FoundationModifier<FoundationModifierLibrary.BackgroundModifier<Color, S>> {
        .init(.init(style: color, shape: shape))
    }
	
	static func backgroundGradient<S: Shape, VM: ViewModifier>(
		_ gradient: Theme.Gradient,
		in shape: S = .dynamicConcentricRoundedRectangle(),
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
				.foundation(.background(.primary.variant(.background)))
                .foundation(.backgroundShadow(.regular))
				.foundation(.concentricRoundedRectangle(.regular))
            
            VStack {
				Text("Concentric")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent)))
					.foundation(.padding(.small.up(.half), concentricShapeStyle: .sharp))
					.foundation(.background(.primary))
					.foundation(.border(.red))
					.foundation(.concentricRoundedRectangle(.xLarge))
				Text("Concentric Force")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent), in: .rect))
					.foundation(.padding(.small.up(.half)))
					.foundation(.background(.primary, in: .roundedRectangle(.xLarge)))
					.foundation(.border(.red, in: .roundedRectangle(.xLarge)))
                Text("Concentric Env")
                    .foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent)))
					.foundation(.padding(.small.up(.half), concentricShapeStyle: .sharp))
					.foundation(.background(.primary))
					.foundation(.border(.red))
				Text("Concentric Uneven")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent)))
					.foundation(.padding(.small.up(.half), concentricShapeStyle: .sharp))
					.foundation(.background(.primary))
					.foundation(.border(.red))
					.foundation(.concentricRoundedRectangle(topLeading: .xxLarge, bottomTrailing: .xLarge))
				Text("Concentric Manual")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent), in: .roundedRectangle(.regular, padding: .small.up(.half))))
					.foundation(.background(.primary, in: .roundedRectangle(.regular)))
					.foundation(.border(.red))
				Text("Concentric M Out")
					.foundation(.padding(.large))
					.foundation(.background(.dynamic(.fillProminent), in: .roundedRectangle(.regular)))
					.foundation(.background(.primary, in: .roundedRectangle(.regular, padding: .small.up(.half).negative())))
					.foundation(.border(.red, in: .roundedRectangle(.regular)))
            }
			.foundation(.concentricRoundedRectangle(.large))
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
		.frame(height: 600)
    }
}
