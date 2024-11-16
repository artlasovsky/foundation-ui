//
//  Gradient.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
	public struct Gradient: FoundationVariableWithValue {
		public func callAsFunction(_ token: Self) -> DynamicGradient {
            token.value
        }
        
		public var value: DynamicGradient
        
        public init() {
			self.value = .init(colors: [], type: .linear(startPoint: .top, endPoint: .bottom))
        }
		
		public init(value: DynamicGradient) {
			self.value = value
		}
        
		public init(colors: [Theme.Color], type: DynamicGradient.GradientType) {
			self.value = .dynamicGradient(colors: colors, type: type)
        }
		
		public init(stops: [DynamicGradient.Stop], type: DynamicGradient.GradientType) {
			self.value = .dynamicGradient(stops: stops, type: type)
		}
    }
}

extension Theme.Gradient: ShapeStyle {
	public func resolve(in environment: EnvironmentValues) -> DynamicGradient {
		value
	}
}

public extension Theme.Gradient {
	private func modifyColors(_ modifier: (Theme.Color) -> Theme.Color) -> Self {
		.init(
			stops: self.value.stops.map { .init(color: modifier($0.color), location: $0.location) },
			type: self.value.type
		)
	}
	func brightness(_ brightness: CGFloat) -> Self {
		modifyColors { $0.brightness(brightness) }
	}
	
	func hue(_ hue: CGFloat) -> Self {
		modifyColors { $0.hue(hue) }
	}
	
	func saturation(_ saturation: CGFloat) -> Self {
		modifyColors { $0.saturation(saturation) }
	}
	
	func opacity(_ opacity: CGFloat) -> Self {
		modifyColors { $0.opacity(opacity) }
	}
	
	func colorScheme(_ colorScheme: FoundationColorScheme) -> Self {
		modifyColors { $0.colorScheme(colorScheme) }
	}
	
	func blendMode(_ blendMode: BlendMode) -> Self {
		modifyColors { $0.blendMode(blendMode) }
	}
	
	func blendMode(_ blendMode: DynamicColor.ExtendedBlendMode) -> Self {
		modifyColors { $0.blendMode(blendMode) }
	}
}

private extension Theme.Gradient {
	enum Preview {
		static let linear = Theme.Gradient(
			colors: [.blue, .from(color: .cyan)],
			type: .linear(startPoint: .top, endPoint: .bottom)
		)
		static let angular = Theme.Gradient(
			colors: [.orange, .red],
			type: .angular(center: .center, startAngle: .zero, endAngle: .degrees(90))
		)
		static let radial = Theme.Gradient(
			stops: [.init(color: .clear, location: 0), .init(color: .orange, location: 0.75)],
			type: .radial(center: .center, startRadius: 0, endRadius: .foundation(.size(.small)))
		)
	}
}

struct GradientPreview: PreviewProvider {
	struct Shape: View {
		var body: some View {
			Rectangle()
				.foundation(.size(.small.up(.half)))
				.foundation(.clip())
		}
	}
    struct GradientSample: View {
		let gradient: Theme.Gradient
        var body: some View {
			Shape()
				.foundation(.foregroundGradient(gradient))
        }
    }
    static var previews: some View {
        VStack {
			GradientSample(gradient: .Preview.linear)
			GradientSample(gradient: .Preview.angular)
			Shape()
				.foundation(.foreground(.clear))
				.foundation(.borderGradient(.Preview.angular, width: 3, in: .dynamicRoundedRectangle()))
				.foundation(.backgroundGradient(.Preview.radial.opacity(0.5)))
			Shape()
				.foregroundStyle(Theme.Gradient.Preview.linear)
        }
		.foundation(.cornerRadius(.regular))
        .padding()
    }
}
