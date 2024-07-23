//
//  Component.swift
//
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI

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
        topLeadingRadius: Theme.Radius.Token,
        bottomLeadingRadius: Theme.Radius.Token,
        bottomTrailingRadius: Theme.Radius.Token,
        topTrailingRadius: Theme.Radius.Token,
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
    
    static func roundedRectangle(radius: CGFloat, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
        return RoundedRectangle(cornerRadius: radius, style: style)
    }
    static func roundedRectangle(_ token: Theme.Radius.Token, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
        self.roundedRectangle(radius: Theme.default.radius(token), style: style)
    }
    static func roundedSquare(_ token: Theme.Radius.Token, size sizeToken: Theme.Size.Token) -> some View {
        self.roundedRectangle(token)
            .foundation(.size(sizeToken))
    }
}
