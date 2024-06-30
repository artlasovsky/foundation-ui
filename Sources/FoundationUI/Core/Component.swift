//
//  Component.swift
//
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI

extension FoundationUI {
    public struct Component {}
    public struct Shape {}
}

public protocol FoundationUIComponentDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { get }
}

public extension FoundationUIComponentDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { .continuous }
}

// MARK: - Rounded Rectangle
extension FoundationUI.Shape: FoundationUIComponentDefaults {}

public extension FoundationUI.Shape {
    @available(macOS 13.0, iOS 16.0, *)
    static func roundedRectangle(
        topLeadingRadius: CGFloat,
        bottomLeadingRadius: CGFloat,
        bottomTrailingRadius: CGFloat,
        topTrailingRadius: CGFloat
    ) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: topLeadingRadius,
            bottomLeadingRadius: bottomLeadingRadius,
            bottomTrailingRadius: bottomTrailingRadius,
            topTrailingRadius: topTrailingRadius,
            style: cornerRadiusStyle
        )
    }
    
    @available(macOS 13.0, iOS 16.0, *)
    static func roundedRectangle(
        topLeadingRadius: FoundationUI.Theme.Radius.Scale,
        bottomLeadingRadius: FoundationUI.Theme.Radius.Scale,
        bottomTrailingRadius: FoundationUI.Theme.Radius.Scale,
        topTrailingRadius: FoundationUI.Theme.Radius.Scale
    ) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: .foundation.radius(topLeadingRadius),
            bottomLeadingRadius: .foundation.radius(bottomLeadingRadius),
            bottomTrailingRadius: .foundation.radius(bottomTrailingRadius),
            topTrailingRadius: .foundation.radius(topTrailingRadius),
            style: cornerRadiusStyle
        )
    }
    
    static func roundedRectangle(radius: CGFloat) -> RoundedRectangle {
        return RoundedRectangle(cornerRadius: radius, style: cornerRadiusStyle)
    }
    static func roundedRectangle(_ scale: FoundationUI.Theme.Radius.Scale) -> RoundedRectangle {
        self.roundedRectangle(radius: .foundation.radius(scale))
    }
    static func roundedSquare(_ scale: FoundationUI.Theme.Radius.Scale, size: FoundationUI.Theme.Size.Scale) -> some View {
        self.roundedRectangle(radius: .foundation.radius(scale))
            .foundation(.size(size))
    }
}
