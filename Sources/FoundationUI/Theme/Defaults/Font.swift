//
//  FontToken.swift
//
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var font: Token.Font { .init() }
}

extension FoundationUI.DefaultTheme.Token {
    public struct Font: FoundationToken {
        public typealias Result = SwiftUI.Font
        
        public func callAsFunction(_ scale: Scale) -> Result {
            scale.value
        }
        
        public struct Scale: FoundationTokenScale {
            public var value: SwiftUI.Font
            
            public init(_ value: SwiftUI.Font) {
                self.value = value
            }
            public static var xxSmall = Self(.footnote)
            public static var xSmall = Self(.subheadline)
            public static var small = Self(.callout)
            public static let regular = Self(.body)
            public static let large = Self(.title3)
            public static let xLarge = Self(.title2)
            public static let xxLarge = Self(.title)
        }
        #warning("TODO: DynamicFont")
//        public static var xxSmall = Self { .system(size: ($0 / 1.25).precise(1)) } // 8
//        public static var xSmall = Self { .system(size: ($0 / 1.125).precise(1)) } // 10
//        public static var small = Self { .system(size: ($0 / 1.05).precise(1)) } // 12
    }
}
