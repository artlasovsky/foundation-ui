//
//  ColorScheme.swift
//
//
//  Created by Art Lasovsky on 27/02/2024.
//

import Foundation
import SwiftUI

extension TrussUI {
    public enum ColorScheme: String, Sendable, Hashable {
        case light
        case dark
        case lightAccessible
        case darkAccessible
        
        init(_ environment: EnvironmentValues) {
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
        
        internal var colorScheme: SwiftUI.ColorScheme {
            switch self {
            case .light, .lightAccessible:
                .light
            case .dark, .darkAccessible:
                .dark
            }
        }
        
        internal var colorSchemeContrast: SwiftUI.ColorSchemeContrast {
            switch self {
            case .lightAccessible, .darkAccessible:
                .increased
            case .light, .dark:
                .standard
            }
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
}

internal extension View {
    func _colorScheme(_ colorScheme: TrussUI.ColorScheme) -> some View {
        self
            .environment(\.colorScheme, colorScheme.colorScheme)
            .environment(\._colorSchemeContrast, colorScheme.colorSchemeContrast)
    }
}
