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
}

// MARK: - Rounded Rectangle
extension FoundationUI.Component: FoundationUIDefaultCornerRadiusStyle {}

public extension FoundationUI.Component {
    typealias RadiusKeyPath = FoundationUI.Scale.Radius.KeyPath
    
    @available(macOS 13.0, *)
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
    
    @available(macOS 13.0, *)
    static func roundedRectangle(
        topLeadingRadius: RadiusKeyPath,
        bottomLeadingRadius: RadiusKeyPath,
        bottomTrailingRadius: RadiusKeyPath,
        topTrailingRadius: RadiusKeyPath
    ) -> UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: .theme.radius[keyPath: topLeadingRadius],
            bottomLeadingRadius: .theme.radius[keyPath: bottomLeadingRadius],
            bottomTrailingRadius: .theme.radius[keyPath: bottomTrailingRadius],
            topTrailingRadius: .theme.radius[keyPath: topTrailingRadius],
            style: cornerRadiusStyle
        )
    }
    
    static func roundedRectangle(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: cornerRadiusStyle)
    }
    static func roundedRectangle(_ radius: RadiusKeyPath) -> RoundedRectangle {
        self.roundedRectangle(.theme.radius[keyPath: radius])
    }
    struct RoundedRect: Scalable {
        private static func getRoundedRect(_ cornerRadius: CGFloat) -> RoundedRectangle {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        }
        
        public let xxSmall = getRoundedRect(.theme.radius.xxSmall)
        public let xSmall = getRoundedRect(.theme.radius.xSmall)
        public let small = getRoundedRect(.theme.radius.small)
        public let regular = getRoundedRect(.theme.radius.regular)
        public let large = getRoundedRect(.theme.radius.large)
        public let xLarge = getRoundedRect(.theme.radius.xLarge)
        public let xxLarge = getRoundedRect(.theme.radius.xxLarge)
    }
}

public extension RoundedRectangle {
    static func foundation(_ radius: CGFloat) -> Self { FoundationUI.Component.roundedRectangle(radius) }
    static func foundation(_ radius: KeyPath<FoundationUI.Scale.Radius, CGFloat>) -> Self { FoundationUI.Component.roundedRectangle(radius) }
    static func theme(_ radius: CGFloat) -> Self { foundation(radius) }
    static func theme(_ radius: KeyPath<FoundationUI.Scale.Radius, CGFloat>) -> Self { foundation(radius) }
}
