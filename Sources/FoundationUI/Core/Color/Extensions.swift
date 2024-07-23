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

internal extension Color {
    @available(macOS 14.0, iOS 17.0, *)
    func rgbaComponents(in scheme: FoundationColorScheme) -> (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var environment: EnvironmentValues
        switch scheme {
        case .light:
            environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        case .dark:
            environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .standard)
        case .lightAccessible:
            environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .increased)
        case .darkAccessible:
            environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .increased)
        }
        let resolved = self.resolve(in: environment)
        return (CGFloat(resolved.red), CGFloat(resolved.green), CGFloat(resolved.blue), CGFloat(resolved.opacity))
    }
}
