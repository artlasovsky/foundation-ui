//
//  CustomButtonStyle.swift
//  
//
//  Created by Art Lasovsky on 23/11/2024.
//

import FoundationUI

private extension Theme.Size {
	static let button = Theme.Size(width: 110, height: 30)
}

struct CustomButtonStyle: ButtonStyle {
	private static let topEdgeHighlightWidth: CGFloat = 0.75
	
	// ...
	
	func makeBody(configuration: Configuration) -> some View {
			configuration.label
				.foundation(.size(.button))
				.foundation(.foreground(.foreground(variant)))
				.foundation(.borderGradient(.topEdgeHighlight, width: Self.topEdgeHighlightWidth, placement: .inside))
				.foundation(.backgroundGradient(.backgroundHighlight), bypass: !isShowingBackgroundHighlight)
				.foundation(.background(.background(variant, isPressed: isPressed)))
				.foundation(.concentricRoundedRectangle(.small))
	}
	
	/// Conditionally showing background highlight
	private var isShowingBackgroundHighlight: Bool {
		switch variant {
		case .prominent: true
		case .regular: false
		}
	}
}

private extension Theme.Color {
	static func background(_ variant: CustomButtonStyleVariant, isPressed: Bool) -> Theme.Color {
		let color: Theme.Color
		switch variant {
		case .prominent:
			color = .from(color: .accentColor)
		case .regular:
			color = .init(
				light: .init(grayscale: 0.8),
				dark: .init(grayscale: 0.6)
			)
		}
		return color.brightness(isPressed ? 0.9 : 1)
	}

	static func foreground(_ variant: CustomButtonStyleVariant) -> Theme.Color {
		switch variant {
		case .prominent:
			.white
		case .regular:
			.init(
				light: .init(grayscale: 0.25),
				dark: .init(grayscale: 0.98)
			)
		}
	}
}

private extension Theme.Gradient {
	static let backgroundHighlight = Theme.Gradient(
		colors: [
			.white,
			.white.opacity(0.5),
			.black.opacity(0.1)
		],
		type: .linear(startPoint: .top, endPoint: .bottom)
	).opacity(0.2)

	static let topEdgeHighlight = Theme.Gradient(
		stops: [
			.init(color: topEdgeHighlightColor, location: 0),
			.init(color: .clear, location: 0.15)
		],
		type: .linear(startPoint: .top, endPoint: .bottom)
	)
	
	private static let topEdgeHighlightColor = Theme.Color(
		light: .init(grayscale: 0, opacity: 0),
		dark: .init(grayscale: 1, opacity: 0.5)
	)
	.blendMode(.vibrant)
}

struct CustomButtonStyle: ButtonStyle {
	var variant: CustomButtonStyleVariant = .regular

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
	}
}

enum CustomButtonStyleVariant {
	case prominent
	case regular
}

// MARK: - Preview

struct CustomButtonStylePreview: View {
	var body: some View {
		VStack {
			buttonGroup(.light)
			buttonGroup(.dark)
		}
		.padding()
		.background(.background)
	}

	func buttonGroup(_ colorScheme: ColorScheme) -> some View {
		VStack {
			Text(colorScheme == .light ? "Light" : "Dark")
				.monospaced()
				.font(.caption)
			HStack {
				Button("Cancel") {}
					.buttonStyle(CustomButtonStyle())
				Button("Action") {}
					.buttonStyle(CustomButtonStyle(variant: .prominent))
			}
			.padding(18)
			.background(.windowBackground, in: .rect(cornerRadius: 18))
			.environment(\.colorScheme, colorScheme)
		}
	}
}

#Preview {
	CustomButtonStylePreview()
}
