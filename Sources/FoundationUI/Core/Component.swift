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
public extension FoundationUI.Component {
    static func roundedRectangle(_ radius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius, style: FoundationUI.Style.cornerRadiusStyle)
    }
    static func roundedRectangle(_ radius: KeyPath<FoundationUI.Variable.Radius, CGFloat>) -> RoundedRectangle {
        self.roundedRectangle(FoundationUI.Variable.radius[keyPath: radius])
    }
    struct RoundedRect: GenericVariableScale {
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
    static func foundation(_ radius: KeyPath<FoundationUI.Variable.Radius, CGFloat>) -> Self { FoundationUI.Component.roundedRectangle(radius) }
    static func theme(_ radius: CGFloat) -> Self { foundation(radius) }
    static func theme(_ radius: KeyPath<FoundationUI.Variable.Radius, CGFloat>) -> Self { foundation(radius) }
}
