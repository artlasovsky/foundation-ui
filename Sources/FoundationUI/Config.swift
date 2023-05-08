//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension Color {
    static public func foundation(_ token: FoundationUI.Colors.Token, _ scale: FoundationUI.Colors.Scale = .fill(), colorScheme: ColorScheme? = nil) -> Color {
        token.get(scale, colorScheme)
    }
}

extension CGFloat {
    mutating func clamp(_ min: Self, _ max: Self) {
        self = self < min ? min : self > max ? max : self
    }
    mutating func offset(_ value: Self) {
        self += value
    }
}

extension FoundationUI {
    public struct ColorSet {
        public let light: NSColor
        public let dark: NSColor
        public typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat)
        public init(universal: RGB, dark: RGB?) {
            let dark = dark ?? universal
            self.light = .init(red: universal.red, green: universal.green, blue: universal.blue, alpha: 1)
            self.dark = .init(red: dark.red, green: dark.green, blue: dark.blue, alpha: 1)
        }
        
        private var colorScheme: ColorScheme {
            FoundationUI.shared.colorScheme
        }
        
        private func get(_ colorScheme: ColorScheme? = nil) -> NSColor {
            let color = (colorScheme ?? self.colorScheme) == .dark ? dark : light
            
            return .init(hue: color.hueComponent, saturation: color.saturationComponent, brightness: color.brightnessComponent, alpha: color.alphaComponent)
        }
        
        public func get(_ scale: FoundationUI.Colors.Scale, _ colorScheme: ColorScheme? = nil) -> Color {
            let color = get(colorScheme)
            let hue = color.hueComponent
            var saturation = color.saturationComponent
            var brightness = color.brightnessComponent
            let opacity = color.alphaComponent
            let brightnessScale = [0.2, 0.3, 0.5, 0.9, 1, 1.1, 1.3, 1.5, 1.6]
//            let brightnessScaleDark = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
            let saturationScale = [1, 1, 1, 1, 1, 1, 0.8, 0.8, 0.8]
            switch scale {
            case .background(let adjust):
                switch adjust {
                case .darker:
                    brightness *= brightnessScale[0]
                case .base:
                    brightness *= brightnessScale[1]
                case .lighter:
                    brightness *= brightnessScale[2]
                }
            case .fill(let adjust):
                switch adjust {
                case .darker:
                    brightness *= brightnessScale[3]
                case .base:
                    brightness *= brightnessScale[4]
                case .lighter:
                    brightness *= brightnessScale[5]
                }
            case .foreground(let adjust):
                switch adjust {
                case .darker:
                    brightness *= brightnessScale[7]
                    saturation *= saturationScale[7]
                case .base:
                    brightness *= brightnessScale[8]
                    saturation *= saturationScale[8]
                case .lighter:
                    brightness *= brightnessScale[9]
                    saturation *= saturationScale[9]
                }
            }
            brightness.clamp(0, 1)
            saturation.clamp(0, 1)
            return .init(
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                opacity: opacity
            )
        }
        
    }
    public class Colors {
        public let primary: ColorSet = .init(universal: (0, 0, 0), dark: (1, 1, 1))
        public let secondary: ColorSet = .init(universal: (0.1, 0.1, 0.1), dark: (0.9, 0.6, 0.6))
        init() {}
        public enum Scale {
            public enum Adjust {
                case lighter
                case base
                case darker
            }
            case background(_ adjust: Adjust = .base)
            case fill(_ adjust: Adjust = .base)
            case foreground(_ adjust: Adjust = .base)
            // https://developer.apple.com/design/human-interface-guidelines/color
        }
        public enum Token {
            // case foreground
            case primary
            case secondary
            
            func get(_ scale: Scale = .fill(), _ colorScheme: ColorScheme? = nil) -> Color {
                switch self {
                case .primary:
                    return FoundationUIColors.primary.get(scale, colorScheme)
                case .secondary:
                    return FoundationUIColors.secondary.get(scale, colorScheme)
                }
            }
        }
    }
}

extension FoundationUI {
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
