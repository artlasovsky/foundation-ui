//
//  ColorScheme.swift
//
//
//  Created by Art Lasovsky on 27/02/2024.
//

import Foundation
import SwiftUI

@frozen
public enum FoundationColorScheme: String, Sendable, Hashable {
    case light
    case dark
    case lightAccessible
    case darkAccessible
    
    public init(_ environment: EnvironmentValues) {
        switch (environment.colorScheme, environment.colorSchemeContrast) {
        case (.light, .standard):
            self = .light
        case (.dark, .standard):
            self = .dark
        case (.light, .increased):
            self = .lightAccessible
        case (.dark, .increased):
            self = .darkAccessible
        default:
            self = .light
        }
    }
}

public extension FoundationColorScheme {
    func environmentValues() -> EnvironmentValues {
        .init(colorScheme: self)
    }
    
    #if os(macOS)
    init(appearance: NSAppearance) {
        switch (appearance.name) {
        case .aqua, .vibrantDark:
            self = .light
        case .darkAqua, .vibrantDark:
            self = .dark
        case .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
            self = .lightAccessible
        case .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
            self = .darkAccessible
        default:
            self = .light
        }
    }
    
    func appearance() -> NSAppearance? {
        switch self {
        case .light:
            .init(named: .aqua)
        case .dark:
            .init(named: .darkAqua)
        case .lightAccessible:
            .init(named: .accessibilityHighContrastAqua)
        case .darkAccessible:
            .init(named: .accessibilityHighContrastDarkAqua)
        }
    }
    #elseif os(iOS)
    init(appearance: UITraitCollection) {
        switch (appearance.userInterfaceStyle, appearance.accessibilityContrast) {
        case (.light, .normal):
            self = .light
        case (.dark, .normal):
            self = .dark
        case (.light, .high):
            self = .lightAccessible
        case (.dark, .high):
            self = .darkAccessible
        default:
            self = .light
        }
    }
    func appearance() -> UITraitCollection? {
        switch self {
        case .light:
            .init(traitsFrom: [
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(accessibilityContrast: .normal)
            ])
        case .dark:
            .init(traitsFrom: [
                UITraitCollection(userInterfaceStyle: .dark),
                UITraitCollection(accessibilityContrast: .normal)
            ])
        case .lightAccessible:
            .init(traitsFrom: [
                UITraitCollection(userInterfaceStyle: .light),
                UITraitCollection(accessibilityContrast: .high)
            ])
        case .darkAccessible:
            .init(traitsFrom: [
                UITraitCollection(userInterfaceStyle: .dark),
                UITraitCollection(accessibilityContrast: .high)
            ])
        }
    }
    #endif
}

internal extension FoundationColorScheme {
    var colorScheme: SwiftUI.ColorScheme {
        switch self {
        case .light, .lightAccessible:
            .light
        case .dark, .darkAccessible:
            .dark
        }
    }
    
    var colorSchemeContrast: SwiftUI.ColorSchemeContrast {
        switch self {
        case .lightAccessible, .darkAccessible:
            .increased
        case .light, .dark:
            .standard
        }
    }
}

internal extension EnvironmentValues {
    init(colorScheme: ColorScheme, colorSchemeContrast: ColorSchemeContrast) {
        var env = EnvironmentValues()
        env.colorScheme = colorScheme
        env._colorSchemeContrast = colorSchemeContrast
        self = env
    }
    
    init(colorScheme: FoundationColorScheme) {
        switch colorScheme {
        case .light:
            self.init(colorScheme: .light, colorSchemeContrast: .standard)
        case .dark:
            self.init(colorScheme: .dark, colorSchemeContrast: .standard)
        case .lightAccessible:
            self.init(colorScheme: .light, colorSchemeContrast: .increased)
        case .darkAccessible:
            self.init(colorScheme: .dark, colorSchemeContrast: .increased)
        }
    }
}

internal extension View {
    func _colorScheme(_ colorScheme: FoundationColorScheme) -> some View {
        self
            .environment(\.colorScheme, colorScheme.colorScheme)
            .environment(\._colorSchemeContrast, colorScheme.colorSchemeContrast)
    }
}
