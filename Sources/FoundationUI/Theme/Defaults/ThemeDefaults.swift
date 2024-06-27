//
//  ThemeDefaults.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Configuration

extension FoundationUI {
    public struct Theme: ThemeConfiguration {
        public var baseValue: CGFloat
        
        public init(baseValue: CGFloat = 8) {
            self.baseValue = baseValue
        }
        
        public var color: FoundationUI.Token.DynamicColor { .primary }
        
        // font
    }
}

/// Default Implementation
extension FoundationUITheme {
    public static var theme: FoundationUI.Theme { .init() }
}

extension CGFloat {
    static var theme: FoundationUI.Theme { FoundationUI.theme }
}

// MARK: - Tokens

public extension FoundationUI {
    public enum Token {}
}

// MARK: - Font

extension FoundationUI.Token {
    #warning("Name as DynamicFont, and make StaticFont too?")
    public struct Font: FoundationTokenWithValue {
        public typealias Result = SwiftUI.Font
        
        public var value: CGFloat
        
        public init(_ value: CGFloat) {
            self.value = value
        }
        
        public struct Scale: FoundationTokenAdjustableScale {
            public var adjust: (CGFloat) -> SwiftUI.Font

            public init(_ adjust: @escaping (CGFloat) -> SwiftUI.Font) {
                self.adjust = adjust
            }
            
            public static var xxSmall = Self { .system(size: ($0 / 1.25).precise(1)) } // 8
            public static var xSmall = Self { .system(size: ($0 / 1.125).precise(1)) } // 10
            public static var small = Self { .system(size: ($0 / 1.05).precise(1)) } // 12
            public static let regular = Self(value: .system(size: 13))
            public static let large = Self(value: .title3)
            public static let xLarge = Self(value: .title2)
            public static let xxLarge = Self(value: .title)
        }
    }
}

// MARK: - Color

extension FoundationUI.DynamicColor: FoundationColorToken {
    public func hue(_ value: CGFloat) -> FoundationUI.DynamicColor {
        hue(value, method: .multiply)
    }
    public func saturation(_ value: CGFloat) -> FoundationUI.DynamicColor {
        saturation(value, method: .multiply)
    }
    public func brightness(_ value: CGFloat) -> FoundationUI.DynamicColor {
        brightness(value, method: .multiply)
    }
    public func opacity(_ value: CGFloat) -> FoundationUI.DynamicColor {
        opacity(value, method: .multiply)
    }
}

public extension FoundationUI.Token {
    public typealias DynamicColor = FoundationUI.DynamicColor
}

extension FoundationUI.DynamicColor {
    public func scale(_ scale: Scale) -> Self {
        scale(self)
    }
    
    public func callAsFunction(_ color: Self) -> Self {
        color
    }
    
    public struct Scale: DynamicColorScale {
        public typealias SourceValue = FoundationUI.DynamicColor
        public typealias ResultValue = FoundationUI.DynamicColor
        public var adjust: (SourceValue) -> ResultValue
        
        public init(_ adjust: @escaping (SourceValue) -> ResultValue) {
            self.adjust = adjust
        }
    }
}


// MARK: - Misc
