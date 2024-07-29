//
//  _ThemeDefaults.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Configuration

public struct Theme: ThemeConfiguration {
    private static let baseValue: CGFloat = 8
    
    public let color = Color.primary
    
    public let padding = Padding(base: baseValue, multiplier: 2)
    public let radius = Radius(base: baseValue, multiplier: 1.5)
    public let size = Size(base: baseValue * 8, multiplier: 2)
    public let spacing = Spacing(base: baseValue * 1.25, multiplier: 2)
    
    public let font = Font()
    public let shadow = Shadow()
    
    public static let `default` = Theme()
}

#warning("Swatch (views and? values) to use as preview")

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
    public static func foundation(_ color: Theme.Color, in colorScheme: FoundationColorScheme) -> Self {
        Theme.default.color(color).resolveColor(in: .init(colorScheme: colorScheme))
    }
}

extension Font {
    public static func foundation(_ token: Theme.Font) -> Self {
        Theme.default.font(token)
    }
}
