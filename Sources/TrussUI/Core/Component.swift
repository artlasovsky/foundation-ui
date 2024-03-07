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
    public struct Shape {}
}

public protocol TrussUIComponentDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { get }
}

public extension TrussUIComponentDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { .continuous }
}

// MARK: - Rounded Rectangle
extension TrussUI.Shape: TrussUIComponentDefaults {}

public extension TrussUI.Shape {
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
    
    static func roundedRectangle(radius: CGFloat) -> RoundedRectangle {
        return RoundedRectangle(cornerRadius: radius, style: cornerRadiusStyle)
    }
    static func roundedRectangle(_ variable: TrussUI.Variable.Radius) -> RoundedRectangle {
        self.roundedRectangle(radius: .truss.radius(variable))
    }
    static func roundedSquare(_ variable: TrussUI.Variable.Radius, size: TrussUI.Variable.Size) -> some View {
        self.roundedRectangle(radius: .truss.radius(variable))
            .truss(.size(size))
    }
}
