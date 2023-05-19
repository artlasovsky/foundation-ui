import Foundation
import SwiftUI

// MARK: - Color
public protocol FoundationUIColor {
    static var primary: FoundationUI.Config.Color { get }
    static var accent: FoundationUI.Config.Color { get }
}
//
extension FoundationUIColor {
    public static var primary: FoundationUI.Config.Color { .init(hue: 0, saturation: 0, brightness: 0.5) }
    public static var accent: FoundationUI.Config.Color { .init(hue: 0.12, saturation: 1, brightness: 0.5) }
}

public enum FoundationUIColorAdjust {
    case brighter
    case darker
    case base
    case faded
    case emphasized
}
extension FoundationUI.Config {
    public struct Color: FoundationUIColor {
        private let components: Components
        private var scaleIndex: Int = 4
        private var colorSchemeOverride: ColorScheme?
        
        private var colorScheme: ColorScheme { colorSchemeOverride ?? FoundationUI.shared.colorScheme }
        
        public var value: SwiftUI.Color {
            return .init(
                hue: hue,
                saturation: saturation,
                brightness: brightness)
        }
        
        private struct Components {
            let hue: CGFloat
            let saturation: CGFloat
            let brightness: CGFloat
        }
        public var hue: CGFloat {
            components.hue
        }
        public var saturation: CGFloat {
            components.saturation
//            saturationScale[scaleIndex]
        }
        public var brightness: CGFloat {
            var brightness = brightnessScale[scaleIndex]
            if inverted {
                var invertedBrightness = 1 - brightness
                while abs(invertedBrightness - brightness) < 0.66 {
                    invertedBrightness += 0.05
                }
                brightness = invertedBrightness
            }
            return brightness
        }
        private enum ScaleSettings {
            static let contrast: CGFloat = 1
            static let fade: CGFloat = 0.11
            static let saturation: CGFloat = 0.8
        }
        private var brightnessScale: [CGFloat] {
            if colorScheme == .dark || components.saturation > 0 {
                return Range(0...8).map { index in
                    let x = CGFloat(index) / 8
                    return (1 - pow(1 - x, x * ScaleSettings.contrast)) * (1 - ScaleSettings.fade * 1.05) + ScaleSettings.fade
                }
            } else {
                return Range(0...8).reversed().map { index in
                    let x = CGFloat(index) / 8
                    return (1 - pow(1 - x, x * ScaleSettings.contrast * 1.4)) * (1 - ScaleSettings.fade * 1.05) + ScaleSettings.fade * 1.4
                }
            }
        }
        private var saturationScale: [CGFloat] {
            Range(0...8).map { index in
                let x = CGFloat(index) / 8
                return 1 * components.saturation - (pow(1 - x, 3)) * 0.3
            }
        }
        public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
            self.components = .init(
                hue: hue,
                saturation: saturation,
                brightness: brightness
            )
        }
        
        public func colorScheme(_ colorScheme: ColorScheme) -> Self {
            var color = self
            color.colorSchemeOverride = colorScheme
            return color
        }
        
        private mutating func adjustLevel(_ adjust: FoundationUIColorAdjust) {
            switch adjust {
            case .faded:
                scaleIndex -= 1
            case .emphasized:
                scaleIndex += 1
            case .brighter:
                scaleIndex += (colorScheme == .dark ? 1 : -1)
            case .darker:
                scaleIndex += (colorScheme == .dark ? -1 : 1)
            case .base:
                break
            }
        }
        private var inverted: Bool = false
        public func inverted(_ value: Bool = true) -> Self {
            var color = self
            color.inverted = value
            return color
        }
        public func foreground(_ adjust: FoundationUIColorAdjust) -> Self {
            var color = self
            color.scaleIndex = 7
            color.adjustLevel(adjust)
            return color
        }
        public func fill(_ adjust: FoundationUIColorAdjust) -> Self {
            var color = self
            color.scaleIndex = 4
            color.adjustLevel(adjust)
            return color
        }
        public func background(_ adjust: FoundationUIColorAdjust) -> Self {
            var color = self
            color.scaleIndex = 1
            color.adjustLevel(adjust)
            return color
        }
        public var background: Self {
            return background(.base)
        }
        public var fill: Self {
            return fill(.base)
        }
        public var foreground: Self {
            return foreground(.base)
        }
    }
}

// MARK: - Radius
public protocol FoundationUIRadius {
    static var none: FoundationUI.Config.Radius { get }
    static var xs: FoundationUI.Config.Radius { get }
    static var sm: FoundationUI.Config.Radius { get }
    static var base: FoundationUI.Config.Radius { get }
    static var lg: FoundationUI.Config.Radius { get }
    static var xl: FoundationUI.Config.Radius { get }
}
//
extension FoundationUIRadius {
    public static var none: FoundationUI.Config.Radius { .init(0) }
    public static var xs:   FoundationUI.Config.Radius { .init(4) }
    public static var sm:   FoundationUI.Config.Radius { .init(8) }
    public static var base: FoundationUI.Config.Radius { .init(10) }
    public static var lg:   FoundationUI.Config.Radius { .init(14) }
    public static var xl:   FoundationUI.Config.Radius { .init(18) }
}

extension FoundationUI.Config {
    public struct Radius: FoundationUIRadius {
        public var value: CGFloat
        public init(_ value: CGFloat) {
            self.value = value
        }
    }
}

// MARK: - Spacing
public protocol FoundationUISpacing {
    static func custom(_ value: CGFloat) -> FoundationUI.Config.Spacing
    static var none: FoundationUI.Config.Spacing { get }
    static var xs: FoundationUI.Config.Spacing { get }
    static var sm: FoundationUI.Config.Spacing { get }
    static var base: FoundationUI.Config.Spacing { get }
    static var lg: FoundationUI.Config.Spacing { get }
    static var xl: FoundationUI.Config.Spacing { get }
}
//
extension FoundationUISpacing {
    public static func custom(_ value: CGFloat) -> FoundationUI.Config.Spacing { .init(value) }
    public static var none: FoundationUI.Config.Spacing { .init(0) }
    public static var xs:   FoundationUI.Config.Spacing { .init(2) }
    public static var sm:   FoundationUI.Config.Spacing { .init(4) }
    public static var base: FoundationUI.Config.Spacing { .init(8) }
    public static var lg:   FoundationUI.Config.Spacing { .init(12) }
    public static var xl:   FoundationUI.Config.Spacing { .init(16) }
}

extension FoundationUI.Config {
    public struct Spacing: FoundationUISpacing {
        public var value: CGFloat
        public init(_ value: CGFloat) {
            self.value = value
        }
    }
}
extension CGFloat {
    public static func foundation(_ spacing: FoundationUI.Config.Spacing) -> Self {
        spacing.value
    }
}



// MARK: - Previews
struct ThemePreviews: PreviewProvider {
    struct ColorSample: View {
        let label: String
        let color: FoundationUI.Config.Color
        init(color: FoundationUI.Config.Color, label: String = "T") {
            self.label = label
            self.color = color
        }
        var body: some View {
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 50)
                    .foundation(.foreground(color))
                Text(label)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(color.inverted().value)
            }
            .foundation(.nestedRadius)
            .foundation(.padding(.custom(1)))
            .foundation(.background(.primary.background(.brighter)))
        }
    }
    struct ColorSamples: View {
        private let color: FoundationUI.Config.Color
        @Environment(\.colorScheme) private var systemColorScheme
        private let colorSchemeOverride: ColorScheme?
        private var colorScheme: ColorScheme {
            colorSchemeOverride ?? systemColorScheme
        }
        init(color: FoundationUI.Config.Color, colorScheme: ColorScheme? = nil) {
            self.color = color
            self.colorSchemeOverride = colorScheme
        }
        let bgColor: Color = .white
        let textColor: Color = .black
        var body: some View {
            HStack (spacing: .foundation(.sm)) {
                let color = color.colorScheme(colorScheme)
                VStack {
                    if colorScheme == .dark {
                        Text("Dark ").font(.system(.caption, design: .monospaced))
                    } else if colorScheme == .light {
                        Text("Light ").font(.system(.caption, design: .monospaced))
                    }
                }
                ColorSample(color: color.background(.faded))
                ColorSample(color: color.background)
                ColorSample(color: color.background(.emphasized))
                ColorSample(color: color.fill(.faded))
                ColorSample(color: color.fill)
                ColorSample(color: color.fill(.emphasized))
                ColorSample(color: color.foreground(.faded))
                ColorSample(color: color.foreground)
                ColorSample(color: color.foreground(.emphasized))
            }
        }
    }
    struct UISample: View {
        var body: some View {
            HStack (spacing: 0) {
                VStack {
                    Text("Side")
                }
                .frame(maxWidth: 120, maxHeight: .infinity)
                .foundation(.background(.primary.background))
                Rectangle().frame(width: 1)
                    .foundation(.foreground(.primary.background(.darker)))
                VStack (spacing: 0) {
                    Text("Foreground").foundation(.foreground())
                    Text("Foreground Faded").foundation(.foreground(.primary.foreground(.faded)))
                    Text("Fill").foundation(.foreground(.primary.fill))
                    Text("Fill Faded").foundation(.foreground(.primary.fill(.faded)))
                    Text("Link").underline().foundation(.foreground(.accent.foreground))
                    Text("Link").underline().foundation(.foreground())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foundation(.background(.primary.background(.brighter)))
            }.foundation(.foreground(.primary.foreground))
        }
    }
    static var previews: some View {
        VStack (spacing: .foundation(.none)) {
            VStack (alignment: .trailing, spacing: .foundation(.sm)) {
                ColorSamples(color: .primary, colorScheme: .dark)
                ColorSamples(color: .primary, colorScheme: .light)
                ColorSamples(color: .accent)
                ColorSamples(color: .primary)
            }
            .frame(maxWidth: .infinity)
            .foundation(.padding(.custom(.foundation(.sm))))
            .foundation(.background(.primary.background))
            Rectangle().frame(height: 1)
                .foundation(.foreground(.primary.background(.darker)))
            UISample()
        }
        .frame(width: 400, height: 400)
        .modifier(FoundationUI.ColorSchemeObserver())
    }
}
