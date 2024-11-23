//
//  TColor.swift
//
//
//  Created by Art Lasovsky on 31/05/2024.
//

import Foundation
import SwiftUI

@frozen
public struct ColorComponents {
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
    /// `ColorComponents(hue360: 3, saturation: 81, brightness: 100)`
    public init(hue360 hue: Int, saturation: Int, brightness: Int, opacity: Int = 100) {
        self._hue = hue
        self._saturation = saturation
        self._brightness = brightness
        self._opacity = opacity
    }
    
    public var color: Color {
        .init(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
    }
    
    private(set) var changes = Changes()
}


extension ColorComponents: ShapeStyle {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
    }
}

public extension ColorComponents {
    var isSaturated: Bool {
        saturation > 0
    }
}

extension ColorComponents {
    public struct Changes: Sendable {
        struct Components {
            var hue: CGFloat?
            var saturation: CGFloat?
            var brightness: CGFloat?
            var opacity: CGFloat?
        }
        var multiply = Components()
        var override = Components()
        
        public init() {}

        func apply(to colorComponents: ColorComponents) -> ColorComponents {
            var colorComponents = colorComponents
            if let overrideHue = override.hue {
                colorComponents = colorComponents.hue(overrideHue, method: .override)
            }
            if let multiplyHue = multiply.hue {
                colorComponents = colorComponents.hue(multiplyHue, method: .multiply)
            }
            if let overrideSaturation = override.saturation {
                colorComponents = colorComponents.saturation(overrideSaturation, method: .override)
            }
            if let multiplySaturation = multiply.saturation {
                colorComponents = colorComponents.saturation(multiplySaturation, method: .multiply)
            }
            if let overrideBrightness = override.brightness {
                colorComponents = colorComponents.brightness(overrideBrightness, method: .override)
            }
            if let multiplyBrightness = multiply.brightness {
                colorComponents = colorComponents.brightness(multiplyBrightness, method: .multiply)
            }
            if let overrideOpacity = override.opacity {
                colorComponents = colorComponents.opacity(overrideOpacity, method: .override)
            }
            if let multiplyOpacity = multiply.opacity {
                colorComponents = colorComponents.opacity(multiplyOpacity, method: .multiply)
            }
            return colorComponents
        }
    }
    
    func multiply(
        hue: ConditionalValue? = nil,
        saturation: ConditionalValue? = nil,
        brightness: ConditionalValue? = nil,
        opacity: ConditionalValue? = nil
    ) -> Self {
        var changes = self.changes
        var hueAdjust = self.hue
        if let hue {
            hueAdjust *= hue(self)
            changes.multiply.hue = (changes.multiply.hue ?? 1) * hueAdjust
        }
        var saturationAdjust = self.saturation
        if let saturation {
            saturationAdjust *= saturation(self)
            changes.multiply.saturation = (changes.multiply.saturation ?? 1) * saturationAdjust
        }
        var brightnessAdjust = self.brightness
        if let brightness {
            brightnessAdjust *= brightness(self)
            changes.multiply.brightness = (changes.multiply.brightness ?? 1) * brightnessAdjust
        }
        var opacityAdjust = self.opacity
        if let opacity {
            opacityAdjust *= opacity(self)
            changes.multiply.opacity = (changes.multiply.opacity ?? 1) * opacityAdjust
        }
        var result = Self(
            hue: hueAdjust,
            saturation: saturationAdjust,
            brightness: brightnessAdjust,
            opacity: opacityAdjust
        )
        
        result.changes = changes
        
        return result
    }
    
    func multiply(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        var hueValue: ConditionalValue? = nil
        var saturationValue: ConditionalValue? = nil
        var brightnessValue: ConditionalValue? = nil
        var opacityValue: ConditionalValue? = nil
        
        if let hue {
            hueValue = { _ in hue }
        }
        if let saturation {
            saturationValue = { _ in saturation }
        }
        if let brightness {
            brightnessValue = { _ in brightness }
        }
        if let opacity {
            opacityValue = { _ in opacity }
        }
        
        return multiply(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, opacity: opacityValue)
    }
    
    func override(hue: ConditionalValue? = nil, saturation: ConditionalValue? = nil, brightness: ConditionalValue? = nil, opacity: ConditionalValue? = nil) -> Self {
        var changes = self.changes
        var hueAdjust = self.hue
        if let hue {
            hueAdjust = hue(self)
            changes.multiply.hue = nil
            changes.override.hue = hueAdjust
        }
        var saturationAdjust = self.saturation
        if let saturation {
            saturationAdjust = saturation(self)
            changes.multiply.saturation = nil
            changes.override.saturation = saturationAdjust
        }
        var brightnessAdjust = self.brightness
        if let brightness {
            brightnessAdjust = brightness(self)
            changes.multiply.brightness = nil
            changes.override.brightness = brightnessAdjust
        }
        var opacityAdjust = self.opacity
        if let opacity {
            opacityAdjust = opacity(self)
            changes.multiply.opacity = nil
            changes.override.opacity = opacityAdjust
        }
        var result = Self(
            hue: hueAdjust,
            saturation: saturationAdjust,
            brightness: brightnessAdjust,
            opacity: opacityAdjust
        )
        
        result.changes = changes
        
        return result
    }
    
    func override(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        var hueValue: ConditionalValue? = nil
        var saturationValue: ConditionalValue? = nil
        var brightnessValue: ConditionalValue? = nil
        var opacityValue: ConditionalValue? = nil
        
        if let hue {
            hueValue = { _ in hue }
        }
        if let saturation {
            saturationValue = { _ in saturation }
        }
        if let brightness {
            brightnessValue = { _ in brightness }
        }
        if let opacity {
            opacityValue = { _ in opacity }
        }
        
        return override(hue: hueValue, saturation: saturationValue, brightness: brightnessValue, opacity: opacityValue)
    }
}

public extension ColorComponents {
    enum AdjustMethod {
        case multiply
        case override
    }
    
    typealias ConditionalValue = (ColorComponents) -> CGFloat
    
    func hue(_ value: CGFloat, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(hue: value)
        case .override: override(hue: value)
        }
    }
    func hue(dynamic value: @escaping ConditionalValue, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(hue: value)
        case .override: override(hue: value)
        }
    }
    
    func saturation(_ value: CGFloat, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(saturation: value)
        case .override: override(saturation: value)
        }
    }
    func saturation(dynamic value: @escaping ConditionalValue, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(saturation: value)
        case .override: override(saturation: value)
        }
    }
    
    func brightness(_ value: CGFloat, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(brightness: value)
        case .override: override(brightness: value)
        }
    }
    
    func brightness(dynamic value: @escaping ConditionalValue, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(brightness: value)
        case .override: override(brightness: value)
        }
    }
    
    func opacity(_ value: CGFloat, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(opacity: value)
        case .override: override(opacity: value)
        }
    }
    
    func opacity(dynamic value: @escaping ConditionalValue, method: AdjustMethod = .multiply) -> Self {
        switch method {
        case .multiply: multiply(opacity: value)
        case .override: override(opacity: value)
        }
    }
}

// MARK: - Initializers

public extension ColorComponents {
    init(grayscale brightness: CGFloat, opacity: CGFloat = 1) {
        self.init(hue: 0, saturation: 0, brightness: brightness, opacity: opacity)
    }
    
    /// Extracting the components from SwiftUI.Color
    init(color: Color, colorScheme: FoundationColorScheme) {
        if #available(macOS 14.0, iOS 17.0, *) {
            var environment: EnvironmentValues
            switch colorScheme {
            case .light:
                environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
            case .dark:
                environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .standard)
            case .lightAccessible:
                environment = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .increased)
            case .darkAccessible:
                environment = EnvironmentValues(colorScheme: .dark, colorSchemeContrast: .increased)
            }
            let resolved = color.resolve(in: environment)
            self.init(
                red: CGFloat(resolved.red),
                green: CGFloat(resolved.green),
                blue: CGFloat(resolved.blue),
                opacity: CGFloat(resolved.opacity)
            )
        } else {
            #if os(macOS)
            self = .init(nsColor: NSColor(color), colorScheme: colorScheme)
            #elseif os(iOS)
            self = .init(uiColor: UIColor(color), colorScheme: colorScheme)
            #endif
        }
    }
	
	static func color(_ color: Color, colorScheme: FoundationColorScheme) -> Self {
		.init(color: color, colorScheme: colorScheme)
	}
    
    #if os(macOS)
    init(nsColor color: NSColor, colorScheme: FoundationColorScheme) {
        var colorComponents = ColorComponents(hue: 0.99, saturation: 0.99, brightness: 0.99, opacity: 0)
        if let nsColor = color.usingColorSpace(.deviceRGB) {
            // TODO: Log error if color wasn't unwrapped
            colorComponents = .init(
                hue: nsColor.hueComponent,
                saturation: nsColor.saturationComponent,
                brightness: nsColor.brightnessComponent,
                opacity: nsColor.alphaComponent
            )
        }
        self = colorComponents
    }
	
	static func nsColor(_ color: NSColor, colorScheme: FoundationColorScheme) -> Self {
		.init(nsColor: color, colorScheme: colorScheme)
	}
    #elseif os(iOS)
    init(uiColor color: UIColor, colorScheme: FoundationColorScheme) {
        var colorComponents = ColorComponents(hue: 0.99, saturation: 0.99, brightness: 0.99, opacity: 0)
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        let appearance = colorScheme.appearance()
        appearance.performAsCurrent {
            color.getHue(
                &hue,
                saturation: &saturation,
                brightness: &brightness,
                alpha: &alpha
            )
        }
        self = .init(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
	
	static func uiColor(_ color: UIColor, colorScheme: FoundationColorScheme) -> Self {
		.init(uiColor: color, colorScheme: colorScheme)
	}
    #endif
}

// MARK: HEX

public extension ColorComponents {
    /// Initializing color components using HEX value
    ///
    /// Supported HEX formats:
    /// - `#D70` – short
    /// - `#D70015` – full
    /// - `#D70015FF` – with alpha value
    /// - `#d70015` – it could be in uppercase or lowercase
    /// - `D70015` – and with or without hash symbol
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
	
	static func hex(_ value: String) -> Self {
		.init(hex: value)
	}
}

// MARK: RGB

public extension ColorComponents {
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
        
        hue = nsColor.hueComponent
        saturation = nsColor.saturationComponent
        brightness = nsColor.brightnessComponent
        alpha = nsColor.alphaComponent
        
        #elseif os(iOS)
        let uiColor = UIColor(
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
		return (
			red.precise(),
			green.precise(),
			blue.precise(),
			alpha.precise()
		)
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

// MARK: - OKLCH

public extension ColorComponents {
	/// Initialize a Color using OKLCH color space coordinates
	/// - Parameters:
	///   - lightness: Lightness component (0 to 1)
	///   - chroma: Chroma component (0 to ~0.4)
	///   - hue: Hue component in degrees (0 to 360)
	///   - opacity: Opacity value (0 to 1)
	static func oklch(lightness: CGFloat, chroma: CGFloat, hue: CGFloat, opacity: CGFloat = 1) -> Self {
		// Convert OKLCH to Oklab
		let hRad = hue * .pi / 180
		let a = chroma * cos(hRad)
		let b = chroma * sin(hRad)

		let (r, g, b_) = OKLCH.oklabToLinearRGB(l: lightness, a: a, b: b)
		let (sR, sG, sB) = OKLCH.linearRGBToSRGB(r: r, g: g, b: b_)
		
		return .init(red: sR, green: sG, blue: sB, opacity: opacity)
	}
	
	public func oklch() -> (lightness: Double, chroma: Double, hue: Double) {
		let (r, g, b, _) = rgba()
		let (lR, lG, lB) = OKLCH.sRGBToLinearRGB(r: r, g: g, b: b)
		let (l, a, b_) = OKLCH.linearRGBToOklab(r: lR, g: lG, b: lB)
		let c = sqrt(a * a + b_ * b_)
		let h = atan2(b_, a) * 180 / .pi
		return (l.precise(), c.precise(), (h >= 0 ? h : h + 360).precise(0))
	}
	
}

private struct OKLCH {
	static func sRGBToLinearRGB(r: Double, g: Double, b: Double) -> (r: Double, g: Double, b: Double) {
		let toLinear = { (x: Double) -> Double in
			x <= 0.04045 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4)
		}
		return (toLinear(r), toLinear(g), toLinear(b))
	}
	
	static func linearRGBToSRGB(r: Double, g: Double, b: Double) -> (r: Double, g: Double, b: Double) {
		let toSRGB = { (x: Double) -> Double in
			x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1/2.4) - 0.055
		}
		return (toSRGB(r), toSRGB(g), toSRGB(b))
	}
	
	static func linearRGBToOklab(r: Double, g: Double, b: Double) -> (l: Double, a: Double, b: Double) {
		let l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
		let m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
		let s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
		
		let l_ = pow(l, 1.0/3.0)
		let m_ = pow(m, 1.0/3.0)
		let s_ = pow(s, 1.0/3.0)
		
		return (
			0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
			1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
			0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
		)
	}
	
	static func oklabToLinearRGB(l: Double, a: Double, b: Double) -> (r: Double, g: Double, b: Double) {
		let l_ = l + 0.3963377774 * a + 0.2158037573 * b
		let m = l - 0.1055613458 * a - 0.0638541728 * b
		let s = l - 0.0894841775 * a - 1.2914855480 * b
		
		let l_cubed = l_ * l_ * l_
		let m_cubed = m * m * m
		let s_cubed = s * s * s
		
		return (
			4.0767416621 * l_cubed - 3.3077115913 * m_cubed + 0.2309699292 * s_cubed,
			-1.2684380046 * l_cubed + 2.6097574011 * m_cubed - 0.3413193965 * s_cubed,
			-0.0041960863 * l_cubed - 0.7034186147 * m_cubed + 1.7076147010 * s_cubed
		)
	}
}

// MARK: - NS/UIColor, CGColor

public extension ColorComponents {
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

extension ColorComponents: Equatable, Sendable, Hashable {
    public static func == (lhs: ColorComponents, rhs: ColorComponents) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hue)
        hasher.combine(saturation)
        hasher.combine(brightness)
        hasher.combine(opacity)
    }
}

extension ColorComponents: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        
        H: \(_hue)/360 S: \(_saturation) B: \(_brightness) A: \(_opacity)
        R \(rgba8().red) G \(rgba8().green) B \(rgba8().blue)
        """
    }
}
