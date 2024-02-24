//
//  Component.swift
//
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI

extension TrussUI {
    public struct Component {}
}

public protocol TrussUIComponentDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { get }
}

public extension TrussUIComponentDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { .continuous }
}

// MARK: - Rounded Rectangle
extension TrussUI.Component: TrussUIComponentDefaults {}

public extension TrussUI.Component {    
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
        topLeadingRadius: TrussUI.Variable.Radius,
        bottomLeadingRadius: TrussUI.Variable.Radius,
        bottomTrailingRadius: TrussUI.Variable.Radius,
        topTrailingRadius: TrussUI.Variable.Radius
    ) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: .truss.radius(topLeadingRadius),
            bottomLeadingRadius: .truss.radius(bottomLeadingRadius),
            bottomTrailingRadius: .truss.radius(bottomTrailingRadius),
            topTrailingRadius: .truss.radius(topTrailingRadius),
            style: cornerRadiusStyle
        )
    }
    
    static func roundedRectangle(_ radius: CGFloat) -> RoundedRectangle {
        return RoundedRectangle(cornerRadius: radius, style: cornerRadiusStyle)
    }
    static func roundedRectangle(_ variable: TrussUI.Variable.Radius) -> RoundedRectangle {
        self.roundedRectangle(.truss.radius(variable))
    }
}
