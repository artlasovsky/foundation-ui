//
//  File.swift
//  
//
//  Created by Art Lasovsky on 19/07/2024.
//

import Foundation
import SwiftUI

public struct ConcentricRoundedRectangle: InsettableShape {
    public func inset(by amount: CGFloat) -> Self {
        var copy = self
        copy.padding = amount
        return copy
    }
    
    public var cornerRadius: CGFloat = 0
    public var padding: CGFloat = 0
    public var style: RoundedCornerStyle = .continuous

    public func setCornerRadius(_ cornerRadius: CGFloat?, style: RoundedCornerStyle = .continuous) -> some InsettableShape {
        guard let cornerRadius else { return self }
        var copy = self
        copy.cornerRadius = cornerRadius
        copy.style = style
        return copy
    }

    public func path(in rect: CGRect) -> Path {
        .init(
            roundedRect: .init(
                x: rect.minX + padding,
                y: rect.minY + padding,
                width: rect.width - padding * 2,
                height: rect.height - padding * 2
            ),
            cornerRadius: cornerRadius - padding,
            style: style
        )
    }
}

public extension Shape where Self == ConcentricRoundedRectangle {
	static func concentricShape(padding: Theme.Padding = 0) -> Self { .init(padding: padding.value) }
}

public extension Shape where Self == RoundedRectangle {
    static func roundedRectangle(_ cornerRadius: Theme.Radius) -> Self {
		.init(cornerRadius: cornerRadius.value)
    }
}

public extension RoundedRectangle {
    static func foundation(_ radius: Theme.Radius, style: RoundedCornerStyle = .continuous) -> FoundationRoundedRectangle {
		FoundationRoundedRectangle(cornerRadius: radius, style: style)
    }
	
	@available(macOS 13.0, iOS 16.0, *)
	static func foundation(
		topLeadingRadius: Theme.Radius = .zero,
		bottomLeadingRadius: Theme.Radius = .zero,
		bottomTrailingRadius: Theme.Radius = .zero,
		topTrailingRadius: Theme.Radius = .zero,
		style: RoundedCornerStyle = .continuous
	) -> FoundationUnevenRoundedRectangle {
		FoundationUnevenRoundedRectangle(
			topLeadingRadius: topLeadingRadius,
			bottomLeadingRadius: bottomLeadingRadius,
			bottomTrailingRadius: bottomTrailingRadius,
			topTrailingRadius: topTrailingRadius,
			style: style
		)
	}
}

public extension Shape {
    @available(macOS 13.0, iOS 16.0, *)
    static func roundedRectangle(
        topLeadingRadius: Theme.Radius,
        bottomLeadingRadius: Theme.Radius,
        bottomTrailingRadius: Theme.Radius,
        topTrailingRadius: Theme.Radius,
        style: RoundedCornerStyle = .continuous
    ) -> FoundationUnevenRoundedRectangle {
		FoundationUnevenRoundedRectangle(
			topLeadingRadius: topLeadingRadius,
			bottomLeadingRadius: bottomLeadingRadius,
			bottomTrailingRadius: bottomTrailingRadius,
			topTrailingRadius: topTrailingRadius,
            style: style
        )
    }
    
    static func roundedRectangle(_ token: Theme.Radius, style: RoundedCornerStyle = .continuous) -> FoundationRoundedRectangle {
		FoundationRoundedRectangle(cornerRadius: token, style: style)
    }
	
	@MainActor
	static func roundedSquare(_ token: Theme.Radius, size sizeToken: Theme.Size) -> some View {
        self.roundedRectangle(token)
            .foundation(.size(sizeToken))
    }
}

public struct FoundationRoundedRectangle: Shape, @unchecked Sendable {
	@Environment(\.self) private var environment
	let cornerRadius: Theme.Radius
	let style: RoundedCornerStyle
	
	public init(cornerRadius: Theme.Radius, style: RoundedCornerStyle = .continuous) {
		self.cornerRadius = cornerRadius
		self.style = style
	}
	
	public var animatableData: CGFloat {
		get { radius }
		set { interpolatedRadius = newValue }
	}
	
	public nonisolated func path(in rect: CGRect) -> Path {
		RoundedRectangle(
			cornerRadius: radius,
			style: style
		)
		.path(in: rect)
	}
	
	private var interpolatedRadius: CGFloat = 0
	
	private var radius: CGFloat {
		interpolatedRadius == 0 ? cornerRadius.resolve(in: environment) : interpolatedRadius
	}
}

@available(macOS 13.0, iOS 16.0, *)
public struct FoundationUnevenRoundedRectangle: Shape, @unchecked Sendable, Animatable {
	@Environment(\.self) private var environment
	let topLeadingRadius: Theme.Radius
	let bottomLeadingRadius: Theme.Radius
	let bottomTrailingRadius: Theme.Radius
	let topTrailingRadius: Theme.Radius
	var style: RoundedCornerStyle = .continuous
	
	public var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
		get {
			AnimatablePair(
				AnimatablePair(
					_topLeadingRadius,
					_topTrailingRadius
				),
				AnimatablePair(
					_bottomLeadingRadius,
					_bottomTrailingRadius
				)
			)
		}
		set {
			topLeadingInterpolatedRadius = newValue.first.first
			topTrailingInterpolatedRadius = newValue.first.second
			bottomLeadingInterpolatedRadius = newValue.second.first
			bottomTrailingInterpolatedRadius = newValue.second.second
		}
	}
	
	public var topLeadingInterpolatedRadius: CGFloat = 0
	public var topTrailingInterpolatedRadius: CGFloat = 0
	public var bottomLeadingInterpolatedRadius: CGFloat = 0
	public var bottomTrailingInterpolatedRadius: CGFloat = 0
	
	private var _topLeadingRadius: CGFloat {
		topLeadingInterpolatedRadius == 0 ? topLeadingRadius.resolve(in: environment) : topLeadingInterpolatedRadius
	}
	
	private var _topTrailingRadius: CGFloat {
		topTrailingInterpolatedRadius == 0 ? topTrailingRadius.resolve(in: environment) : topTrailingInterpolatedRadius
	}
	
	private var _bottomLeadingRadius: CGFloat {
		bottomLeadingInterpolatedRadius == 0 ? bottomLeadingRadius.resolve(in: environment) : bottomLeadingInterpolatedRadius
	}
	
	private var _bottomTrailingRadius: CGFloat {
		bottomTrailingInterpolatedRadius == 0 ? bottomTrailingRadius.resolve(in: environment) : bottomTrailingInterpolatedRadius
	}
	
	public nonisolated func path(in rect: CGRect) -> Path {
		UnevenRoundedRectangle(
			topLeadingRadius: _topLeadingRadius,
			bottomLeadingRadius: _bottomLeadingRadius,
			bottomTrailingRadius: _bottomTrailingRadius,
			topTrailingRadius: _topTrailingRadius,
			style: style
		)
		.path(in: rect)
	}
}
