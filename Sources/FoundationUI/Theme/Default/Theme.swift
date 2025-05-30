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
/// You could use the theme variables via ``SwiftUICore/View/foundation(_:bypass:)`` modifiers.
///
/// Or access them directly:
/// ``` swift
/// let smallPadding = Theme.Padding(.small).value
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
/// ## Extending variable tokens (extending theme)
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
/// ## Overriding variable tokens
/// If you're using default theme (or any other theme defined via protocol)
/// You can always override tokens. It works the same way as extending, just use the name of the existing token:
/// ```swift
/// extension Theme.Padding {
///     static let regular = Self.value(10) // default value was 8
/// }
/// ```
///
/// ## Extending theme with new variables
/// You can add new variables to the theme by extending it:
/// ```swift
///
/// public extension Theme {
/// 	struct ElementSize {
///     	var value: CGSize = .zero
///
///     	static let small = Self(value: .init(width: 10, height: 4))
///     	static let regular = Self(value: .init(width: 12, height: 6))
///     	static let large = Self(value: .init(width: 14, height: 8))
/// 	}
/// }
///
///
/// // Then use it:
/// let buttonSize = Theme.ElementSize.small
/// ```
///
/// # Themes
/// FoundatonUI comes with multiple themes support
///
/// ## Add Theme
/// By extending ``FoundationUI/Theme`` with static value you could add new themes
/// ```swift
/// extension Theme {
///		static let alternative = Self(rawValue: "alternative")
///	}
/// ```
///
/// ## Adjusting variables to handle the theme changes
/// Using the ``FoundationVariableWithValue/themeable(_:)`` method the token value could be adjusted to reflect themes
/// ```swift
///	extension Theme.Padding {
///		static let large = Theme.Padding(8)
///			.themeable { theme in
/// 			switch theme {
/// 	   		case .alternative:
/// 				.value(32) 	// new value for "alternative" theme
/// 	   		default:
/// 				nil 		// default value (8)
/// 	   		}
/// 		}
/// }
/// ```
///
/// ## Setting the theme for the view
/// When using ``SwiftUICore/View/foundation(_:bypass:)`` modifiers, theme will be applied automatically
/// ```swift
///	struct Component: View {
///		var body: some View {
///			Text("Component")
///				.foundation(.padding(.large))
///				.foundation(.theme(.alternative))
///		}
///	}
/// ```
///	When accessing variables directly using ``FoundationVariableWithValue/value-swift.property`` it will always return default theme's value,
///	use ``FoundationVariableWithValue/resolve(theme:colorScheme:)`` to resolve value for the desired theme and color scheme
///	or ``FoundationVariableWithValue/resolve(in:)`` to resolve value using manually passed `EnvironmentValues`
///
/// > Default theme:
/// When the theme is `nil` (default), the initial variable values will be used
public struct Theme: RawRepresentable, Sendable, Equatable {
	public let rawValue: String
	
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

private struct FoundationThemeKey: EnvironmentKey {
	static let defaultValue: Theme? = nil
}

extension EnvironmentValues {
	var foundationTheme: Theme? {
		get { self[FoundationThemeKey.self] }
		set { self[FoundationThemeKey.self] = newValue }
	}
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
	public static func foundation(_ variable: FoundationCGFloatVariables, in environment: EnvironmentValues? = nil) -> Self {
        switch variable {
        case .padding(let padding):
			padding.resolve(in: environment)
        case .spacing(let spacing):
			spacing.resolve(in: environment)
        case .radius(let radius):
			radius.resolve(in: environment)
        case .length(let length):
			length.resolve(in: environment)
		case .sizeWidth(let size):
			size.resolve(in: environment).cgSize.width
		case .sizeHeight(let size):
			size.resolve(in: environment).cgSize.height
        }
    }
}

extension CGSize {
	public static func foundation(_ size: Theme.Size) -> Self {
		size.cgSize
	}
}

extension ShapeStyle where Self == Theme.Color {
    public static func foundation(_ color: Theme.Color) -> Self {
       color
    }
}

@available(macOS 14.0, iOS 17.0, *)
extension Animation {
	public static func foundation(_ animation: Theme.Animation) -> Self {
		animation.value
	}
}

extension Color {
    /// Get ``SwiftUI/Color`` from FoundationUI's theme color variables
    /// - Parameters:
    ///   - color: Theme's color value
    ///   - colorScheme: Color will be resolved in selected color scheme
    /// - Returns: Returns SwiftUI's Color
    public static func foundation(_ color: Theme.Color, in colorScheme: FoundationColorScheme) -> Self {
        color.resolveColor(in: .init(colorScheme: colorScheme))
    }
}

extension Font {
    /// Get font from FoundationUI theme font variables
    /// - Parameter token: Font variable token
    /// - Returns: Returns SwiftUI's font
    public static func foundation(_ token: Theme.Font) -> Self {
		token.value
    }
}
