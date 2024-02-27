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
    }
}
