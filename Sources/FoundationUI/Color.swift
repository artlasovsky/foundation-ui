import Foundation
import SwiftUI

// MARK: - Color
public protocol FoundationUIColor {
    static var primary: FoundationUI.Config.Color { get }
    static var accent: FoundationUI.Config.Color { get }
}

// MARK: Default implementation
extension FoundationUIColor {
    public static var primary: FoundationUI.Config.Color { .init(hue: 0, saturation: 0, brightness: 0.5) }
    public static var accent: FoundationUI.Config.Color { .init(hue: 0.12, saturation: 1, brightness: 0.5) }
    // Temporary to test
    public static var twBlue: FoundationUI.Config.Color { .init(
        universal: .init(
            .init(hex: "#dbeafe"),
            .init(hex: "#bfdbfe"),
            .init(hex: "#93c5fd"),
            .init(hex: "#60a5fa"),
            .init(hex: "#3b82f6"),
            .init(hex: "#2563eb"),
            .init(hex: "#1d4ed8"),
            .init(hex: "#1e40af"),
            .init(hex: "#1e3a8a")
        ),
        dark: .init(
            .init(hex: "#1e3a8a"),
            .init(hex: "#1e40af"),
            .init(hex: "#1d4ed8"),
            .init(hex: "#2563eb"),
            .init(hex: "#3b82f6"),
            .init(hex: "#60a5fa"),
            .init(hex: "#93c5fd"),
            .init(hex: "#bfdbfe"),
            .init(hex: "#dbeafe")
        )
    )}
}

public enum FoundationUIColorAdjust {
//    case brighter
//    case darker
    case base
    case faded
    case emphasized
}

extension FoundationUI.Config.Color {
    private typealias ScaleSet = (light: [CGFloat], dark: [CGFloat])
    public struct Components {
        let hue: CGFloat
        let saturation: CGFloat
        let brightness: CGFloat
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
            self.hue = hue
            self.saturation = saturation
            self.brightness = brightness
        }
        public init(red: CGFloat, green: CGFloat, blue: CGFloat) {
            let hsb = RGB_to_HSB(r: red, g: green, b: blue)
            hue = hsb.h
            saturation = hsb.s
            brightness = hsb.b
        }
        public init(hex: String) {
            let color = SwiftUI.Color(hex: hex)
            hue = color?.hueComponent ?? 0
            saturation = color?.saturationComponent ?? 0
            brightness = color?.brightnessComponent ?? 0
        }
    }
    public struct ColorScale {
        let _100: Components
        let _200: Components
        let _300: Components
        let _400: Components
        let _500: Components
        let _600: Components
        let _700: Components
        let _800: Components
        let _900: Components
        
        public init(_ _100: Components, _ _200: Components, _ _300: Components, _ _400: Components, _ _500: Components, _ _600: Components, _ _700: Components, _ _800: Components, _ _900: Components) {
            self._100 = _100
            self._200 = _200
            self._300 = _300
            self._400 = _400
            self._500 = _500
            self._600 = _600
            self._700 = _700
            self._800 = _800
            self._900 = _900
        }
        public var brightnessScale: [CGFloat] {
            [_100.brightness, _200.brightness, _300.brightness, _400.brightness, _500.brightness, _600.brightness, _700.brightness, _800.brightness, _900.brightness]
        }
        public var saturationScale: [CGFloat] {
            [_100.saturation, _200.saturation, _300.saturation, _400.saturation, _500.saturation, _600.saturation, _700.saturation, _800.saturation, _900.saturation]
        }
        public var hueScale: [CGFloat] {
            [_100.hue, _200.hue, _300.hue, _400.hue, _500.hue, _600.hue, _700.hue, _800.hue, _900.hue]
        }
    }
}

extension FoundationUI.Config {
    public struct Color: FoundationUIColor {
        private let components: Components?
        private let _hueScale: ScaleSet?
        private let _saturationScale: ScaleSet?
        private let _brightnessScale: ScaleSet?
        private var colorSchemeOverride: ColorScheme?
        private var scaleIndex: Int = 4
        private var inverted: Bool = false
        
        public var value: SwiftUI.Color {
            return .init(hue: hue, saturation: saturation, brightness: brightness)
        }
        private var colorScheme: ColorScheme { colorSchemeOverride ?? FoundationUI.shared.colorScheme }
//        MARK: Color components
        public var hue: CGFloat {
            hueScale[scaleIndex]
        }
        public var saturation: CGFloat {
            saturationScale[scaleIndex]
        }
        public var brightness: CGFloat {
            var brightness = brightnessScale[scaleIndex]
            let saturation = saturationScale[scaleIndex]
            if inverted {
                var invertedBrightness = 1 - brightness
                let contrastRatio = saturation > 0 ? 0.54 : 0.66
                while abs(invertedBrightness - brightness) < contrastRatio {
                    invertedBrightness += 0.05
                }
                brightness = invertedBrightness.clamped(to: 0...1)
            }
            return brightness
        }
//        MARK: Scales
        private enum ScaleSettings {
            static let contrast: CGFloat = 1
            static let fade: CGFloat = 0.11
            static let saturation: CGFloat = 0.8
        }
        private var brightnessScale: [CGFloat] {
            var scale = Array(repeating: CGFloat(0), count: 9)
            if let _brightnessScale {
                scale = colorScheme == .dark ? _brightnessScale.dark : _brightnessScale.light
            }
            if let components {
                if colorScheme == .dark || components.saturation > 0 {
                    scale = Range(0...8).map { index in
                        let x = CGFloat(index) / 8
                        return (1 - pow(1 - x, x * ScaleSettings.contrast)) * (1 - ScaleSettings.fade * 1.05) + ScaleSettings.fade
                    }
                } else {
                    scale = Range(0...8).reversed().map { index in
                        let x = CGFloat(index) / 8
                        return (1 - pow(1 - x, x * ScaleSettings.contrast * 1.4)) * (1 - ScaleSettings.fade * 1.05) + ScaleSettings.fade * 1.4
                    }
                }
            }
            return scale
        }
        private var saturationScale: [CGFloat] {
            var scale = Array(repeating: CGFloat(0), count: 9)
            if let _saturationScale {
                scale = colorScheme == .dark ? _saturationScale.dark : _saturationScale.light
                
            }
            if let components {
                scale = Range(0...8).map { index in
                    let x = CGFloat(index) / 8
                    if components.saturation == 0 {
                        return 0
                    }
                    return 1 * components.saturation - (pow(1 - x, 3)) * 0.3
                }
            }
            return scale
        }
        private var hueScale: [CGFloat] {
            var scale = Array(repeating: CGFloat(0), count: 9)
            if let _hueScale {
                scale = colorScheme == .dark ? _hueScale.dark : _hueScale.light
            }
            if let components {
                scale = scale.map { _ in components.hue }
            }
            return scale
        }
//        MARK: Inits
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
            self.components = .init(
                hue: hue,
                saturation: saturation,
                brightness: brightness
            )
            self._hueScale = nil
            self._saturationScale = nil
            self._brightnessScale = nil
        }
        public init(
            universal: ColorScale,
            dark: ColorScale? = nil
        ) {
            let dark = dark ?? universal
            _hueScale = (light: universal.hueScale, dark: dark.hueScale)
            _saturationScale = (light: universal.saturationScale, dark: dark.saturationScale)
            _brightnessScale = (light: universal.brightnessScale, dark: dark.brightnessScale)
            self.components = nil
        }
//        MARK: Public functions
        public func colorScheme(_ colorScheme: ColorScheme) -> Self {
            var color = self
            color.colorSchemeOverride = colorScheme
            return color
        }
        public func inverted(_ value: Bool = true) -> Self {
            var color = self
            color.inverted = value
            return color
        }
        public var foreground: Self {
            return foreground(.base)
        }
        public func foreground(_ adjust: FoundationUIColorAdjust) -> Self {
            var color = self
            color.scaleIndex = 7
            color.adjustLevel(adjust)
            return color
        }
        public var fill: Self {
            return fill(.base)
        }
        public func fill(_ adjust: FoundationUIColorAdjust) -> Self {
            var color = self
            color.scaleIndex = 4
            color.adjustLevel(adjust)
            return color
        }
        public var background: Self {
            return background(.base)
        }
        public func background(_ adjust: FoundationUIColorAdjust) -> Self {
            var color = self
            color.scaleIndex = 1
            color.adjustLevel(adjust)
            return color
        }
        
//        MARK: Private functions
        private mutating func adjustLevel(_ adjust: FoundationUIColorAdjust) {
            switch adjust {
            case .faded:
                scaleIndex -= 1
            case .emphasized:
                scaleIndex += 1
//            case .brighter:
//                scaleIndex += (colorScheme == .dark ? 1 : -1)
//            case .darker:
//                scaleIndex += (colorScheme == .dark ? -1 : 1)
            case .base:
                break
            }
        }
    }
}


// MARK: - Extensions
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension SwiftUI.Color {
    public init?(hex: String) {
        if let rgba = HEX_to_RGBA(hex: hex) {
            self.init(red: rgba.r, green: rgba.g, blue: rgba.b, opacity: rgba.a)
            return
        }
        return nil
    }
    private var hsb: (h: CGFloat, s: CGFloat, b: CGFloat) {
        guard let r = self.cgColor?.components?[0],
              let g = self.cgColor?.components?[1],
              let b = self.cgColor?.components?[2] else {
            return (0, 0, 0)
        }
        return RGB_to_HSB(r: r, g: g, b: b)
    }
    public var hueComponent: CGFloat {
        self.hsb.h
    }
    public var saturationComponent: CGFloat {
        self.hsb.s
    }
    public var brightnessComponent: CGFloat {
        self.hsb.b
    }
    public var alphaComponent: CGFloat? {
        self.cgColor?.components?[3]
    }
}


// MARK: - Color Math

private func HEX_to_RGBA(hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
    if hex.hasPrefix("#") {
        let start = hex.index(hex.startIndex, offsetBy: 1)
        var hexColor = String(hex[start...])
        if hexColor.count == 3 || hexColor.count == 4 {
            hexColor = Array(hexColor).map({ String($0) + String($0) }).joined()
        }
        if hexColor.count == 6 {
            hexColor += "ff"
        }
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                return (
                    r: CGFloat((hexNumber & 0xff000000) >> 24) / 255,
                    g: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
                    b: CGFloat((hexNumber & 0x0000ff00) >> 8) / 255,
                    a: CGFloat(hexNumber & 0x000000ff) / 255
                )
            }
        }
    }
    return nil
}

private func RGB_to_HSB(r: CGFloat, g: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, b: CGFloat) {
    let x = min(min(r, g), b)
    let v = max(max(r, g), b)
    if v == x {
        return (0, 0, v)
    }
    let f = r == x ? g - b : ((g == x) ? b - r : r - g)
    let i:CGFloat = r == x ? 3 : (g == x ? 5 : 1)
    let h = (i - f / (v - x)) / CGFloat(6)
    let s = (v - x) / v
    return (h, s, v)
}
private func HSB_to_RGB(h: CGFloat, s: CGFloat, b v: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    let h = h * 6
    let i = floor(h)
    var f = h - i
    if f.truncatingRemainder(dividingBy: 2) == 0 {
        f = 1 - f
    }
    let m = v * (1 - s)
    let n = v * (1 - s * f)
    switch i {
    case 6, 0:
        return (v, n, m)
    case 1:
        return (n, v, m)
    case 2:
        return (m, v, n)
    case 3:
        return (m, n, v)
    case 4:
        return (n, m, v)
    case 5:
        return (v, m, n)
    default:
        return (0, 0, 0)
    }
}
