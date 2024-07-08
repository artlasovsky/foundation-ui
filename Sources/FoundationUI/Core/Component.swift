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
        topLeadingRadius: FoundationUI.Theme.Radius.Token,
        bottomLeadingRadius: FoundationUI.Theme.Radius.Token,
        bottomTrailingRadius: FoundationUI.Theme.Radius.Token,
        topTrailingRadius: FoundationUI.Theme.Radius.Token
    ) -> UnevenRoundedRectangle {
        let radius = FoundationUI.theme.radius
        return UnevenRoundedRectangle(
            topLeadingRadius: radius(topLeadingRadius),
            bottomLeadingRadius: radius(bottomLeadingRadius),
            bottomTrailingRadius: radius(bottomTrailingRadius),
            topTrailingRadius: radius(topTrailingRadius),
            style: cornerRadiusStyle
        )
    }
    
    static func roundedRectangle(radius: CGFloat) -> RoundedRectangle {
        return RoundedRectangle(cornerRadius: radius, style: cornerRadiusStyle)
    }
    static func roundedRectangle(_ token: FoundationUI.Theme.Radius.Token) -> RoundedRectangle {
        self.roundedRectangle(radius: FoundationUI.theme.radius(token))
    }
    static func roundedSquare(_ token: FoundationUI.Theme.Radius.Token, size sizeToken: FoundationUI.Theme.Size.Token) -> some View {
        self.roundedRectangle(token)
            .foundation(.size(sizeToken))
    }
}
