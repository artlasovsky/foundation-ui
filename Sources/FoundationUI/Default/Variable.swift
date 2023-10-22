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

// Default Theme implementation
public extension FoundationUIVariableDefaults {
    static var padding: FoundationUI.Variable.Padding { .init(.init(regular: 8, multiplier: 2)) }
//    static var paddingFine: FoundationUI.Config.Padding { .init(.init(regular: 6, multiplier: 2)) }
    
    static var radius: FoundationUI.Variable.Radius { .init(.init(regular: 8, multiplier: 2)) }
    
    static var animation: FoundationUI.Variable.Animation { .init(default: .interactiveSpring(duration: 0.2)) }
    
    static var font: FoundationUI.Variable.Font { .init(.init(
        xxSmall: .caption, xSmall: .callout, small: .callout, regular: .body, large: .title3, xLarge: .title2, xxLarge: .title
    )) }
}

// MARK: - Extensions

// Set of several different value sets
public enum ThemeCGFloatProperties {
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


// MARK: - Demo

// Default Theme Overrides

// Override Theme `VariableScale`:
extension FoundationUI.Variable {
//    public static var padding: Padding { .init(.init(regular: 6, multiplier: 2)) }
}
// Extend Theme
extension FoundationUI.Variable.Font {
    var body: Value { .body.bold() }
}

// Extending Modifiers
extension FoundationUI.Modifier {
    func backgroundWithBorder(_ color: FoundationUI.Color, cornerRadius: CGFloat = 0) -> some View {
        content
            .theme().background(color.background, cornerRadius: cornerRadius)
            .theme().border(color.border, width: 2, cornerRadius: cornerRadius)
    }
    // Usage example:
    // - control label padding
    // - control background
    // - combine with ViewModifiers
}

struct Preview: PreviewProvider {
    static var previews: some View {
        VStack {
//            RoundedRectangle.theme.small
//                .frame(width: 20, height: 20)
//                .foregroundStyle(.white)
            HStack(spacing: .theme.padding.small) {
                Text("FoundationUI")
                    .padding(.vertical, .theme.padding.regular)
                    .padding(.horizontal, .theme.padding.large)
                    .theme().border(.theme.accent.border, width: 2, cornerRadius: .theme.radius.large - .theme.padding.regular)
                Text("Button")
                    .padding(.vertical, .theme.padding.regular)
                    .padding(.horizontal, .theme.padding.large)
                    .theme().backgroundWithBorder(.theme.accent, cornerRadius: .theme.radius.large - .theme.padding.regular)
            }
            .theme().padding(\.regular)
//            .theme().background(.theme.primary.background, cornerRadius: .theme.radius.large)
//            .theme().background(.theme.primary.background, cornerRadius: \.large)
            .theme().border(width: 2, cornerRadius: \.large)
        }
        .padding()
    }
}
