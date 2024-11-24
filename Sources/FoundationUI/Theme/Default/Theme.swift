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
/// # Default Theme
/// By default FoundationUI has no predefined tokens,
/// but you can always use the optinal default theme like that:
/// ```swift
/// // Add default padding values
/// extension Theme.Padding: FoundationTheme.Padding {}
/// // Add default colors (only `.primary`)
/// extension Theme.Color: FoundationTheme.Color {}
/// // Add default color variables (such as `.background` or `.textSubtle`)
/// extension Theme.Color.Variable: FoundationTheme.ColorVariable {}
///
/// ```
///
/// > Note: All the examples in the documentation referencing the default theme tokens (such as `.xSmall`, or `.regular` for values, `.primary` for colors and `.background` for color variants)
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
/// # Extending variable tokens (extending theme)
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
/// If you're using default theme (or any other theme defined via protocol)
/// You can always override tokens. It works the same way as extending, just use the name of the existing token:
/// ```swift
/// extension Theme.Padding {
///     static let regular = Self.value(10) // default value was 8
/// }
/// ```
///
/// # Extending theme with new variables
/// You can add new variables to the theme by extending it:
/// ```swift
/// struct ElementSize {
///     var value: CGSize = .zero
///
///     static let small = Self(value: .init(width: 10, height: 4))
///     static let regular = Self(value: .init(width: 12, height: 6))
///     static let large = Self(value: .init(width: 14, height: 8))
/// }
///
/// public extension Theme {
///     let elementSize = ElementSize()
/// }
///
///
/// // Then use it:
/// let buttonSize = Theme.default.elementSize.small
/// ```
public struct Theme: ThemeConfiguration {
    /// Main access point to all theme values
    public static let `default` = Theme()
    
    private init() {}
    
    /// # Color
    /// Values used to define UI element padding
    ///
    /// ## Example
    /// ```swift
    /// let foreground = Theme.default.color(.primary)
    /// let background = Theme.default.color(.primary.variant(.background))
    /// ```
    ///
    /// # Override or Extend Color or Color Variant
    /// You can read how to override or extend colors at ``Theme/Color-swift.struct`` documentation page
    public let color = Color.primary
	
	/// # Gradient
	/// Gradient values accessible via modifiers
	/// It uses ``DynamicGradient``
	///
	/// ## Example
	/// ```swift
	/// View.foundation(.backgroundGradient(.customGradient))
	/// View.foundation(.foregroundGradient(.customGradient))
	/// View.foundation(.borderGradient(.customGradient))
	///	```
	///
	/// Since it conforms to `ShapeStyle`, it could be also used without FoundationUI modifiers:
	/// ```swift
	/// View.background(Theme.gradient.customGradient)
	/// View.foregroundStyle(Theme.gradient.customGradient)
	/// ```
	public let gradient = Gradient()
    
    /// # Padding
    /// Padding values
    ///
    /// ## Example
    /// ```swift
    /// View.foundation(.padding(.regular))
    ///
    /// let value = Theme.default.padding(.regular)
    /// ```
    public let padding = Padding()
    
    /// # Radius
    /// Radius values
    ///
    /// ## Example
    /// ```swift
    /// View.foundation(.cornerRadius(.regular))
    ///
    /// let value = Theme.default.radius(.regular)
    /// ```
    public let radius = Radius()
    
    /// # Length
    /// Length values
    ///
    /// ## Example
    /// ```swift
    /// View.foundation(.size(width: .regular, height: .large))
    ///
    /// let value = Theme.default.length(.regular)
    /// ```
	public let length = Length()
	
	/// # Size
	/// Size values
	///
	/// ## Example
	/// ```swift
	/// View.foundation(.size(.customSize))
	/// ```
	public let size = Size()
    
    /// # Spacing
    /// Spacing values
    ///
    /// ## Example
    /// ```swift
    /// HStack(spacing: .foundation(.spacing(.regular))) { ... }
    ///
    /// let value = Theme.default.spacing(.regular)
    /// ```
    public let spacing = Spacing()
    
    public let font = Font()
    public let shadow = Shadow()
}

// MARK: - Extensions

public enum FoundationCGFloatVariables {
    case padding(Theme.Padding)
    case spacing(Theme.Spacing)
    case radius(Theme.Radius)
	case length(Theme.Length)
	case sizeWidth(Theme.Size)
	case sizeHeight(Theme.Size)
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
        case .length(let length):
			Theme.default.length(length)
		case .sizeWidth(let size):
			Theme.default.size(size).cgSize.width
		case .sizeHeight(let size):
			Theme.default.size(size).cgSize.height
        }
    }
}

extension CGSize {
	public static func foundation(_ size: Theme.Size) -> Self {
		Theme.default.size(size).cgSize
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
