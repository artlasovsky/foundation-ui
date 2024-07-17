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
    
    var color = TestColorVariable(color: .primary)
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
        print(Theme.color(.primary).variant(.background))
        print(Theme.color(.primary.variant(.background)))
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
    typealias ColorValue = Color
    
    static func dynamic(_ variant: Variant) -> TestColorVariable {
        .primary.variant(variant)
    }
    
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color.init(hue: 0, saturation: 0, brightness: 1)
    }
    
    public func variant(_ scale: Variant) -> Self {
        self
    }
    
    public func callAsFunction(_ color: Self) -> Self {
        color
    }
    
    public enum Variant {
        case background
        case text
    }
    
    var color: Color
    
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
    
    func blendMode(_ blendMode: BlendMode) -> TestColorVariable {
        self
    }
    
    func colorScheme(_ colorScheme: FoundationUI.ColorScheme) -> TestColorVariable {
        self
    }
}

extension TestColorVariable {
    static let primary = TestColorVariable(color: .primary)
}
