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
private extension Theme.Padding {
    static var regular: Theme.Padding = .init(value: 10)
}

final class ThemeOverrideTests: XCTestCase {
    func testTokenScaleOverride() throws {
        XCTAssert(Theme.default.padding(.small) == 8 / 2)
        XCTAssert(Theme.default.padding(.regular) == 10)
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

private extension Theme {
    var size: SizeToken { .init() }
}

extension ThemeOverrideTests {
    func testTokenOverride() throws {
        XCTAssert(Theme.default.size(.regular) == 24)
        XCTAssert(Theme.default.size(.small) == 18)
        XCTAssert(Theme.default.size(.large) == 32)
    }
}
