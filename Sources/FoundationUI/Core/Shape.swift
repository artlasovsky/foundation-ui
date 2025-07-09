//
//  Shape.swift
//  
//
//  Created by Art Lasovsky on 19/07/2024.
//

import Foundation
import SwiftUI

public struct FoundationRoundedRectangle: InsettableShape {
    public func inset(by amount: CGFloat) -> Self {
        var copy = self
        copy.padding = amount
        return copy
    }
    
	private(set) var cornerRadius: CornerRadius<CGFloat>
    private(set) var padding: CGFloat
    private(set) var style: RoundedCornerStyle
	
	public init(
		cornerRadius: CornerRadius<CGFloat>,
		padding: CGFloat = 0,
		style: RoundedCornerStyle = .continuous
	) {
		self.cornerRadius = cornerRadius
		self.padding = padding
		self.style = style
	}
	
	public init(
		cornerRadius: CGFloat? = nil,
		padding: CGFloat = 0,
		style: RoundedCornerStyle = .continuous
	) {
		self.cornerRadius = .init(cornerRadius)
		self.padding = padding
		self.style = style
	}
	
	public init(
		topLeadingRadius: CGFloat? = nil,
		bottomLeadingRadius: CGFloat? = nil,
		bottomTrailingRadius: CGFloat? = nil,
		topTrailingRadius: CGFloat? = nil,
		padding: CGFloat = 0,
		style: RoundedCornerStyle = .continuous
	) {
		self.cornerRadius = .init(
			topLeading: topLeadingRadius,
			topTrailing: topTrailingRadius,
			bottomLeading: bottomLeadingRadius,
			bottomTrailing: bottomTrailingRadius
		)
		self.padding = padding
		self.style = style
	}

    public func setCornerRadius(_ cornerRadius: CornerRadius<CGFloat>?, style: RoundedCornerStyle = .continuous) -> Self {
        var copy = self
		if let cornerRadius {
			if #available(macOS 13.0, iOS 16.0, *), !copy.cornerRadius.isEven {
				if copy.cornerRadius.topLeading == nil {
					copy.cornerRadius.topLeading = cornerRadius.topLeading
				}
				if copy.cornerRadius.topTrailing == nil {
					copy.cornerRadius.topTrailing = cornerRadius.topTrailing
				}
				if copy.cornerRadius.bottomLeading == nil {
					copy.cornerRadius.bottomLeading = cornerRadius.bottomLeading
				}
				if copy.cornerRadius.bottomTrailing == nil {
					copy.cornerRadius.bottomTrailing = cornerRadius.bottomTrailing
				}
			} else {
				if copy.cornerRadius.all == nil {
					copy.cornerRadius = .init(cornerRadius.all)
				}
			}
		}
        copy.style = style
        return copy
    }

	public func path(in rect: CGRect) -> Path {
		let rect = CGRect(
			x: rect.minX + padding,
			y: rect.minY + padding,
			width: rect.width - padding * 2,
			height: rect.height - padding * 2
		)
		
		if #available(macOS 13.0, iOS 16.0, *), !cornerRadius.isEven {
			return UnevenRoundedRectangle(
				topLeadingRadius: cornerRadius.topLeading ?? cornerRadius.all ?? 0,
				bottomLeadingRadius: cornerRadius.bottomLeading ?? cornerRadius.all ?? 0,
				bottomTrailingRadius: cornerRadius.bottomTrailing ?? cornerRadius.all ?? 0,
				topTrailingRadius: cornerRadius.topTrailing ?? cornerRadius.all ?? 0,
				style: style
			)
			.path(in: rect)
		} else {
			return RoundedRectangle(cornerRadius: (cornerRadius.all ?? padding) - padding, style: style)
				.path(in: rect)
		}
	}
}

extension FoundationRoundedRectangle {
	public struct CornerRadius<V: Hashable & Sendable>: Sendable {
		public var all: V?
		public var topLeading: V?
		public var topTrailing: V?
		public var bottomLeading: V?
		public var bottomTrailing: V?
		
		init(topLeading: V?, topTrailing: V?, bottomLeading: V?, bottomTrailing: V?) {
			self.all = nil
			self.topLeading = topLeading
			self.topTrailing = topTrailing
			self.bottomLeading = bottomLeading
			self.bottomTrailing = bottomTrailing
		}
		
		init(_ value: V?) {
			self.all = value
		}
		
		public var isEven: Bool {
			[topLeading, topTrailing, bottomLeading, bottomTrailing].allSatisfy({ $0 == nil })
		}
	}
}

public struct DynamicConcentricRoundedRectangle: InsettableShape {
	public nonisolated func inset(by amount: CGFloat) -> some InsettableShape {
		Rectangle()
	}
	public nonisolated func path(in rect: CGRect) -> Path {
		Rectangle().path(in: rect)
	}
}

public extension Shape where Self == DynamicConcentricRoundedRectangle {
	/// Use Rounded Rectangle shape from environment
	static func dynamicConcentricRoundedRectangle() -> Self {
		.init()
	}
}

public extension Shape where Self == FoundationRoundedRectangle {
	static func roundedRectangle(
		_ cornerRadius: Theme.Radius? = nil,
		padding: Theme.Padding = 0
	) -> Self {
		.init(
			cornerRadius: cornerRadius?.value,
			padding: padding.value
		)
	}
	
	static func roundedRectangle(
		topLeading: Theme.Radius? = nil,
		topTrailing: Theme.Radius? = nil,
		bottomLeading: Theme.Radius? = nil,
		bottomTrailing: Theme.Radius? = nil,
		padding: Theme.Padding = 0
	) -> Self {
		.init(
			topLeadingRadius: topLeading?.value,
			bottomLeadingRadius: bottomLeading?.value,
			bottomTrailingRadius: bottomTrailing?.value,
			topTrailingRadius: topTrailing?.value,
			padding: padding.value
		)
	}
}

@MainActor
public extension Shape where Self == RoundedRectangle {
    static func roundedRectangle(_ cornerRadius: Theme.Radius) -> Self {
		.foundation(cornerRadius)
    }
}

@MainActor
@available(macOS 13.0, iOS 16.0, *)
public extension Shape where Self == UnevenRoundedRectangle {
	static func roundedRectangle(topLeading: Theme.Radius, topTrailing: Theme.Radius, bottomLeading: Theme.Radius, bottomTrailing: Theme.Radius, style: RoundedCornerStyle = .continuous) -> Self {
		.init(
			topLeadingRadius: topLeading.value,
			bottomLeadingRadius: bottomLeading.value,
			bottomTrailingRadius: bottomTrailing.value,
			topTrailingRadius: topTrailing.value,
			style: style
		)
	}
}

@MainActor
public extension RoundedRectangle {
	static func foundation(
		_ radius: Theme.Radius,
		style: RoundedCornerStyle = .continuous
	) -> RoundedRectangle {
		.init(cornerRadius: radius.value, style: style)
    }
	
	@available(macOS 13.0, iOS 16.0, *)
	static func foundation(
		topLeading: Theme.Radius = .zero,
		bottomLeading: Theme.Radius = .zero,
		bottomTrailing: Theme.Radius = .zero,
		topTrailing: Theme.Radius = .zero,
		style: RoundedCornerStyle = .continuous
	) -> UnevenRoundedRectangle {
		.init(
			topLeadingRadius: topLeading.value,
			bottomLeadingRadius: bottomLeading.value,
			bottomTrailingRadius: bottomTrailing.value,
			topTrailingRadius: topTrailing.value,
			style: style
		)
	}
}
