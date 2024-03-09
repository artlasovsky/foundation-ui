//
//  ColorComponents.swift
//  
//
//  Created by Art Lasovsky on 07/02/2024.
//

import Foundation
import SwiftUI

public extension TrussUI {
    struct ColorComponents: TrussUIColorComponents {
        public var hue: CGFloat
        public var saturation: CGFloat
        public var brightness: CGFloat
        public var opacity: CGFloat
        
        public func shapeStyle() -> some ShapeStyle {
            color()
        }
        
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat = 1) {
            self.hue = hue.clamp(0, 1)
            self.saturation = saturation.clamp(0, 1)
            self.brightness = brightness.clamp(0, 1)
            self.opacity = opacity.clamp(0, 1)
        }
    }
}

extension TrussUI.ColorComponents {
    /// Extracting the components from SwiftUI.Color
    @available(macOS 14.0, iOS 17.0, *)
    public init(color: Color, colorScheme: TrussUI.ColorScheme) {
        let components = color.rgbaComponents(in: colorScheme)
        self.init(red: components.red, green: components.green, blue: components.blue, opacity: components.opacity)
    }
    
//    @available(macOS, introduced: 12.0, deprecated: 14.0, obsoleted: 14.0, renamed: "init(color:colorScheme:)")
//    /// Unpredictable with Xcode Previews and environment overrides
//    init(color: Color) {
//        let nsColor = NSColor(color).usingColorSpace(.deviceRGB)
//        self.hue = nsColor?.hueComponent ?? 0
//        self.saturation = nsColor?.saturationComponent ?? 0
//        self.brightness = nsColor?.brightnessComponent ?? 0
//        self.opacity = nsColor?.alphaComponent ?? 0
//    }
}

// MARK: - Protocol
public protocol TrussUIColorComponents: Sendable, Hashable, Equatable {
    associatedtype ResolvedShapeStyle: ShapeStyle
    
    var hue: CGFloat { get }
    var saturation: CGFloat { get }
    var brightness: CGFloat { get }
    var opacity: CGFloat { get }
    
    init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat)
    
    func shapeStyle() -> ResolvedShapeStyle
    
    func multiply(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat) -> Self
    func set(hue: CGFloat?, saturation: CGFloat?, brightness: CGFloat?, opacity: CGFloat?) -> Self
}

public extension TrussUIColorComponents {
    static func == (lhs: Self, rhs: any TrussUIColorComponents) -> Bool {
        lhs.hue == rhs.hue &&
        lhs.saturation == rhs.saturation &&
        lhs.brightness == rhs.brightness &&
        lhs.opacity == rhs.opacity
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(hue)
        hasher.combine(saturation)
        hasher.combine(brightness)
        hasher.combine(opacity)
    }
}
public extension TrussUIColorComponents {
    var isSaturated: Bool {
        saturation > 0
    }
}

public extension TrussUIColorComponents {
    init(grayscale: CGFloat) {
        self.init(hue: 0, saturation: 0, brightness: grayscale, opacity: 1)
    }
    init<C: TrussUIColorComponents>(_ colorComponents: C) {
        self.init(
            hue: colorComponents.hue,
            saturation: colorComponents.saturation,
            brightness: colorComponents.brightness,
            opacity: colorComponents.opacity
        )
    }
}

public extension TrussUIColorComponents {
    func color() -> Color {
        Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
    }
    var description: String {
        [hue, saturation, brightness, opacity].map({ $0.description }).joined(separator: ", ")
    }
}

public extension TrussUIColorComponents {
    func multiply(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, opacity: CGFloat = 1) -> Self {
        .init(
            hue: self.hue * hue,
            saturation: self.saturation * saturation,
            brightness: self.brightness * brightness,
            opacity: self.opacity * opacity
        )
    }
    
    func set(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, opacity: CGFloat? = nil) -> Self {
        .init(
            hue: hue ?? self.hue,
            saturation: saturation ?? self.saturation,
            brightness: brightness ?? self.brightness,
            opacity: opacity ?? self.opacity
        )
    }
}

public extension TrussUIColorComponents {
    func opacity(_ opacity: CGFloat) -> Self {
        multiply(opacity: opacity)
    }
    func hue(_ hue: CGFloat) -> Self {
        multiply(hue: hue)
    }
    func saturation(_ saturation: CGFloat) -> Self {
        multiply(saturation: saturation)
    }
    func brightness(_ brightness: CGFloat) -> Self {
        multiply(brightness: brightness)
    }
}

public extension TrussUIColorComponents {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat = 1) {
        #if os(macOS)
        var nsColor = NSColor(
            red: red.clamp(0, 1),
            green: green.clamp(0, 1),
            blue: blue.clamp(0, 1),
            alpha: opacity.clamp(0, 1)
        )
        nsColor = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
        self.init(
            hue: nsColor.hueComponent,
            saturation: nsColor.saturationComponent,
            brightness: nsColor.brightnessComponent,
            opacity: nsColor.alphaComponent
        )
        #elseif os(iOS)
        var uiColor = UIColor(
            red: red.clamp(0, 1),
            green: green.clamp(0, 1),
            blue: blue.clamp(0, 1),
            alpha: opacity.clamp(0, 1)
        )
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.init(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            opacity: alpha
        )
        #endif
    }
}

internal extension TrussUIColorComponents {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if os(macOS)
        let nsColor = NSColor(.init(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)).usingColorSpace(.deviceRGB)
        return (
            nsColor?.redComponent ?? 0,
            nsColor?.blueComponent ?? 0,
            nsColor?.greenComponent ?? 0,
            nsColor?.alphaComponent ?? 0
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
    var red: CGFloat { rgba.red }
    var green: CGFloat { rgba.green }
    var blue: CGFloat { rgba.blue }
}

// MARK: Internal Extensions
internal extension CGFloat {
    func clamp(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        CGFloat.maximum(min, .minimum(max, self))
    }
}

internal extension Color {
    @available(macOS 14.0, iOS 17.0, *)
    func rgbaComponents(in scheme: TrussUI.ColorScheme) -> (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
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

// MARK: - Swatch
internal extension CGFloat {
    func eightBitValue() -> Int {
        let roundingRule = FloatingPointRoundingRule.toNearestOrEven
        return Int((self * 255).rounded(roundingRule))
    }
    func eightBitValueString() -> String {
        return String(eightBitValue())
    }
    func twoFloatValue() -> String {
        String(format: "%.2f", self)
    }
    func toHexValue() -> String {
        String(format:"%02X", eightBitValue())
    }
}

internal extension TrussUIColorComponents {
    func hex() -> String {
        [
            red.toHexValue(),
            green.toHexValue(),
            blue.toHexValue(),
            opacity.toHexValue()
        ].joined()
    }
}

private extension TrussUI.Variable.Font {
    static let swatch = Self(.system(size: 8).monospacedDigit())
}

public extension TrussUIColorComponents {
    func swatch(_ mode: SwatchColorModel? = nil) -> some View {
        HStack {
            TrussUI.Shape.roundedSquare(.regular, size: .regular.offset(.half.down))
                .foregroundStyle(self.shapeStyle())
            if let mode {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        VStack(alignment: .leading, spacing: 0) {
                            switch mode {
                            case .hsb:
                                Text("H")
                                Text("S")
                                Text("B")
                                Text("A")
                            case .rgb, .rgb8:
                                Text("R")
                                Text("G")
                                Text("B")
                                Text("A")
                            case .hex:
                                EmptyView()
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            switch mode {
                            case .hsb:
                                Text(hue.twoFloatValue())
                                Text(saturation.twoFloatValue())
                                Text(brightness.twoFloatValue())
                                Text(opacity.twoFloatValue())
                            case .rgb:
                                Text(red.twoFloatValue())
                                Text(green.twoFloatValue())
                                Text(blue.twoFloatValue())
                                Text(opacity.twoFloatValue())
                            case .rgb8:
                                Text(red.eightBitValueString())
                                Text(green.eightBitValueString())
                                Text(blue.eightBitValueString())
                                Text(opacity.eightBitValueString())
                            case .hex:
                                let hex = hex()
                                HStack(spacing: 0) {
                                    Text(hex.prefix(6))
                                    Text(hex.suffix(2)).opacity(0.7)
                                }
                            }
                        }
                    }
                }
                .truss(.font(.swatch))
            }
        }
    }
}

public enum SwatchColorModel: String {
    case hsb
    case rgb
    case rgb8
    case hex
}

struct ColorComponents_Preview: PreviewProvider {
    static var previews: some View {
        let colorSet = TrussUI.ColorSet.primary
        VStack(alignment: .leading) {
            colorSet.light.swatch(.rgb8)
            colorSet.dark.swatch(.hsb)
            colorSet.lightAccessible.swatch(.rgb)
            colorSet.darkAccessible.swatch(.hex)
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
