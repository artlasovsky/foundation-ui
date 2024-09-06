//
//  VariableTests.swift
//
//
//  Created by Art Lasovsky on 08/07/2024.
//

import XCTest
@testable import FoundationUI

// Theme Extension
private extension Theme.Padding {
    static var custom: Theme.Padding = .init(value: 11)
    static var xxLargeHalfUp: Theme.Padding = .xxLarge.up(.half)
    static var smallHalfDown: Theme.Padding = .small.down(.half)
}

final class VariableTests: XCTestCase {
    func testDefaultThemeValues() throws {
        XCTAssert(Theme.default.padding(.small) == 8 / 2)
        XCTAssert(Theme.default.padding(.regular) == 8)
        XCTAssert(Theme.default.padding(.xxLarge) == 64)
        XCTAssert(Theme.default.radius(.small) == 6)
    }
    
    func testThemeFloatVariableAdjustments() {
        XCTAssert(Theme.default.padding(.regular.up(.half)) == 8 + 8 / 2)
        XCTAssert(Theme.default.padding(.regular.up(.third)) == 8 + 8 / 3)
        XCTAssert(Theme.default.padding(.regular.up(.quarter)) == 8 + 8 / 4)
        
        XCTAssert(Theme.default.padding(.regular.down(.half)) == 8 - 8 / 2 / 2)
        XCTAssert(Theme.default.padding(.regular.down(.third)) == 8 - 8 / 2 / 3)
        XCTAssert(Theme.default.padding(.regular.down(.quarter)) == 8 - 8 / 2 / 4)
    }
    
    func testThemeExtension() {
        XCTAssert(Theme.default.padding(.custom) == 11)
        XCTAssert(Theme.default.padding(.xxLargeHalfUp) == 64 + 64 / 2)
        XCTAssert(Theme.default.padding(.smallHalfDown) == 4 - (4 / 2) / 2)
    }
}
