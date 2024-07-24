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

    public func setCornerRadius(_ cornerRadius: CGFloat?) -> some InsettableShape {
        guard let cornerRadius else { return self }
        var copy = self
        copy.cornerRadius = cornerRadius
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
