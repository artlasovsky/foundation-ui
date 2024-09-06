//
//  Size.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public extension Theme {
    @frozen
    struct Size: FoundationVariableWithValue {
        public var value: CGFloat
        init() {
            self.value = 0
        }
        public init(value: CGFloat) {
            self.value = value
        }
        public func callAsFunction(_ token: Self) -> CGFloat {
            token.value
        }
    }
}
