//
//  Theme.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

public func setThemeConfig(_ padding: FoundationSizeConfig) {
    Theme.paddingConfig = padding
}

public struct FoundationUI {
    internal init() {}
    internal static var paddingConfig: FoundationSizeConfig = .init(multiplier: 2, base: 8)
    
    /// Set theme config globally
    public static func setConfig(padding: FoundationSizeConfig) {
        Self.paddingConfig = padding
    }
    
    public struct Padding: ThemePadding {
        internal init() {}
    }
    
    public struct Color: FoundationColor {
        internal init() {}
    }
}

public typealias Theme = FoundationUI


public protocol FoundationColor {}

public extension FoundationColor {
    static var primary: Color { .primary }
}

public extension ShapeStyle {
    typealias theme = Theme.Color
}

// Set of several different value sets
public enum ThemeCGFloatProperties {
    public typealias padding = Theme.Padding
    public typealias radius = Theme.Padding
}
public extension CGFloat {
    typealias theme = ThemeCGFloatProperties
}


public struct FoundationSizeConfig {
    internal var multiplier: CGFloat
    internal var base: CGFloat
    
    internal var _xsmall: CGFloat?
    internal var _small: CGFloat?
    internal var _regular: CGFloat?
    internal var _large: CGFloat?
    internal var _xlarge: CGFloat?
    
    public init(multiplier: CGFloat, base: CGFloat) {
        self.multiplier = multiplier
        self.base = base
    }
    
    public init(xsmall: CGFloat, small: CGFloat, regular: CGFloat, large: CGFloat, xlarge: CGFloat) {
        self._xsmall = xsmall
        self._small = small
        self._regular = regular
        self._large = large
        self._xlarge = xlarge
        self.multiplier = 1
        self.base = 0
    }
    
    internal var xsmall: CGFloat { _xsmall ?? small / multiplier }
    internal var small: CGFloat { _small ?? regular / multiplier }
    internal var regular: CGFloat { _regular ?? base }
    internal var large: CGFloat { _large ?? regular * multiplier }
    internal var xlarge: CGFloat { _xlarge ?? large * multiplier }
}

public protocol FoundationSize {
    static var xsmall: CGFloat { get }
    static var small: CGFloat { get }
    static var regular: CGFloat { get }
    static var large: CGFloat { get }
    static var xlarge: CGFloat { get }
}

public protocol ThemePadding: FoundationSize {}

public extension ThemePadding {
    static var xsmall: CGFloat { Theme.paddingConfig.xsmall } // 2
    static var small: CGFloat { Theme.paddingConfig.small } // 4
    static var regular: CGFloat { Theme.paddingConfig.regular } // 8
    static var large: CGFloat { Theme.paddingConfig.large } // 16
    static var xlarge: CGFloat { Theme.paddingConfig.xlarge } // 32
}
