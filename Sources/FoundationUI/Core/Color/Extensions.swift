//
//  Extensions.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

// MARK: Internal Extensions
internal extension Numeric where Self: Comparable {
    func clamp(_ lowerBound: Self, _ upperBound: Self) -> Self {
        max(lowerBound, min(upperBound, self))
    }
}

internal extension CGFloat {
    func precise(_ digits: Int = 2) -> Self {
        NSString(format: "%.\(digits)f" as NSString, self).doubleValue
    }
}

internal extension Float {
    func precise(_ digits: Int = 2) -> Self {
        NSString(format: "%.\(digits)f" as NSString, self).floatValue
    }
}

internal extension Double {
	func precise(_ digits: Int = 2) -> Self {
		NSString(format: "%.\(digits)f" as NSString, self).doubleValue
	}
}
