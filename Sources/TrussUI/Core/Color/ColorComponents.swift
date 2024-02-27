//
//  ColorComponents.swift
//  
//
//  Created by Art Lasovsky on 07/02/2024.
//

import Foundation
import SwiftUI

extension TrussUI {
    public struct ColorComponents: Sendable {
        typealias ColorComponents = Self
        public let hue: CGFloat
        public let saturation: CGFloat
        public let brightness: CGFloat
        public let alpha: CGFloat
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1) {
            self.hue = Self.clamp(hue)
            self.saturation = Self.clamp(saturation)
            self.brightness = Self.clamp(brightness)
            self.alpha = Self.clamp(alpha)
        }
        
        public init(grayscale brightness: CGFloat) {
            self.hue = 0
            self.saturation = 0
            self.brightness = brightness
            self.alpha = 1
        }
        
        public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
            var nsColor = NSColor(
                red: Self.clamp(red),
                green: Self.clamp(green),
                blue: Self.clamp(blue),
                alpha: Self.clamp(alpha)
            )
            nsColor = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
            self.hue = nsColor.hueComponent
            self.saturation = nsColor.saturationComponent
            self.brightness = nsColor.brightnessComponent
            self.alpha = nsColor.alphaComponent
        }
        
        @available(macOS 14.0, *)
        public init(color: Color, colorScheme: TrussUI.ColorScheme) {
            let components = color.rgbaComponents(in: colorScheme)
            self.init(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
        }
        
    //    @available(macOS, introduced: 12.0, deprecated: 14.0, obsoleted: 14.0, renamed: "init(color:colorScheme:)")
    //    init(color: Color) {
    //        Unpredictable with Previews
    //        let nsColor = NSColor(color).usingColorSpace(.deviceRGB)
    //        self.hue = nsColor?.hueComponent ?? 0
    //        self.saturation = nsColor?.saturationComponent ?? 0
    //        self.brightness = nsColor?.brightnessComponent ?? 0
    //        self.alpha = nsColor?.alphaComponent ?? 0
    //    }
        
        
        internal func to8Bit(_ value: CGFloat) -> Int {
            let roundingRule = FloatingPointRoundingRule.toNearestOrEven
            return Int((value * 255).rounded(roundingRule))
        }
        
        private static func clamp(_ value: CGFloat) -> CGFloat {
            max(0, min(1, value))
        }
    }
}

extension TrussUI.ColorComponents: Equatable, Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hue == rhs.hue &&
        lhs.saturation == rhs.saturation &&
        lhs.brightness == rhs.brightness &&
        lhs.alpha == rhs.alpha
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hue)
        hasher.combine(saturation)
        hasher.combine(brightness)
        hasher.combine(alpha)
    }
}

public extension TrussUI.ColorComponents {
    private var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var color = NSColor(color)
        color = color.usingColorSpace(.deviceRGB) ?? color
        return (color.redComponent, color.greenComponent, color.blueComponent)
    }
    
    var red: CGFloat { rgb.red }
    var green: CGFloat { rgb.green }
    var blue: CGFloat { rgb.blue }
    
    
    var color: Color {
        .init(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    var isSaturated: Bool {
        saturation > 0
    }
    
    func multiplied(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1) -> Self {
        .init(hue: self.hue * hue, saturation: self.saturation * saturation, brightness: self.brightness * brightness, alpha: self.alpha * alpha)
    }
    
    func multipliedRGB(red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1) -> Self {
        .init(red: self.red * red, green: self.green * green, blue: self.blue * blue, alpha: self.alpha * alpha)
    }
    
    func set(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> Self {
        .init(hue: hue ?? self.hue, saturation: saturation ?? self.saturation, brightness: brightness ?? self.brightness, alpha: alpha ?? self.alpha)
    }
    
    func setRGB(red: CGFloat? = nil, green: CGFloat? = nil, blue: CGFloat? = nil, alpha: CGFloat? = nil) -> Self {
        .init(red: red ?? self.red, green: green ?? self.green, blue: blue ?? self.blue, alpha: alpha ?? self.alpha)
    }
}

// MARK: - Swatch

public extension TrussUI.ColorComponents {
    @ViewBuilder
    func swatch(showValues: ShowValues? = .none) -> some View {
        Swatch(components: self, showValues: showValues)
    }
    enum ShowValues: Equatable {
        case rgb
        case rgb8bit
        case rgbFloat
        case hsb
    }
    private struct Swatch: View {
        let components: ColorComponents
        let showValues: ShowValues?
        func _8Bit(_ value: CGFloat) -> String {
            "\(components.to8Bit(value))"
        }
        func float(_ value: CGFloat) -> String {
            String(format: "%.2f", value)
        }
        var body: some View {
            HStack {
                TrussUI.Component.roundedRectangle(.regular)
                    .truss(.size(.regular))
                    .foregroundStyle(components.color)
                if [.rgb, .rgb8bit].contains(showValues) {
                    VStack(alignment: .leading) {
                        Text(_8Bit(components.red))
                        Text(_8Bit(components.green))
                        Text(_8Bit(components.blue))
                        Text(_8Bit(components.alpha))
                    }
                }
                if [.rgb, .rgbFloat].contains(showValues) {
                    VStack(alignment: .leading) {
                        Text(float(components.red))
                        Text(float(components.green))
                        Text(float(components.blue))
                        Text(float(components.alpha))
                    }
                }
                if showValues == .hsb {
                    VStack(alignment: .leading) {
                        Text(float(components.hue))
                        Text(float(components.saturation))
                        Text(float(components.brightness))
                        Text(float(components.alpha))
                    }
                }
            }
            .font(.system(size: 10).monospaced())
        }
    }
}

// MARK: - Color Extension

internal extension Color {
    typealias RGBAComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    typealias HSBAComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    @available(macOS 14.0, *)
    func rgbaComponents(in scheme: TrussUI.ColorScheme) -> RGBAComponents {
        var environment: EnvironmentValues
        switch scheme {
        case .light:
            environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        case .dark:
            environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .standard)
        case .lightAccessible:
            environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .increased)
        case .darkAccessible:
            environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .increased)
        }
        let resolved = self.resolve(in: environment)
        return (CGFloat(resolved.red), CGFloat(resolved.green), CGFloat(resolved.blue), CGFloat(resolved.opacity))
    }
}
