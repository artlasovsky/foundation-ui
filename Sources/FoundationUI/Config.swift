//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension Color {
    static public func foundation(_ token: FoundationUI.Colors.Token, colorScheme: ColorScheme? = nil, inverse: Bool = false) -> Color {
        token.get(colorScheme, inverse: inverse)
    }
}

extension FoundationUI {
    public struct FoundationColor {
        public let light: Color
        public let dark: Color
        
        private var colorScheme: ColorScheme {
            FoundationUI.shared.colorScheme
        }
        
        public func get(_ colorScheme: ColorScheme? = nil, inverse: Bool = false) -> Color {
            (colorScheme ?? self.colorScheme) == (inverse ? .light : .dark) ? dark : light
        }
    }
    public class Colors {
        public let primary: FoundationColor = .init(light: .black, dark: .white)
        init() {}
        public enum Token {
            case primary
            
            func get(_ colorScheme: ColorScheme? = nil, inverse: Bool = false) -> Color {
                switch self {
                case .primary:
                    return FoundationUIColors.primary.get(colorScheme, inverse: inverse)
                }
            }
        }
    }
    public class Config {
        public let padding: TokenizedValues<CGFloat>
        public let radius: TokenizedValues<CGFloat>
        public let spacing: TokenizedValues<CGFloat>
        public init(
            padding: TokenizedValues<CGFloat> = .init(none: 0, xs: 4, sm: 6, base: 8, lg: 14, xl: 22),
            radius: TokenizedValues<CGFloat> = .init(none: 0, xs: 4, sm: 8, base: 10, lg: 14, xl: 18),
            spacing: TokenizedValues<CGFloat> = .init(none: 0, xs: 2, sm: 4, base: 8, lg: 12, xl: 16)
        ) {
            self.padding = padding
            self.radius = radius
            self.spacing = spacing
        }
    }
}
