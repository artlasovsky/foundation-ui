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

struct BasicAdjustableToken: FoundationAdjustableVariable {
    typealias Result = CGFloat
    typealias Value = CGFloat
    
    var value: Value
    var adjust: @Sendable (Value) -> Result
    
    init(adjust: @escaping @Sendable (Value) -> Value) {
        self.value = 0
        self.adjust = adjust
    }
    
    init(value: Value) {
        self.value = value
        self.adjust = { _ in value }
    }
    
    static let small = Self { $0 / 2 }
    static let regular = Self { $0 }
    static let large = Self { $0 * 2 }
}

extension TokenTests {
    func testBasicAdjustableTokenGeneration() throws {
        let token8 = BasicAdjustableToken(8)
        XCTAssert(token8(.small) == 4)
        XCTAssert(token8(.regular) == 8)
        XCTAssert(token8(.large) == 16)
        
        let token6 = BasicAdjustableToken(6)
        XCTAssert(token6(.small) == 3)
        XCTAssert(token6(.regular) == 6)
        XCTAssert(token6(.large) == 12)
    }
}

struct TokenWithMultiplier: DefaultFoundationAdjustableVariableWithMultiplier {
    public typealias Result = CGFloat
    public let value: CGFloatWithMultiplier
    public let adjust: @Sendable (CGFloatWithMultiplier) -> CGFloat
    
    public init(value: CGFloatWithMultiplier) {
        self.value = value
        self.adjust = { _ in value.base }
    }
    
    public init(adjust: @escaping @Sendable (CGFloatWithMultiplier) -> CGFloat) {
        self.adjust = adjust
        self.value = .init(base: 0, multiplier: 0)
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
        XCTAssert(tokenAlt(.xxSmall).precise(1) == CGFloat(4 / pow(1.2, 3)).precise(1))
        XCTAssert(tokenAlt(.regular) == 4)
        XCTAssert(tokenAlt(.xxLarge).precise(1) == CGFloat(4 * pow(1.2, 3)).precise(1))
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
