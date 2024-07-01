//
//  File.swift
//  
//
//  Created by Art Lasovsky on 30/06/2024.
//

import Foundation
import XCTest
@testable import FoundationUI

struct BasicToken: FoundationVariable {
    func callAsFunction(_ scale: Token) -> CGFloat {
        scale.value
    }
    
    struct Token {        
        var value: CGFloat
        
        static let small = Self(value: 4)
        static let regular = Self(value: 8)
        static let large = Self(value: 12)
    }
}

final class TokenTests: XCTestCase {
    func testBasicTokenGeneration() throws {
        let basicToken = BasicToken()
        XCTAssert(basicToken(.small) == 4)
        XCTAssert(basicToken(.regular) == 8)
        XCTAssert(basicToken(.large) == 12)
    }
}

struct BasicAdjustableToken: FoundationVariable {
    var baseValue: CGFloat
    
    func callAsFunction(_ scale: Token) -> CGFloat {
        scale(baseValue)
    }
    
    struct Token: FoundationVariableToken {
        typealias SourceValue = CGFloat
        typealias ResultValue = CGFloat
        
        var adjust: Adjust
        
        init(_ adjust: @escaping Adjust) {
            self.adjust = adjust
        }
        
        static let small = Self { $0 / 2 }
        static let regular = Self { $0 }
        static let large = Self { $0 * 2 }
    }
}

extension TokenTests {
    func testBasicAdjustableTokenGeneration() throws {
        let token8 = BasicAdjustableToken(baseValue: 8)
        XCTAssert(token8(.small) == 4)
        XCTAssert(token8(.regular) == 8)
        XCTAssert(token8(.large) == 16)
        
        let token6 = BasicAdjustableToken(baseValue: 6)
        XCTAssert(token6(.small) == 3)
        XCTAssert(token6(.regular) == 6)
        XCTAssert(token6(.large) == 12)
    }
}

struct TokenWithMultiplier: DefaultThemeFoundationVariable {
    var value: (base: CGFloat, multiplier: CGFloat)
    init(_ value: (base: CGFloat, multiplier: CGFloat)) {
        self.value = value
    }
    
    func callAsFunction(_ scale: Token) -> CGFloat {
        scale(value)
    }
    
    struct Token: DefaultThemeFoundationVariableTokenScale {
        var adjust: @Sendable (TokenWithMultiplier.Configuration) -> CGFloat
        init(_ adjust: @escaping Adjust) {
            self.adjust = adjust
        }
    }
}

extension TokenTests {
    func testTokenWithMultiplierScaleGeneration() throws {
        let token = TokenWithMultiplier(base: 8, multiplier: 2)
        XCTAssert(token(.xxSmall) == 1)
        XCTAssert(token(.xSmall) == 2)
        XCTAssert(token(.regular) == 8)
        XCTAssert(token(.xxLarge) == 64)
        
        let tokenAlt = TokenWithMultiplier(base: 4, multiplier: 1.2)
        XCTAssert(tokenAlt(.xxSmall) == 4 / pow(1.2, 3))
        XCTAssert(tokenAlt(.xSmall) == 4 / pow(1.2, 2))
        XCTAssert(tokenAlt(.regular) == 4)
        XCTAssert(tokenAlt(.xxLarge) == 4 * pow(1.2, 3))
    }
    
    func testTokenWithMultiplierScaleExtra() throws {
        let token = TokenWithMultiplier(base: 8, multiplier: 2)
        
        XCTAssert(token(.regular.up(.half)) == 8 + (16 - 8) * 0.5)
        XCTAssert(token(.regular.up(.quarter)) == 8 + (16 - 8) * 0.25)
        XCTAssert(token(.regular.down(.third)) == 8 - (8 - 4) * 0.33)
        XCTAssert(token(.regular.down(.full)) == 8 - 4)
        
        XCTAssert(token(.regular.negative()) == -8)
        XCTAssert(token(.regular.down(.half).negative()) == -6)
    }
}
