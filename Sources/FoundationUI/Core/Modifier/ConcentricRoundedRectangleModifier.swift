//
//  ConcentricRoundedRectangleModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct ConcentricRoundedRectangleModifier: ViewModifier {
		@Environment(\.self) private var environment
		let cornerRadius: FoundationRoundedRectangle.CornerRadius<Theme.Radius>?
		let style: RoundedCornerStyle
		
		public init(cornerRadius: FoundationRoundedRectangle.CornerRadius<Theme.Radius>?, style: RoundedCornerStyle = .continuous) {
			self.cornerRadius = cornerRadius
			self.style = style
		}
		
		private var resolvedCornerRadius: FoundationRoundedRectangle.CornerRadius<CGFloat>? {
			guard let cornerRadius else { return nil }
			var radius: FoundationRoundedRectangle.CornerRadius<CGFloat> = .init(nil)
			radius.all = cornerRadius.all?.resolve(in: environment)
			radius.topLeading = cornerRadius.topLeading?.resolve(in: environment)
			radius.topTrailing = cornerRadius.topTrailing?.resolve(in: environment)
			radius.bottomLeading = cornerRadius.bottomLeading?.resolve(in: environment)
			radius.bottomTrailing = cornerRadius.bottomTrailing?.resolve(in: environment)
			
			return radius
		}
		
		private var shape: FoundationRoundedRectangle {
			guard let resolvedCornerRadius else { return .init(cornerRadius: 0) }
			return .init(cornerRadius: resolvedCornerRadius)
		}
        
        public func body(content: Content) -> some View {
            content
                .environment(\.dynamicConcentricRoundedRectangle, shape)
        }
    }
}

// TODO: Consider clearer or more descriptive modifier name
public extension FoundationModifier {
	/// Sets the Dynamic Rounded Rectangle shape for the environment.
	/// This shape serves as the default for nested modifiers such as background, shadow, and border.
	/// When using the `.foundation(.padding(_:concentricShapeStyle:))` modifier,
	/// it automatically adjusts the radius of nested Dynamic Rounded Rectangle shapes.
	static func concentricRoundedRectangle(
		topLeading: Theme.Radius? = nil,
		topTrailing: Theme.Radius? = nil,
		bottomLeading: Theme.Radius? = nil,
		bottomTrailing: Theme.Radius? = nil,
		style: RoundedCornerStyle = .continuous
	) -> FoundationModifier<FoundationModifierLibrary.ConcentricRoundedRectangleModifier> {
		.init(
			.init(
				cornerRadius: .init(
					topLeading: topLeading,
					topTrailing: topTrailing,
					bottomLeading: bottomLeading,
					bottomTrailing: bottomTrailing
				),
				style: style
			)
		)
	}
	
	/// Sets the Dynamic Rounded Rectangle shape for the environment.
	/// This shape serves as the default for nested modifiers such as background, shadow, and border.
	/// When using the `.foundation(.padding(_:concentricShapeStyle:))` modifier,
	/// it automatically adjusts the radius of nested Dynamic Rounded Rectangle shapes.
	static func concentricRoundedRectangle(_ cornerRadius: Theme.Radius?, style: RoundedCornerStyle = .continuous) -> FoundationModifier<FoundationModifierLibrary.ConcentricRoundedRectangleModifier> {
		.init(.init(cornerRadius: .init(cornerRadius), style: style))
	}
}

// MARK: - EnvironmentValues

private struct DynamicConcentricRoundedRectangleKey: EnvironmentKey {
    static let defaultValue: FoundationRoundedRectangle = .init(cornerRadius: 0)
}

internal extension EnvironmentValues {	
	var dynamicConcentricRoundedRectangle: FoundationRoundedRectangle {
		get { self[DynamicConcentricRoundedRectangleKey.self] }
		set { self[DynamicConcentricRoundedRectangleKey.self] = newValue }
	}
}

// MARK: - Preview

struct CornerRadiusModifiefPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Dynamic Radius")
                .frame(maxWidth: .infinity)
                .foundation(.padding(.regular, .vertical))
                // Use Dynamic Corner Radius
                .foundation(.background(.dynamic(.fill)))
				.foundation(.padding(.small, concentricShapeStyle: .soft))
            Spacer()
            Text("Custom Radius")
                .frame(maxWidth: .infinity)
                .foundation(.padding(.regular, .vertical))
                // Set Corner Radius manually
                .foundation(
                    .background(.dynamic(.fill), in: .rect(cornerRadius: 30))
                )
                .foundation(.padding(.small))
        }
        .frame(width: 200, height: 150)
        .foundation(.background(.dynamic(.backgroundSubtle)))
        .foundation(.concentricRoundedRectangle(.xLarge))
        .padding()
    }
}
