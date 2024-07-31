//
//  _ThemeDefaults.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Configuration

/// FoundationUI's theme
///
/// # Usage
/// You could use the theme variables via ``SwiftUI/View/foundation(_:bypass:)`` modifiers.
///
/// To access theme variables them directly via `Theme.default.variableName(tokenName)`, like:
/// ``` swift
/// let smallPadding = Theme.default.padding(.small)
/// ```
///
/// For variables that result in native SwiftUI value types, there's a way to access them with a `.foundation()` shortcut:
/// ```swift
/// // Set spacing for HStack (CGFloat)
/// HStack(spacing: .foundation(.spacing(.small))) {
///     Text("Theme")
///     // or use it in SwiftUI's `.foregroundStyle` view modifier (ShapeStyle)
///     .foregroundStyle(.foundation(.dynamic(.solid)))
///     // or use it when you need a SwiftUI.Color (Color)
///     .shadow(color: .foundation(.primary, in: .light), radius: 2)
///     // same with the `.font` modifier (Font)
///     .font(.foundation(.large))
/// }
/// ```
///
/// # Extending variable tokens
/// To add new token to the variable, just extend it's struct:
/// ```swift
/// extension Theme.Size {
///     // create new token using `.value` method
///     static let windowWidth = Self.value(275)
/// }
/// extension Theme.Radius {
///     // create new token based on already existing
///     static let buttonRadius = Self.small
/// }
///
/// extension Theme.Padding {
///     // you could also declare a token as a method
///     static func verticalPadding(isOpened: Bool) -> Self {
///         isOpened ? .large : .regular
///     }
/// }
/// ```
///
/// # Overriding variable tokens
/// Overriding existing tokens works the same way as extending, just use the name of existing tokens:
/// ```swift
/// extension Theme.Padding {
///     static let regular = Self.value(10) // default value was 8
/// }
/// ```
public struct Theme: ThemeConfiguration {
    private static let baseValue: CGFloat = 8
    private init() {}
    
    public let color = Color.primary
    
    public let padding = Padding(base: baseValue, multiplier: 2)
    public let radius = Radius(base: baseValue, multiplier: 1.5)
    public let size = Size(base: baseValue * 8, multiplier: 2)
    public let spacing = Spacing(base: baseValue, multiplier: 2)
    
    public let font = Font()
    public let shadow = Shadow()
    
    public static let `default` = Theme()
    
}

public enum FoundationCGFloatVariables {
    case padding(Theme.Padding)
    case spacing(Theme.Spacing)
    case radius(Theme.Radius)
    case size(Theme.Size)
}

extension CGFloat {
    public static func foundation(_ variable: FoundationCGFloatVariables) -> Self {
        switch variable {
        case .padding(let padding):
            Theme.default.padding(padding)
        case .spacing(let spacing):
            Theme.default.spacing(spacing)
        case .radius(let radius):
            Theme.default.radius(radius)
        case .size(let size):
            Theme.default.size(size)
        }
    }
}

extension ShapeStyle where Self == Theme.Color {
    public static func foundation(_ color: Theme.Color) -> Self {
        Theme.default.color(color)
    }
}

extension Color {
    /// Get ``SwiftUI/Color`` from FoundationUI's theme color variables
    /// - Parameters:
    ///   - color: Theme's color value
    ///   - colorScheme: Color will be resolved in selected color scheme
    /// - Returns: Returns SwiftUI's Color
    public static func foundation(_ color: Theme.Color, in colorScheme: FoundationColorScheme) -> Self {
        Theme.default.color(color).resolveColor(in: .init(colorScheme: colorScheme))
    }
}

extension Font {
    /// Get font from FoundationUI theme font variables
    /// - Parameter token: Font variable token
    /// - Returns: Returns SwiftUI's font
    public static func foundation(_ token: Theme.Font) -> Self {
        Theme.default.font(token)
    }
}
