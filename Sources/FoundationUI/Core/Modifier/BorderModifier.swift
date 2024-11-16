//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct BorderModifier<Style: ShapeStyle, S: InsettableShape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        @Environment(\.dynamicCornerRadiusStyle) private var dynamicCornerRadiusStyle
        let style: Style
        let shape: S
        let width: CGFloat
        let placement: BorderPlacement
        let level: BorderLevel
        
        public func body(content: Content) -> some View {
            switch level {
            case .above:
                content.overlay { border }
            case .below:
                content.background { border }
            }
        }
        
        private var border: some View {
            ShapeBuilder.resolveInsettableShape(
                shape,
                inset: padding,
                strokeWidth: width,
                dynamicCornerRadius: dynamicCornerRadius,
                dynamicCornerRadiusStyle: dynamicCornerRadiusStyle
            ).foregroundStyle(style)
        }
        
        private var padding: CGFloat {
            let offset: CGFloat = width / 2
            switch placement {
            case .inside: return offset
            case .outside: return -offset
            case .center: return 0
            }
        }
        
    }
    enum BorderPlacement {
        case inside
        case outside
        case center
    }
    enum BorderLevel {
        case above
        case below
    }
}

public extension FoundationModifier {
    static func border<S: Shape>(
        _ color: Theme.Color,
        width: CGFloat = 1,
        placement: FoundationModifierLibrary.BorderPlacement = .center,
        level: FoundationModifierLibrary.BorderLevel = .above,
        in shape: S = .dynamicRoundedRectangle()
    ) -> FoundationModifier<FoundationModifierLibrary.BorderModifier<Theme.Color, S>> {
        .init(.init(style: color, shape: shape, width: width, placement: placement, level: level))
    }
	
    static func borderStyle<Style: ShapeStyle, S: Shape>(
        _ style: Style,
        width: CGFloat = 1,
        placement: FoundationModifierLibrary.BorderPlacement = .center,
        level: FoundationModifierLibrary.BorderLevel = .above,
        in shape: S = .dynamicRoundedRectangle()
    ) -> FoundationModifier<FoundationModifierLibrary.BorderModifier<Style, S>> {
        .init(.init(style: style, shape: shape, width: width, placement: placement, level: level))
    }
	
	static func borderColor<S: Shape>(
		_ color: SwiftUI.Color,
		width: CGFloat = 1,
		placement: FoundationModifierLibrary.BorderPlacement = .center,
		level: FoundationModifierLibrary.BorderLevel = .above,
		in shape: S = .dynamicRoundedRectangle()
	) -> FoundationModifier<FoundationModifierLibrary.BorderModifier<SwiftUI.Color, S>> {
		.init(.init(style: color, shape: shape, width: width, placement: placement, level: level))
	}
	
	static func borderGradient<S: Shape>(
		_ gradient: Theme.Gradient,
		width: CGFloat = 1,
		placement: FoundationModifierLibrary.BorderPlacement = .center,
		level: FoundationModifierLibrary.BorderLevel = .above,
		in shape: S = .dynamicRoundedRectangle()
	) -> FoundationModifier<FoundationModifierLibrary.BorderModifier<Theme.Gradient, S>> {
		.init(.init(style: gradient, shape: shape, width: width, placement: placement, level: level))
	}
}

#if DEBUG
struct BorderModifier_Preview: PreviewProvider {
    struct Test: View {
        @Environment(\.dynamicTint) private var dynamicTint
        let tint: DynamicColor? = nil
        
        var color: DynamicColor {
            tint ?? dynamicTint.color
        }
        
        var body: some View {
            ZStack {
                Text("Border")
					.foundation(.size(square: .regular))
                    .foundation(.border(.from(color: .orange), width: 4, placement: .center))
                    .foundation(.border(.from(color: .cyan.opacity(0.5)), width: 4, placement: .inside))
                    .foundation(.border(.from(color: .blue.opacity(0.5)), width: 4, placement: .outside))
                    .foundation(.background(.red))
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
            }
        }
    }
    static var previews: some View {
        ZStack {
            Test()
            Test().foundation(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
#endif
