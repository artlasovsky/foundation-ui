//
//  File.swift
//  
//
//  Created by Art Lasovsky on 30/06/2024.
//

import Foundation
import XCTest
@testable import FoundationUI

// Token Scale Override
private extension FoundationUI.Theme.Padding {
    static var regular: FoundationUI.Theme.Padding = .init(value: 10)
}

final class ThemeOverrideTests: XCTestCase {
    func testTokenScaleOverride() throws {
        XCTAssert(FoundationUI.theme.padding(.small) == 8 / 2)
        XCTAssert(FoundationUI.theme.padding(.regular) == 10)
    }
}

// Token Override

struct SizeToken: FoundationVariable {
    func callAsFunction(_ scale: Scale) -> CGFloat {
        scale.rawValue
    }
    
    enum Scale: CGFloat {
        case small = 18
        case regular = 24
        case large = 32
    }
}

private extension FoundationUI.DefaultTheme {
    var size: SizeToken { .init() }
}

extension ThemeOverrideTests {
    func testTokenOverride() throws {
        XCTAssert(FoundationUI.theme.size(.regular) == 24)
        XCTAssert(FoundationUI.theme.size(.small) == 18)
        XCTAssert(FoundationUI.theme.size(.large) == 32)
    }
}
