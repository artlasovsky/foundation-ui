//
//  Component.swift
//
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI


// MARK: - Rounded Rectangle
public extension FoundationUI.Component {
    static let roundedRect = RoundedRect()
    struct RoundedRect: VariableScale {
        public var config: VariableConfig<RoundedRectangle>
        private static func getRoundedRect(_ cornerRadius: CGFloat) -> RoundedRectangle {
            .init(cornerRadius: cornerRadius, style: .continuous)
        }
        public init() {
            let getRoundedRect = Self.getRoundedRect
            config = .init(
                xxSmall: getRoundedRect(.theme.radius.xxSmall),
                xSmall: getRoundedRect(.theme.radius.xSmall),
                small: getRoundedRect(.theme.radius.small),
                regular: getRoundedRect(.theme.radius.regular),
                large: getRoundedRect(.theme.radius.large),
                xLarge: getRoundedRect(.theme.radius.xLarge),
                xxLarge: getRoundedRect(.theme.radius.xxLarge))
        }
    }
}

public extension RoundedRectangle {
    static let foundation = FoundationUI.Component.roundedRect
    static let theme = Self.foundation
}
