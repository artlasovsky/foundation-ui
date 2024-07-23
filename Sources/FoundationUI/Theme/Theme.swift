//
//  _ThemeDefaults.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Configuration

extension FoundationUI {
    public struct Theme: ThemeConfiguration {
        public static let baseValue: CGFloat = 8
        
        public let color = Color.primary

        public let padding = Padding(base: baseValue, multiplier: 2)
        public let radius = Radius(base: baseValue, multiplier: 1.5)
        public let size = Size(base: baseValue * 8, multiplier: 2)
        public let spacing = Spacing(base: baseValue * 1.25, multiplier: 2)

        public let font = Font()
        public let shadow = Shadow()
    }
}

extension FoundationUI {
    public static let theme = Theme()
}

public enum FoundationCGFloatVariables {
    case padding(FoundationUI.Theme.Padding)
    case spacing(FoundationUI.Theme.Spacing)
    case radius(FoundationUI.Theme.Radius)
    case size(FoundationUI.Theme.Size)
}

extension CGFloat {
    public static func foundation(_ variable: FoundationCGFloatVariables) -> Self {
        switch variable {
        case .padding(let padding):
            FoundationUI.theme.padding(padding)
        case .spacing(let spacing):
            FoundationUI.theme.spacing(spacing)
        case .radius(let radius):
            FoundationUI.theme.radius(radius)
        case .size(let size):
            FoundationUI.theme.size(size)
        }
    }
}

extension ShapeStyle where Self == FoundationUI.Theme.Color {
    public static func foundation(_ color: FoundationUI.Theme.Color) -> Self {
        FoundationUI.theme.color(color)
    }
}

extension Color {
    public static let foundation = FoundationUI.theme.color
}

extension Font {
    public static func foundation(_ token: FoundationUI.Theme.Font) -> Self {
        FoundationUI.theme.font(token)
    }
}
