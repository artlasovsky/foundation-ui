//
//  FoundationTheme.swift
//
//
//  Created by Art Lasovsky on 31/08/2024.
//

import Foundation

public protocol FoundationTheme {}

/// Default size scale from `xxSmall` to `xxLarge`
public protocol DefaultFoundationVariableTokenScale {
    static var xxSmall: Self { get }
    static var xSmall: Self { get }
    static var small: Self { get }
    static var regular: Self { get }
    static var large: Self { get }
    static var xLarge: Self { get }
    static var xxLarge: Self { get }
}

/// Protocols contains default values declared in internal variable extensions
/// Internal extensions used for tests
/// While using the package all the defaults need to be added manually

// MARK: - Padding

public extension FoundationTheme {
    /// # Padding
    /// Padding values
    ///
    /// ## Default values:
    /// ```
    /// xxSmall = 1
    /// xSmall  = 2
    /// small   = 4
    /// regular = 8
    /// large   = 16
    /// xLarge  = 32
    /// xxLarge = 64
    /// ```
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Padding: FoundationTheme.Padding {}
    /// ```
    typealias Padding = FoundationThemePadding
}

public protocol FoundationThemePadding: DefaultFoundationVariableTokenScale {}

public extension FoundationThemePadding {
    /// value = 1
    static var xxSmall: Theme.Padding { .xxSmall }
    /// value = 2
    static var xSmall:  Theme.Padding { .xSmall }
    /// value = 4
    static var small:   Theme.Padding { .small }
    /// value = 8
    static var regular: Theme.Padding { .regular }
    /// value = 16
    static var large:   Theme.Padding { .large }
    /// value = 32
    static var xLarge:  Theme.Padding { .xLarge }
    /// value = 64
    static var xxLarge: Theme.Padding { .xxLarge }
}

internal extension Theme.Padding {
    static var xxSmall: Theme.Padding { .init(1) }
    static var xSmall:  Theme.Padding { .init(2) }
    static var small:   Theme.Padding { .init(4) }
    static var regular: Theme.Padding { .init(8) }
    static var large:   Theme.Padding { .init(16) }
    static var xLarge:  Theme.Padding { .init(32) }
    static var xxLarge: Theme.Padding { .init(64) }
}

// MARK: - Radius

public extension FoundationTheme {
    /// # Radius
    /// Radius values
    ///
    /// ## Default values:
    /// ```
    /// xxSmall = 2
    /// xSmall  = 4
    /// small   = 6
    /// regular = 8
    /// large   = 10
    /// xLarge  = 12
    /// xxLarge = 14
    /// ```
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Radius: FoundationTheme.Radius {}
    /// ```
    typealias Radius = FoundationThemeRadius
}

public protocol FoundationThemeRadius: DefaultFoundationVariableTokenScale {}

public extension FoundationThemeRadius {
    /// value = 2
    static var xxSmall: Theme.Radius { .xxSmall }
    /// value = 4
    static var xSmall:  Theme.Radius { .xSmall }
    /// value = 6
    static var small:   Theme.Radius { .small }
    /// value = 8
    static var regular: Theme.Radius { .regular }
    /// value = 10
    static var large:   Theme.Radius { .large }
    /// value = 12
    static var xLarge:  Theme.Radius { .xLarge }
    /// value = 14
    static var xxLarge: Theme.Radius { .xxLarge }
}

internal extension Theme.Radius {
    static var xxSmall: Theme.Radius { .init(2) }
    static var xSmall:  Theme.Radius { .init(4) }
    static var small:   Theme.Radius { .init(6) }
    static var regular: Theme.Radius { .init(8) }
    static var large:   Theme.Radius { .init(10) }
    static var xLarge:  Theme.Radius { .init(12) }
    static var xxLarge: Theme.Radius { .init(14) }
}

// MARK: - Size

public extension FoundationTheme {
    /// # Size
    /// Size values
    ///
    /// ## Default values:
    /// ```
    /// xxSmall = 8
    /// xSmall  = 16
    /// small   = 32
    /// regular = 64
    /// large   = 128
    /// xLarge  = 256
    /// xxLarge = 512
    /// ```
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Size: FoundationTheme.Size {}
    /// ```
    typealias Size = FoundationThemeSize
}

public protocol FoundationThemeSize: DefaultFoundationVariableTokenScale {}

public extension FoundationThemeSize {
    /// value = 8
    static var xxSmall: Theme.Size { .xxSmall }
    /// value = 16
    static var xSmall:  Theme.Size { .xSmall }
    /// value = 32
    static var small:   Theme.Size { .small }
    /// value = 64
    static var regular: Theme.Size { .regular }
    /// value = 128
    static var large:   Theme.Size { .large }
    /// value = 256
    static var xLarge:  Theme.Size { .xLarge }
    /// value = 512
    static var xxLarge: Theme.Size { .xxLarge }
}

internal extension Theme.Size {
    static var xxSmall: Theme.Size { .init(8) }
    static var xSmall:  Theme.Size { .init(16) }
    static var small:   Theme.Size { .init(32) }
    static var regular: Theme.Size { .init(64) }
    static var large:   Theme.Size { .init(128) }
    static var xLarge:  Theme.Size { .init(256) }
    static var xxLarge: Theme.Size { .init(512) }
}

// MARK: - Spacing

public extension FoundationTheme {
    /// # Spacing
    /// Spacing values
    ///
    /// ## Default values:
    /// ```
    /// xxSmall = 1
    /// xSmall  = 2
    /// small   = 4
    /// regular = 8
    /// large   = 16
    /// xLarge  = 32
    /// xxLarge = 64
    /// ```
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Spacing: FoundationTheme.Spacing {}
    /// ```
    typealias Spacing = FoundationThemeSpacing
}

public protocol FoundationThemeSpacing: DefaultFoundationVariableTokenScale {}

public extension FoundationThemeSpacing {
    /// value = 1
    static var xxSmall: Theme.Spacing { .xxSmall }
    /// value = 2
    static var xSmall:  Theme.Spacing { .xSmall }
    /// value = 4
    static var small:   Theme.Spacing { .small }
    /// value = 8
    static var regular: Theme.Spacing { .regular }
    /// value = 16
    static var large:   Theme.Spacing { .large }
    /// value = 32
    static var xLarge:  Theme.Spacing { .xLarge }
    /// value = 64
    static var xxLarge: Theme.Spacing { .xxLarge }
}

internal extension Theme.Spacing {
    static var xxSmall: Theme.Spacing { .init(1) }
    static var xSmall:  Theme.Spacing { .init(2) }
    static var small:   Theme.Spacing { .init(4) }
    static var regular: Theme.Spacing { .init(8) }
    static var large:   Theme.Spacing { .init(16) }
    static var xLarge:  Theme.Spacing { .init(32) }
    static var xxLarge: Theme.Spacing { .init(64) }
}

// MARK: - Shadow

public extension FoundationTheme {
    /// # Shadow
    /// Spacing values
    ///
    /// ## Default values:
    /// ```
    ///
    /// ```
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Shadow: FoundationTheme.Shadow {}
    /// ```
    typealias Shadow = FoundationThemeShadow
}

public protocol FoundationThemeShadow: DefaultFoundationVariableTokenScale {}

public extension FoundationThemeShadow {
    static var xxSmall: Theme.Shadow { .xxSmall }
    static var xSmall:  Theme.Shadow { .xSmall }
    static var small:   Theme.Shadow { .small }
    static var regular: Theme.Shadow { .regular }
    static var large:   Theme.Shadow { .large }
    static var xLarge:  Theme.Shadow { .xLarge }
    static var xxLarge: Theme.Shadow { .xxLarge }
}

internal extension Theme.Shadow {
    #warning("TODO: Test with dark theme, make it darker if needed")
    #warning("TODO: Better shadows")
    #warning("TODO: Documentation - Default values (color and config)")
    private static var color: Theme.Color { .primary.variant(.background).colorScheme(.dark) }
    static var xxSmall: Theme.Shadow { .init(color: color.opacity(0.1), radius: 0.5, y: 0.5) }
    static var xSmall:  Theme.Shadow { .init(color: color.opacity(0.15), radius: 1, spread: -1, y: 1) }
    static var small:   Theme.Shadow { .init(color: color.opacity(0.2), radius: 2, spread: -1.5, y: 1) }
    static var regular: Theme.Shadow { .init(color: color.opacity(0.25), radius: 3, spread: -2, y: 1.2) }
    static var large:   Theme.Shadow { .init(color: color.opacity(0.28), radius: 4, spread: -2, y: 1.4) }
    static var xLarge:  Theme.Shadow { .init(color: color.opacity(0.35), radius: 5, spread: -2.5, y: 1.6) }
    static var xxLarge: Theme.Shadow { .init(color: color.opacity(0.4), radius: 6, spread: -2.5, y: 1.8) }
}

// MARK: - Font

public extension FoundationTheme {
    /// # Font
    /// Font values
    ///
    /// ## Default values:
    /// ```
    /// xxSmall = .footnote
    /// xSmall  = .subheadline
    /// small   = .callout
    /// regular = .body
    /// large   = .title3
    /// xLarge  = .title2
    /// xxLarge = .title
    /// ```
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Font: FoundationTheme.Font {}
    /// ```
    typealias Font = FoundationThemeFont
}

public protocol FoundationThemeFont: DefaultFoundationVariableTokenScale {}

public extension FoundationThemeFont {
    static var xxSmall: Theme.Font { .xxSmall }
    static var xSmall:  Theme.Font { .xSmall }
    static var small:   Theme.Font { .small }
    static var regular: Theme.Font { .regular }
    static var large:   Theme.Font { .large }
    static var xLarge:  Theme.Font { .xLarge }
    static var xxLarge: Theme.Font { .xxLarge }
}

internal extension Theme.Font {
    static var xxSmall: Self { .init(.footnote) }
    static var xSmall: Self { .init(.subheadline) }
    static var small: Self { .init(.callout) }
    static var regular: Self { .init(.body) }
    static var large: Self { .init(.title3) }
    static var xLarge: Self { .init(.title2) }
    static var xxLarge: Self { .init(.title) }
}

// MARK: - Color

public extension FoundationTheme {
    /// # Font
    /// Font values
    ///
    /// ## Default values:
    /// **.primary** - dynamic gray color (light: 0.5 brightness, dark: 0.57 brightness)
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Color: FoundationTheme.Color {}
    /// ```
    typealias Color = FoundationThemeColor
}

public protocol FoundationThemeColor {
    static var primary: Self { get }
}

public extension FoundationThemeColor {
    static var primary: Theme.Color { .primary }
}

public extension Theme.Color {
    /// .primary    // Slightly adjusted (can be overriden)
    /// .black      // 100% black
    /// .white      // 100% white
    
    /// 100% transparent
    static var clear: Self {
        .init(.init(grayscale: 0, opacity: 0))
    }
    
    /// 100% black
    static var black: Self {
        .init(.init(grayscale: 0, opacity: 1))
    }
    
    /// 100% white
    static var white: Self {
        .init(.init(grayscale: 1, opacity: 1))
    }
    
    /// 50% black
    static var gray: Self {
        .init(.init(grayscale: 0.5, opacity: 1))
    }
}

internal extension Theme.Color {
    static var primary: Self {
        .init(
            light: .init(grayscale: 0.5),
            dark: .init(grayscale: 0.57)
        )
    }
    static var blue: Self {
        .init(
            light: .init(red8bit: 0, green: 122, blue: 255),
            dark: .init(red8bit: 10, green: 132, blue: 255)
        )
    }
    static var orange: Self {
        .init(
            light: .init(red8bit: 255, green: 149, blue: 0),
            dark: .init(red8bit: 255, green: 159, blue: 10)
        )
    }
    static var red: Self {
        .init(
            light: .init(red8bit: 255, green: 59, blue: 48),
            dark: .init(red8bit: 255, green: 69, blue: 58)
        )
    }
}

// MARK: - Color Variants

public extension FoundationTheme {
    /// # Color Variants
    /// Dynamic color scale
    ///
    /// ## Default values:
    /// ```
    /// backgroundSubtle
    /// background
    /// backgroundProminent
    /// fillSubtle
    /// fill
    /// fillProminent
    /// borderSubtle
    /// border
    /// borderProminent
    /// solidSubtle
    /// solid           = source color
    /// solidProminent
    /// textSubtle
    /// text
    /// textProminent
    /// ```
    ///
    ///
    /// ## How to use
    /// ```swift
    /// extension Theme.Color.Variant: FoundationTheme.ColorVariant {}
    /// ```
    typealias ColorVariant = FoundationColorDefaultVariant
}

public protocol FoundationColorDefaultVariant {
    static var backgroundSubtle: Self { get }
    static var background: Self { get }
    static var backgroundProminent: Self { get }
    
    static var fillSubtle: Self { get }
    static var fill: Self { get }
    static var fillProminent: Self { get }
    
    static var borderSubtle:Self { get }
    static var border: Self { get }
    static var borderProminent: Self { get }
    
    static var solidSubtle: Self { get }
    static var solid: Self { get }
    static var solidProminent: Self { get }
    
    static var textSubtle: Self { get }
    static var text: Self { get }
    static var textProminent: Self { get }
}

public extension FoundationColorDefaultVariant {
    static var backgroundSubtle:    Theme.Color.Variant { .backgroundSubtle }
    static var background:          Theme.Color.Variant { .background }
    static var backgroundProminent: Theme.Color.Variant { .backgroundProminent }
    
    static var fillSubtle:          Theme.Color.Variant { .fillSubtle }
    static var fill:                Theme.Color.Variant { .fill }
    static var fillProminent:       Theme.Color.Variant { .fillProminent }
    
    static var borderSubtle:        Theme.Color.Variant { .borderSubtle }
    static var border:              Theme.Color.Variant { .border }
    static var borderProminent:     Theme.Color.Variant { .borderProminent }
    
    static var solidSubtle:         Theme.Color.Variant { .solidSubtle }
    static var solid:               Theme.Color.Variant { .solid }
    static var solidProminent:      Theme.Color.Variant { .solidProminent }
    
    static var textSubtle:          Theme.Color.Variant { .textSubtle }
    static var text:                Theme.Color.Variant { .text }
    static var textProminent:       Theme.Color.Variant { .textProminent }
}

internal extension Theme.Color.Variant {
    static var backgroundSubtle: Self {
        .modifiedSource(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.99 : 0.99 }, method: .override)
                .saturation(0.01)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.07 : 0.05 }, method: .override)
                .saturation(0.4)
            }
        )
    }
    static var background: Self {
        .modifiedSource(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.99 : 0.98 }, method: .override)
                .saturation(0.02)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.11 : 0.08 }, method: .override)
                .saturation(0.4)
            }
        )
    }
    static var backgroundProminent: Self {
        .modifiedSource(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.99 : 0.97 }, method: .override)
                .saturation(0.04)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.14 : 0.11 }, method: .override)
                .saturation(0.4)
            }
        )
    }
    static var borderSubtle: Self {
        .modifiedColor(
            light: .dynamic(.border).brightness(1.07).saturation(0.5),
            dark: .dynamic(.border).brightness(0.82).saturation(0.9)
        )
    }
    static var border: Self {
        .modifiedSource(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.9 : 0.86 }, method: .override)
                .saturation(0.1)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.22 : 0.2 }, method: .override)
                .saturation(0.2)
            }
        )
    }
    static var borderProminent: Self {
        .modifiedColor(
            light: .dynamic(.border).brightness(0.9).saturation(1.2),
            dark: .dynamic(.border).brightness(1.5)
        )
    }
    static var fillSubtle: Self {
        .modifiedColor(
            light: .dynamic(.fill).brightness(1.05).saturation(0.7),
            dark: .dynamic(.fill).brightness(0.75).saturation(0.8)
        )
    }
    static var fill: Self {
        .modifiedSource(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.94 : 0.8 }, method: .override)
                .saturation(0.35)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.49 : 0.38 }, method: .override)
                .saturation(0.6)
            }
        )
    }
    static var fillProminent: Self {
        .modifiedColor(
            light: .dynamic(.fill).brightness(0.92).saturation(1.25),
            dark: .dynamic(.fill).brightness(1.3).saturation(1.2)
        )
    }
    
    static var solidSubtle: Self {
        .modifiedColor(
            light: .dynamic(.solid).brightness(1.14).saturation(0.9),
            dark: .dynamic(.solid).brightness(0.8).saturation(1.05)
        )
    }
    static var solid: Self { .init { $0 } }
    static var solidProminent: Self {
        .modifiedColor(
            light: .dynamic(.solid).brightness(0.86).saturation(0.98),
            dark: .dynamic(.solid).brightness(1.2).saturation(0.94)
        )
    }
    
    static var textSubtle: Self {
        .modifiedSource(
            light: {
                $0.brightness(dynamic: { $0.isSaturated ? 0.65 : 0.6 }, method: .override)
                .saturation(0.3)
            },
            dark: {
                $0.brightness(dynamic: { $0.isSaturated ? 0.6 : 0.6 }, method: .override)
                .saturation(0.35)
            }
        )
    }
    
    static var text: Self {
        .modifiedSource(
            light: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.5 : 0.24 }, method: .override)
                .saturation(0.95)
            },
            dark: { $0
                .brightness(dynamic: { $0.isSaturated ? 0.97 : 0.95 }, method: .override)
                .saturation(0.2)
            }
        )
    }
    
    static var textProminent: Self {
        .modifiedColor(
            light: .dynamic(.text).brightness(0.5),
            dark: .dynamic(.text).brightness(1.2)
        )
    }
}
