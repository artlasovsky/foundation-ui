//
//  ThemeDefaults.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Configuration

extension FoundationUI {
    public struct DefaultTheme: ThemeConfiguration {
        public var baseValue: CGFloat
        
        public init(baseValue: CGFloat = 8) {
            self.baseValue = baseValue
        }
    }
}

/// Default Implementation
extension FoundationUITheme {
    public static var theme: FoundationUI.DefaultTheme { .init() }
}

// MARK: - Tokens

public extension FoundationUI.DefaultTheme {
    enum Token {}
}
