//
//  Variable.swift
//  
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI


extension FoundationUI {
    public struct Variable: FoundationUIVariableDefaults {}
    public struct Style: FoundationUIStyleDefaults {}
}

public extension FoundationUIStyleDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { .continuous }
}

internal enum VariableDefaults {
    static var multiplier: CGFloat { 2 }
    static var base: CGFloat { 8 }
}

// Default Theme implementation
public extension FoundationUIVariableDefaults {
    typealias Variable = FoundationUI.Variable
    static var padding: Variable.Padding { .init() }
    static var spacing: Variable.Spacing { .init() }
    static var radius: Variable.Radius { .init() }
    
    static var size: Variable.Size { .init() }
    
    static var shadow: Variable.Shadow { .init() }
    
    static var animation: Variable.Animation { .init() }
    
    static var font: Variable.Font { .init() }
}

// MARK: - Extensions

// Set of different value sets
public enum ThemeCGFloatProperties {
    public static let spacing = FoundationUI.Variable.spacing
    public static let padding = FoundationUI.Variable.padding
    public static let radius = FoundationUI.Variable.radius
    public static let size = FoundationUI.Variable.size
}

public extension CGFloat {
    typealias foundation = ThemeCGFloatProperties
    typealias theme = Self.foundation
}

public extension Font {
    static let foundation = FoundationUI.Variable.font
    static let theme = Self.foundation
}

public extension Animation {
    static let theme = FoundationUI.Variable.animation
}

// MARK: - Variables
public extension FoundationUI.Variable {
    struct Padding: CGFloatVariableScale {
        public var multiplier = VariableDefaults.multiplier
        public var base = VariableDefaults.base
        public var rounded = false
    }
    struct Spacing: CGFloatVariableScale {
        public var multiplier = VariableDefaults.multiplier
        public var base = VariableDefaults.base / 2
        public var rounded = false
    }
    
    struct Size: CGFloatVariableScale {
        public var multiplier = VariableDefaults.multiplier * (2 / 3)
        public var base = VariableDefaults.base * 8
        public var rounded = true
    }
    
    struct Radius: CGFloatVariableScale {
        public var multiplier = VariableDefaults.multiplier
        public var base = VariableDefaults.base
        public var rounded = false
    }
    
    struct Font: GenericVariableScale {
        typealias Font = SwiftUI.Font
        public let xxSmall = Font.caption
        public let xSmall = Font.callout
        public let small = Font.callout
        public let regular = Font.body
        public let large = Font.title3
        public let xLarge = Font.title2
        public let xxLarge = Font.title
    }
    
    struct Animation {
        let `default`: SwiftUI.Animation = .interactiveSpring(duration: 0.2)
    }
    
    struct Shadow: GenericVariableScale {
        public typealias Shadow = FoundationUI.Modifier.Shadow.Configuration
        static let scale: FoundationUI.ColorScale = .backgroundFaded.colorScheme(.dark)
        public var xxSmall = Shadow(radius: 0.5, scale: scale.opacity(0.1), x: 0, y: 0.5)
        public var xSmall = Shadow(radius: 1, scale: scale.opacity(0.15), x: 0, y: 1)
        public var small = Shadow(radius: 1.5, scale: scale.opacity(0.2), x: 0, y: 1)
        public var regular = Shadow(radius: 2.5, scale: Self.scale.opacity(0.25), x: 0, y: 1)
        public var large = Shadow(radius: 3.5, scale: scale.opacity(0.3), x: 0, y: 1)
        public var xLarge = Shadow(radius: 4, scale: scale.opacity(0.4), x: 0, y: 1)
        public var xxLarge = Shadow(radius: 12, scale: scale.opacity(0.6), x: 0, y: 1)
    }
}

// MARK: - OS Specific
#if os(macOS)
public extension FoundationUI.Variable.Radius {
    /// Default macOS window radius
    var window: CGFloat { 10 }
}
#endif


// MARK: Previews
struct ShadowPreview: PreviewProvider {
    static var previews: some View {
        let rect: some View = RoundedRectangle.foundation(\.small)
            .theme().size(\.small)
        let style: some ShapeStyle = .scale.text
        VStack(spacing: 20) {
            rect.theme().shadow(\.xxSmall)
            rect.theme().shadow(\.xSmall)
            rect.theme().shadow(\.small)
            rect.theme().shadow(\.regular)
            rect.theme().shadow(\.large)
            rect.theme().shadow(\.xLarge)
            rect.theme().shadow(\.xxLarge)
        }
        .foregroundStyle(style)
        .padding()
        .theme().background(style)
    }
}
