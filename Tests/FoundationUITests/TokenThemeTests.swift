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

//public struct CustomTheme: ThemeConfiguration {
//    public var color = ColorToken()
//    public init() {}
//}

//private extension FoundationUI {
//    static var theme = CustomTheme()
//}

final class CustomThemeTests: XCTestCase {

}

public struct ColorToken: FoundationColorVariable {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color.init(hue: 0, saturation: 0, brightness: 1)
    }
    
    public func scale(_ scale: Scale) -> ColorToken {
        self
    }
    
    public func callAsFunction(_ color: ColorToken) -> ColorToken {
        color
    }
    
    public enum Scale {
        case background
        case text
    }
    
    public func brightness(_ value: CGFloat) -> ColorToken {
        self
    }
    
    public func hue(_ value: CGFloat) -> ColorToken {
        self
    }
    
    public func saturation(_ value: CGFloat) -> ColorToken {
        self
    }
    
    public func opacity(_ value: CGFloat) -> ColorToken {
        self
    }
}
