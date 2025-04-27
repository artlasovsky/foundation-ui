//
//  Spacing.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public extension Theme {
    @frozen
	struct Spacing: FoundationVariableWithCGFloatValue {
        public var value: CGFloat
		public var environmentAdjustment: (@Sendable (EnvironmentValues) -> Theme.Spacing?)?
		
        init() {
            self.value = 0
        }
        public init(value: CGFloat) {
            self.value = value
        }
    }
}
