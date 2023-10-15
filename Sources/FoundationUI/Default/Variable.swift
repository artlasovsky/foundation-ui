//
//  Variable.swift
//  
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI

// Default Theme implementation
public extension FoundationUIDefault {
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
    static let padding = FoundationUI.padding
    static let radius = FoundationUI.radius
}

public extension CGFloat {
    typealias foundation = ThemeCGFloatProperties
    typealias theme = Self.foundation
}

public extension Font {
    static let foundation = FoundationUI.font
    static let theme = Self.foundation
}

public extension Animation {
    static let theme = FoundationUI.animation
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
    static let window: CGFloat = 10
}
#endif


// MARK: - Demo

// Default Theme Overrides

// Override default `VariableScale`:
public extension FoundationUI {
    static var padding: Variable.Padding { .init(.init(regular: 6, multiplier: 2)) } // 3 4 6 8 12 16 24 32
}
// Extend scale with custom value:
public extension FoundationUI.Variable.Padding {
    var window: CGFloat { self.xxLarge }
}
extension FoundationUI.Variable.Font {
    var body: Value { .body.bold() }
}

#Preview("Test") {
    VStack {
        Text([
            FoundationUI.padding.xxSmall,
            FoundationUI.padding.xSmall,
            FoundationUI.padding.small,
            FoundationUI.padding.regular,
            FoundationUI.padding.large,
            FoundationUI.padding.xLarge,
            FoundationUI.padding.xxLarge
        ]
            .map({ String(format: "%.2f", $0 )}).joined(separator: " "))
        RoundedRectangle.theme.small
            .frame(width: 20, height: 20)
            .theme.shadow.large
        Text("FoundationUI \(Int(FoundationUI.padding.regular))")
            .font(.theme.body)
            .theme.padding(.horizontal).large
            .theme.padding(.vertical).regular
            .animation(.theme.default, value: 0)
            .theme.border(.theme.accent.border)
        // TODO: Background 
        // TODO: Corner Radius
//            .overlay {
//                RoundedRectangle.theme.regular
//                    .stroke(lineWidth: 2)
//                    .foregroundStyle(.theme.primary.border)
//            }
    }.padding()
}
