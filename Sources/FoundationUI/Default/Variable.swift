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
    static var regular: CGFloat { 8 }
}

// Default Theme implementation
public extension FoundationUIVariableDefaults {
    static var padding: FoundationUI.Variable.Padding { .init(.init(regular: VariableDefaults.regular, multiplier: VariableDefaults.multiplier)) }
    static var spacing: FoundationUI.Variable.Spacing { .init(.init(regular: VariableDefaults.regular / 2, multiplier: VariableDefaults.multiplier)) }
    static var radius: FoundationUI.Variable.Radius { .init(.init(regular: VariableDefaults.regular, multiplier: VariableDefaults.multiplier)) }
    
    static var shadow: FoundationUI.Variable.Shadow {
        let color: FoundationUI.Color = .primary.text
        return .init(.init(
            xxSmall: .init(radius: 0.5, color: color.opacity(0.1), x: 0, y: 0.5),
            xSmall: .init(radius: 1, color: color.opacity(0.15), x: 0, y: 1),
            small: .init(radius: 1.5, color: color.opacity(0.2), x: 0, y: 1),
            regular: .init(radius: 2.5, color: color.opacity(0.25), x: 0, y: 1),
            large: .init(radius: 3.5, color: color.opacity(0.3), x: 0, y: 1),
            xLarge: .init(radius: 4, color: color.opacity(0.4), x: 0, y: 1),
            xxLarge: .init(radius: 5, color: color.opacity(0.4), x: 0, y: 1)
        ))
    }
    
    static var animation: FoundationUI.Variable.Animation { .init(default: .interactiveSpring(duration: 0.2)) }
    
    static var font: FoundationUI.Variable.Font { .init(.init(
        xxSmall: .caption, xSmall: .callout, small: .callout, regular: .body, large: .title3, xLarge: .title2, xxLarge: .title
    )) }
}

struct ShadowPreview: PreviewProvider {
    static var previews: some View {
        let rect: some View = RoundedRectangle(cornerRadius: .theme.radius.xSmall).frame(width: 20, height: 20)
        let style: some ShapeStyle = .foundation.primary.background
        VStack(spacing: 20) {
            rect.foundation().shadow(\.xxSmall)
            rect.foundation().shadow(\.xSmall)
            rect.foundation().shadow(\.small)
            rect.foundation().shadow(\.regular)
            rect.foundation().shadow(\.large)
            rect.foundation().shadow(\.xLarge)
            rect.foundation().shadow(\.xxLarge)
        }
        .foregroundStyle(style)
        .padding()
        .theme().background(style)
    }
}

// MARK: - Extensions

// Set of several different value sets
public enum ThemeCGFloatProperties {
    public static let spacing = FoundationUI.Variable.spacing
    public static let padding = FoundationUI.Variable.padding
    public static let radius = FoundationUI.Variable.radius
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
    struct Padding: VariableScale {
        public var config: VariableConfig<CGFloat>
        public init(_ config: VariableConfig<CGFloat>) {
            self.config = config
        }
    }
    struct Spacing: VariableScale {
        public var config: VariableConfig<CGFloat>
        public init(_ config: VariableConfig<CGFloat>) {
            self.config = config
        }
    }
    
    struct Radius: VariableScale {
        public var config: VariableConfig<CGFloat>
        public init(_ config: VariableConfig<CGFloat>) {
            self.config = config
        }
    }
    
    struct Font: VariableScale {
        public var config: VariableConfig<SwiftUI.Font>
        public init(_ config: VariableConfig<SwiftUI.Font>) {
            self.config = config
        }
    }
    
    struct Animation {
        let `default`: SwiftUI.Animation
    }
}

// MARK: - OS Specific
#if os(macOS)
public extension FoundationUI.Variable.Radius {
    /// Default macOS window radius
    var window: CGFloat { 10 }
}
#endif
