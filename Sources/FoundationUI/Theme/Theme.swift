//
//  Theme.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

public struct FoundationUI {
    internal struct Config {
        typealias Size = FoundationUI.SizeConfig
        var padding: FoundationUI.SizeConfig
        var radius: FoundationUI.SizeConfig
        
        init(padding: Size, radius: Size) {
            self.padding = padding
            self.radius = radius
        }
        
        public mutating func updateConfig(
            padding: FoundationUI.SizeConfig?,
            radius: FoundationUI.SizeConfig?
        ) {
            self.padding = padding ?? self.padding
            self.radius = radius ?? self.radius
        }
    }
    
    internal init() {}
    internal static var config: FoundationUI.Config = .init(
        padding: .init(multiplier: 2, base: 8),
        radius: .init(multiplier: 2, base: 8)
    )
    
    /// Set theme config globally
    public static func setConfig(
        padding: SizeConfig?,
        radius: SizeConfig?
    ) {
        Self.config.updateConfig(padding: padding, radius: radius)
    }
    
    public struct Padding: FoundationPadding { internal init() {} }
    
    public struct Radius: FoundationRadius { internal init() {} }
    
    public struct Color: FoundationColor { internal init() {} }
    
    public final class Modifier {}
}

public protocol FoundationColor {}
public extension FoundationColor {
    static var primary: Color { .primary }
//    static var secondary: Color { .init(light: .black, dark: .white)}
}

public protocol FoundationPadding: FoundationSize {}
public extension FoundationPadding {
    private static var config: FoundationUI.SizeConfig { FoundationUI.config.padding }
    static var xsmall: CGFloat { config.xsmall }
    static var small: CGFloat { config.small }
    static var regular: CGFloat { config.regular }
    static var large: CGFloat { config.large }
    static var xlarge: CGFloat { config.xlarge }
}

public protocol FoundationRadius: FoundationSize {}
public extension FoundationRadius {
    private static var config: FoundationUI.SizeConfig { FoundationUI.config.radius }
    static var xsmall: CGFloat { config.xsmall }
    static var small: CGFloat { config.small }
    static var regular: CGFloat { config.regular }
    static var large: CGFloat { config.large }
    static var xlarge: CGFloat { config.xlarge }
}
