//
//  TColor.swift
//
//
//  Created by Art Lasovsky on 31/05/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI {
    struct ColorComponents {
        public var hue: CGFloat { CGFloat(_hue) / 360 }
        public var saturation: CGFloat { CGFloat(_saturation) / 100 }
        public var brightness: CGFloat { CGFloat(_brightness) / 100 }
        public var opacity: CGFloat { CGFloat(_opacity) / 100 }
        
        private let _hue: Int
        private let _saturation: Int
        private let _brightness: Int
        private let _opacity: Int
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat = 1) {
            self.init(hue360: .init(hue * 360), saturation: .init(saturation * 100), brightness: .init(brightness * 100), opacity: .init(opacity * 100))
        }
        /// `FoundationUI.ColorComponents(hue360: 3, saturation: 81, brightness: 100)`
        public init(hue360 hue: Int, saturation: Int, brightness: Int, opacity: Int = 100) {
            self._hue = hue
            self._saturation = saturation
            self._brightness = brightness
            self._opacity = opacity
        }
        
        public var color: Color {
            .init(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
        }
    }
}


extension FoundationUI.ColorComponents: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
    }
}

public extension FoundationUI.ColorComponents {
    var isSaturated: Bool {
        saturation > 0
    }
    
    func override(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        .init(hue: hue ?? self.hue, saturation: saturation ?? self.saturation, brightness: brightness ?? self.brightness, opacity: opacity ?? self.opacity)
    }
    
    func multiply(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, opacity: CGFloat = 1) -> Self {
        .init(hue: self.hue * hue, saturation: self.saturation * saturation, brightness: self.brightness * brightness, opacity: self.opacity * opacity)
    }
}

// MARK: - Initializers

public extension FoundationUI.ColorComponents {
    init(grayscale brightness: CGFloat, opacity: CGFloat = 1) {
        self.init(hue: 0, saturation: 0, brightness: brightness, opacity: opacity)
    }
    
    /// Extracting the components from SwiftUI.Color
    @available(macOS 14.0, iOS 17.0, *)
    init(color: Color, colorScheme: FoundationUI.ColorScheme) {
        let components = color.rgbaComponents(in: colorScheme)
        self.init(red: components.red, green: components.green, blue: components.blue, opacity: components.opacity)
    }
}

// MARK: - HEX

public extension FoundationUI.ColorComponents {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        var r, g, b, a: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // RGBA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        
        self = .init(red8bit: Int(r), green: Int(g), blue: Int(b), opacity: Int(a))
    }
}

// MARK: - RGB

public extension FoundationUI.ColorComponents {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat = 1) {
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        
        #if os(macOS)
        
        let nsColor = NSColor(
            calibratedRed: red.clamp(0, 1),
            green: green.clamp(0, 1),
            blue: blue.clamp(0, 1),
            alpha: opacity.clamp(0, 1)
        )
//        nsColor = nsColor.usingColorSpace(.genericRGB) ?? nsColor
        hue = nsColor.hueComponent
        saturation = nsColor.saturationComponent
        brightness = nsColor.brightnessComponent
        alpha = nsColor.alphaComponent
        #elseif os(iOS)
        var uiColor = UIColor(
            red: red.clamp(0, 1),
            green: green.clamp(0, 1),
            blue: blue.clamp(0, 1),
            alpha: opacity.clamp(0, 1)
        )
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        #endif
        
        self.init(
            hue: hue.precise(),
            saturation: saturation.precise(),
            brightness: brightness.precise(),
            opacity: alpha.precise()
        )
    }
    
    init(red8bit red: Int, green: Int, blue: Int, opacity: Int = 255) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, opacity: CGFloat(opacity) / 255)
    }
    
    func rgba() -> (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if os(macOS)
        let nsColor = NSColor(.init(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)).usingColorSpace(.deviceRGB)
        return (
            (nsColor?.redComponent ?? 0).precise(),
            (nsColor?.greenComponent ?? 0).precise(),
            (nsColor?.blueComponent ?? 0).precise(),
            (nsColor?.alphaComponent ?? 0).precise()
        )
        #elseif os(iOS)
        let uiColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
        #endif
    }
    func rgba8() -> (red: Int, green: Int, blue: Int, opacity: Int) {
        let (r, g, b, a) = rgba()
        return (r.to8bit(), g.to8bit(), b.to8bit(), a.to8bit())
    }
}

private extension CGFloat {
    func to8bit() -> Int {
        Int((self * 255).rounded(.toNearestOrEven))
    }
}

// MARK: - NS/UIColor, CGColor

public extension FoundationUI.ColorComponents {
    #if os(macOS)
    func nsColor() -> NSColor {
        .init(colorSpace: .deviceRGB, hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
    }
    #elseif os(iOS)
    func uiColor() -> UIColor {
        .init(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
    }
    #endif
    
    func cgColor() -> CGColor {
        let (red, green, blue, opacity) = rgba()
        return .init(red: red, green: green, blue: blue, alpha: opacity)
    }
}

// MARK: - Protocols

extension FoundationUI.ColorComponents: Equatable, Sendable, Hashable {}

extension FoundationUI.ColorComponents: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        
        H: \(_hue)/360 S: \(_saturation) B: \(_brightness) A: \(_opacity)
        R \(rgba8().red) G \(rgba8().green) B \(rgba8().blue)
        """
    }
}
