//
//  DefaultTheme.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import FoundationUICore
import SwiftUI

public extension FoundationUI.Color {
    static var primary: Color { .init(gray: 0.43, grayDark: 0.55) }
    static var accent: Color { .blue }
}

extension FoundationUI.Font: FoundationUISize {
    public static let xSmall    = Font.caption
    public static let small     = Font.callout
    public static let regular   = Font.body
    public static let large     = Font.title3
    public static let xLarge    = Font.title2
    public static let xxLarge   = Font.title
}

extension FoundationUI.Shadow: FoundationUISize {
    public static var xSmall    = FoundationUI.Shadow(.black.opacity(0.25), radius: 3, x: 0, y: 3)
    public static var small     = FoundationUI.Shadow(.black.opacity(0.35), radius: 4, x: 0, y: 4)
    public static var regular   = FoundationUI.Shadow(.black.opacity(0.4), radius: 5, x: 0, y: 5)
    public static var large     = FoundationUI.Shadow(radius: 12)
    public static var xLarge    = FoundationUI.Shadow(radius: 16)
    public static var xxLarge   = FoundationUI.Shadow(radius: 18)
}

public extension View {
    func shadow(double value: FoundationUI.Shadow) -> some View {
        self
            .shadow(color: value.color.opacity(0.3), radius: value.radius * 0.2, x: 0, y: value.y * 0.1)
            .shadow(color: value.color, radius: value.radius, x: value.x, y: value.y)
    }
}

extension FoundationUI {
    internal static var config: FoundationUI.Config = .init(
        padding: .init(multiplier: 2, base: 8),
        radius: .init(multiplier: 2, base: 8)
    )
    
    public struct Config {
        let padding: Size
        let radius: Size
        
        init(padding: Size, radius: Size) {
            self.padding = padding
            self.radius = radius
        }
    }
}

extension FoundationUI.Padding: FoundationUISize {
    private static let config   = FoundationUI.config.padding
    public static let xSmall    = config.xSmall
    public static let small     = config.small
    public static let regular   = config.regular
    public static let large     = config.large
    public static let xLarge    = config.xLarge
    public static let xxLarge   = config.xxLarge
}

extension FoundationUI.Radius: FoundationUISize {
    private static let config   = FoundationUI.config.radius
    public static let xSmall    = config.xSmall
    public static let small     = config.small
    public static let regular   = config.regular
    public static let large     = config.large
    public static let xLarge    = config.xLarge
    public static let xxLarge   = config.xxLarge
}

#if os(macOS)
public extension FoundationUI.Radius {
    static let window: CGFloat = 10
}
#endif

public protocol FoundationUISize {
    associatedtype V
    static var xSmall: V { get }
    static var small: V { get }
    static var regular: V { get }
    static var large: V { get }
    static var xLarge: V { get }
    static var xxLarge: V { get }
}


extension FoundationUI.Config {
    public struct Size {
        public var xSmall: CGFloat  { _xSmall ?? small / multiplier }
        public var small: CGFloat   { _small ?? regular / multiplier }
        public var regular: CGFloat { _regular ?? base }
        public var large: CGFloat   { _large ?? regular * multiplier }
        public var xLarge: CGFloat  { _xLarge ?? large * multiplier }
        public var xxLarge: CGFloat { _xxLarge ?? xLarge * multiplier }
        
        public init(multiplier: CGFloat, base: CGFloat) {
            self.multiplier = multiplier
            self.base = base
        }
        
        public init(
            xsmall: CGFloat,
            small: CGFloat,
            regular: CGFloat,
            large: CGFloat,
            xlarge: CGFloat,
            xxlarge: CGFloat
        ) {
            _xSmall = xsmall
            _small = small
            _regular = regular
            _large = large
            _xLarge = xlarge
            _xxLarge = xxlarge
            multiplier = 1
            base = 0
        }
        
        private var multiplier: CGFloat
        private var base: CGFloat
        
        private var _xSmall: CGFloat?
        private var _small: CGFloat?
        private var _regular: CGFloat?
        private var _large: CGFloat?
        private var _xLarge: CGFloat?
        private var _xxLarge: CGFloat?
    }
    
}
