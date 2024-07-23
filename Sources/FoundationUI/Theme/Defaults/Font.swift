//
//  Font.swift
//
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

public protocol FoundationFontDefaultScale: DefaultFoundationVariableTokenScale {}

extension FoundationFontDefaultScale where Self == FoundationUI.Theme.Font {
    public static var xxSmall: Self { .init(.footnote) }
    public static var xSmall: Self { .init(.subheadline) }
    public static var small: Self { .init(.callout) }
    public static var regular: Self { .init(.body) }
    public static var large: Self { .init(.title3) }
    public static var xLarge: Self { .init(.title2) }
    public static var xxLarge: Self { .init(.title) }
}

extension FoundationUI.Theme {
    @frozen
    public struct Font: FoundationVariableWithValue, FoundationFontDefaultScale {
        public typealias Result = SwiftUI.Font
        
        public func callAsFunction(_ scale: Self) -> SwiftUI.Font {
            scale.value
        }
        
        public var value: SwiftUI.Font
        
        public init() { self = .regular }
        
        public init(value: SwiftUI.Font) {
            self.value = value
        }
    }
}


#warning("TODO: DynamicFont")
//public static var xxSmall = Self { .system(size: ($0 / 1.25).precise(1)) } // 8
//public static var xSmall = Self { .system(size: ($0 / 1.125).precise(1)) } // 10
//public static var small = Self { .system(size: ($0 / 1.05).precise(1)) } // 12
