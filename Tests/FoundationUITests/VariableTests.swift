//
//  VariableTests.swift
//
//
//  Created by Art Lasovsky on 08/07/2024.
//

import Testing
import Foundation
@testable import FoundationUI

// Using Default Theme
extension Theme.Padding: FoundationThemePadding {}
extension Theme.Radius: FoundationThemeRadius {}

// Theme Extension
private extension Theme.Padding {
	static let custom: Theme.Padding = 11.0
    static let xxLargeHalfUp: Theme.Padding = .xxLarge.up(.half)
    static let smallHalfDown: Theme.Padding = .small.down(.half)
}

@Suite("Variable")
struct VariableTests {
    @Test func defaultThemeValues() throws {
		#expect(Theme.Padding.small == 8 / 2)
		#expect(CGFloat.foundation(.padding(.small)) == CGFloat(8 / 2))
		#expect(Theme.Padding.regular == 8)
		#expect(Theme.Padding.xxLarge == 64)
		#expect(Theme.Radius.small.value == 6)
    }
    
    @Test func themeFloatVariableAdjustments() {
		#expect(Theme.Padding.regular.up(.half) == 8 + 8 / 2)
		#expect(Theme.Padding.regular.up(.quarter) == 8 + 8 / 4)
        
		#expect(Theme.Padding.regular.down(.half) == 8 - 8 / 2 / 2)
		#expect(Theme.Padding.regular.down(.quarter) == 8 - 8 / 2 / 4)
    }
    
    @Test func themeExtension() {
		#expect(Theme.Padding.custom == 11)
		#expect(Theme.Padding.xxLargeHalfUp == 64 + 64 / 2)
		#expect(Theme.Padding.smallHalfDown == 4 - (4 / 2) / 2)
    }
}
