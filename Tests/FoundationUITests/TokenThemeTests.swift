//
//  File.swift
//  
//
//  Created by Art Lasovsky on 30/06/2024.
//

import Foundation
import XCTest
@testable import FoundationUI

import SwiftUI

struct CustomTheme: ThemeConfiguration {
    var padding = TestVariable()
    var spacing = TestVariable()
    var size = TestVariable()
    var radius = TestVariable()
    
    var shadow = TestVariable()
    var font = TestVariable()
    var linearGradient = TestVariable()
    
    var color = TestColorVariable()
    public init() {}
}

//private extension FoundationUI {
//    typealias Theme = CustomTheme
//    static var theme = CustomTheme()
//}

private extension FoundationUITheme {
//    typealias Theme = CustomTheme
    static var theme: CustomTheme { CustomTheme() }
}

final class CustomThemeTests: XCTestCase {
    func testCustomThemeValues() throws {
        XCTAssert(FoundationUI.theme.padding(.sm) == 2)
        print(Color.theme(.primary))
//        let view = Text("").foregroundStyle(.theme(.primary))
        print(theme.color(.primary).token(.background))
        print(theme.color(.primary.token(.background)))
//        print(FoundationUI.theme.color(.primary))
    }
}

struct TestVariable: FoundationVariable {
    typealias Result = CGFloat
    func callAsFunction(_ token: Token) -> Result {
        token.rawValue
    }
    
    enum Token: CGFloat {
        case sm = 2
        case base = 8
        case lg = 12
    }
}

struct TestColorVariable: FoundationColorVariable {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color.init(hue: 0, saturation: 0, brightness: 1)
    }
    
    public func token(_ scale: Token) -> Self {
        self
    }
    
    public func callAsFunction(_ color: Self) -> Self {
        color
    }
    
    public enum Token {
        case background
        case text
    }
    
    public func brightness(_ value: CGFloat) -> Self {
        self
    }
    
    public func hue(_ value: CGFloat) -> Self {
        self
    }
    
    public func saturation(_ value: CGFloat) -> Self {
        self
    }
    
    public func opacity(_ value: CGFloat) -> Self {
        self
    }
}

extension TestColorVariable {
    static let primary = TestColorVariable()
}
