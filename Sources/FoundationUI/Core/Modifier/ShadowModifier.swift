//
//  ShadowModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct ShadowModifier<Style: ShapeStyle, S: InsettableShape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        @Environment(\.dynamicCornerRadiusStyle) private var dynamicCornerRadiusStyle
		@Environment(\.colorScheme) private var colorScheme
		@Environment(\.colorSchemeContrast) private var colorSchemeContrast
		@Environment(\.self) private var environment
		let style: (_ env: EnvironmentValues) -> Style
        let shape: S
		let scope: (_ env: EnvironmentValues) -> Scope
		
		enum Scope {
			case content(radius: CGFloat, x: CGFloat, y: CGFloat)
			case background(radius: CGFloat, spread: CGFloat, x: CGFloat, y: CGFloat)
		}
		
		private var color: Color {
			let style = style(environment)
			if let color = (style as? Color) {
				return color
			}
			if let color = (style as? DynamicColor)?.resolveColor(in: .init(colorScheme: colorScheme, colorSchemeContrast: colorSchemeContrast)) {
				return color
			}
			if let color = (style as? Theme.Color)?.resolveColor(in: .init(colorScheme: colorScheme, colorSchemeContrast: colorSchemeContrast)) {
				return color
			}
			return .red
		}
        
        public func body(content: Content) -> some View {
			switch scope(environment) {
			case .content(let radius, let x, let y):
				content.shadow(
					color: color,
					radius: radius,
					x: x,
					y: y
				)
			case .background(let radius, let spread, let x, let y):
				content.background {
					shapeView(spread: spread)
						.foregroundStyle(style(environment))
						.blur(radius: radius)
						.offset(x: x, y: y)
				}
			}
        }
        
		private func shapeView(spread: CGFloat) -> some View {
            ShapeBuilder.resolveInsettableShape(
                shape,
                inset: spread * -1,
                strokeWidth: nil,
                dynamicCornerRadius: dynamicCornerRadius,
                dynamicCornerRadiusStyle: dynamicCornerRadiusStyle
            )
        }
    }
}

public extension FoundationModifier {
	/// Applies shadow token configuration using native SwiftUI's `.shadow(color:radius:x:y:)` modifier
	/// > Important: It will ignore `spread` parameter of the `Theme.Shadow` token
	static func contentShadow(_ token: Theme.Shadow) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Theme.Color, Rectangle>> {
		.init(.init(
			style: { env in token.resolve(in: env).color },
			shape: Rectangle(),
			scope: { env in
				let configuration = token.resolve(in: env)
				return .content(radius: configuration.radius, x: configuration.x, y: configuration.y)
			}
		))
	}
	
    static func backgroundShadow<S: Shape>(
        _ token: Theme.Shadow,
        in shape: S = .concentricShape()
    ) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Theme.Color, S>> {
        .init(.init(
			style: { env in token.resolve(in: env).color },
            shape: shape,
			scope: { env in
				let configuration = token.resolve(in: env)
				return .background(radius: configuration.radius, spread: configuration.spread, x: configuration.x, y: configuration.y)
			}
        ))
    }
	
	static func backgroundShadowColor<S: Shape>(
		_ color: Theme.Color,
		radius: CGFloat,
		spread: CGFloat = 0,
		x: CGFloat = 0,
		y: CGFloat = 0,
		in shape: S = .concentricShape()
	) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Theme.Color, S>> {
		.init(.init(
			style: { _ in color },
			shape: shape,
			scope: { _ in .background(radius: radius, spread: spread, x: x, y: y) }
		))
	}
	
	static func backgroundShadowStyle<Style: ShapeStyle, S: Shape>(
		_ style: Style,
		radius: CGFloat,
		spread: CGFloat = 0,
		x: CGFloat = 0,
		y: CGFloat = 0,
		in shape: S = .concentricShape()
	) -> FoundationModifier<FoundationModifierLibrary.ShadowModifier<Style, S>> {
		.init(.init(
			style: { env in style },
			shape: shape,
			scope: { env in .background(radius: radius, spread: spread, x: x, y: y) }
		))
	}
}

struct ShadowModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Shadow")
				.foundation(.size(square: .regular))
                .foundation(.background(.dynamic(.background), in: .concentricShape()))
                .foundation(
                    .backgroundShadowColor(
                        .dynamic(.background).colorScheme(.dark),
                        radius: 2.5,
                        spread: -1.5,
                        y: 2,
                        in: .concentricShape()
                    )
                )
                .foundation(.cornerRadius(.regular))
        }
        .foundation(.padding(.regular))
        .foundation(.background(.dynamic(.background)))
        ._colorScheme(.light)
    }
}
