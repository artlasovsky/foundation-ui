//
//  Radius.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public extension Theme {
    @frozen
	struct Radius: FoundationVariableWithCGFloatValue {
        public var value: CGFloat
		public var environmentAdjustment: EnvironmentAdjustment?
        
		init() {
            self.value = 0
        }
        public init(value: CGFloat) {
            self.value = value
        }
    }
}
