//
//  File.swift
//  
//
//  Created by Art Lasovsky on 19/07/2024.
//

import Foundation
import SwiftUI

public struct DynamicRoundedRectangle: InsettableShape {
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

public extension Shape where Self == DynamicRoundedRectangle {
    static func dynamicRoundedRectangle(padding: CGFloat = 0) -> Self { .init(padding: padding) }
}

public extension Shape where Self == RoundedRectangle {
    static func roundedRectangle(_ cornerRadius: Theme.Radius) -> Self {
        .init(cornerRadius: Theme.default.radius(cornerRadius))
    }
}

public extension RoundedRectangle {
    static func foundation(_ radius: Theme.Radius, style: RoundedCornerStyle = .continuous) -> Self {
        .init(cornerRadius: .foundation(.radius(radius)), style: style)
    }
}

public extension Shape {
    @available(macOS 13.0, iOS 16.0, *)
    static func roundedRectangle(
        topLeadingRadius: CGFloat,
        bottomLeadingRadius: CGFloat,
        bottomTrailingRadius: CGFloat,
        topTrailingRadius: CGFloat,
        style: RoundedCornerStyle = .continuous
    ) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: topLeadingRadius,
            bottomLeadingRadius: bottomLeadingRadius,
            bottomTrailingRadius: bottomTrailingRadius,
            topTrailingRadius: topTrailingRadius,
            style: style
        )
    }
    
    @available(macOS 13.0, iOS 16.0, *)
    static func roundedRectangle(
        topLeadingRadius: Theme.Radius,
        bottomLeadingRadius: Theme.Radius,
        bottomTrailingRadius: Theme.Radius,
        topTrailingRadius: Theme.Radius,
        style: RoundedCornerStyle = .continuous
    ) -> UnevenRoundedRectangle {
        let radius = Theme.default.radius
        return UnevenRoundedRectangle(
            topLeadingRadius: radius(topLeadingRadius),
            bottomLeadingRadius: radius(bottomLeadingRadius),
            bottomTrailingRadius: radius(bottomTrailingRadius),
            topTrailingRadius: radius(topTrailingRadius),
            style: style
        )
    }
    
    static func roundedRectangle(_ token: Theme.Radius, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
		.init(cornerRadius: Theme.default.radius(token), style: style)
    }
	
	@MainActor
	static func roundedSquare(_ token: Theme.Radius, size sizeToken: Theme.Size) -> some View {
        self.roundedRectangle(token)
            .foundation(.size(sizeToken))
    }
}
