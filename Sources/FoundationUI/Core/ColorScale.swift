//
//  ColorScale.swift
//
//
//  Created by Art Lasovsky on 20/12/2023.
//

import Foundation
import SwiftUI

// MARK: - Tint
public extension FoundationUI {
    struct Tint: Sendable {
        public let light: Color
        public let lightAccessible: Color?
        public let dark: Color
        public let darkAccessible: Color?
        
        public init(light: Color, lightAccessible: Color? = nil, dark: Color, darkAccessible: Color? = nil) {
            self.light = light
            self.lightAccessible = lightAccessible
            self.dark = dark
            self.darkAccessible = darkAccessible
        }
        
        public init(_ universal: Color, accessible: Color? = nil) {
            self.light = universal
            self.lightAccessible = accessible
            self.dark = universal
            self.darkAccessible = accessible
        }
        
        func getColor(scheme: ColorScale.Scheme) -> Color {
            switch scheme {
            case .light:
                return light
            case .lightAccessible:
                return lightAccessible ?? light
            case .dark:
                return dark
            case .darkAccessible:
                return darkAccessible ?? dark
            }
        }
    }
}


// MARK: - Color Scale
public extension FoundationUI {
    struct ColorScale: ShapeStyle {
        public var adjust: Adjust?
        private var overrides = Overrides()
        
        // TODO:
        // vibrant variant – plusBlend
        // transparent variant (here or in the theme?)
        
        init(light: Adjust.Closure? = nil, lightAccessible: Adjust.Closure? = nil, dark: Adjust.Closure? = nil, darkAccessible: Adjust.Closure? = nil) {
            self.adjust = .init(
                light: light,
                lightAccessible: lightAccessible,
                dark: dark,
                darkAccessible: darkAccessible)
        }
        
        /// Create a new ColorScale combining existing ColorScales
        public init(light: ColorScale, lightAccessible: ColorScale? = nil, dark: ColorScale, darkAccessible: ColorScale? = nil) {
            self.overrides.shapeStyle = .init(
                light: light.colorScheme(light.overrides.colorScheme ?? .light),
                lightAccessible: lightAccessible?.colorScheme(lightAccessible?.overrides.colorScheme ?? .light),
                dark: dark.colorScheme(dark.overrides.colorScheme ?? .dark),
                darkAccessible: darkAccessible?.colorScheme(darkAccessible?.overrides.colorScheme ?? .dark)
            )
        }
        
        public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
            let environment = environmentOverride(environment)
            let scheme = Scheme(environment)
            var color: any ShapeStyle = overrides.shapeStyle.resolve(in: scheme) ?? resolveColor(in: environment)
            if let blendMode = overrides.blendMode {
                color = color.blendMode(blendMode)
            }
            return AnyShapeStyle(color)
        }
        
        public func resolveColor(in environment: EnvironmentValues) -> Color {
            let environment = environmentOverride(environment)
            let scheme = Scheme(environment)
            
            let tint = overrides.tint ?? environment.foundationUITint
            var color = overrides.shapeStyle.resolveColor(in: environment) ?? tint.getColor(scheme: scheme)
            color = adjust?.updateColor(color, scheme: scheme) ?? color
            color = overrides.updateColor(color)
            return color
        }
        
        internal func resolveComponents(in environment: EnvironmentValues) -> Components? {
            let environment = environmentOverride(environment)
            return Self.getComponents(color: resolveColor(in: environment))
        }
        
        internal func environmentOverride(_ environment: EnvironmentValues) -> EnvironmentValues {
            var environment = environment
            environment.colorScheme = overrides.colorScheme ?? environment.colorScheme
            return environment
        }
    }
}

// MARK: Overrides

public extension FoundationUI.ColorScale {
    func brightness(_ brightness: CGFloat) -> Self {
        var copy = self
        copy.overrides.brightness = brightness
        return copy
    }
    func hue(_ hue: CGFloat) -> Self {
        var copy = self
        copy.overrides.hue = hue
        return copy
    }
    func saturation(_ saturation: CGFloat) -> Self {
        var copy = self
        copy.overrides.saturation = saturation
        return copy
    }
    func opacity(_ opacity: CGFloat) -> Self {
        var copy = self
        copy.overrides.opacity = opacity
        return copy
    }
    func tint(_ tint: FoundationUI.Tint) -> Self {
        var copy = self
        copy.overrides.tint = tint
        return copy
    }
    
    func tint(color: Color) -> Self {
        var copy = self
        copy.overrides.tint = .init(.init(color))
        return copy
    }
    
    func blendMode(_ blendMode: BlendMode) -> Self {
        var copy = self
        copy.overrides.blendMode = blendMode
        return copy
    }
    
    func colorScheme(_ colorScheme: ColorScheme) -> Self {
        var copy = self
        copy.overrides.colorScheme = colorScheme
        return copy
    }
}

public extension FoundationUI.ColorScale {
    struct Adjust: Sendable {
        internal typealias ColorScale = FoundationUI.ColorScale
        typealias Closure = @Sendable (_ source: Components) -> Components
        let light: Closure?
        let lightAccessible: Closure?
        let dark: Closure?
        let darkAccessible: Closure?
        init(light: Closure?, lightAccessible: Closure? = nil, dark: Closure?, darkAccessible: Closure? = nil) {
            self.light = light
            self.lightAccessible = lightAccessible
            self.dark = dark
            self.darkAccessible = darkAccessible
        }
        
        internal func updateColor(_ color: Color, scheme: ColorScale.Scheme) -> Color {
            guard let components = ColorScale.getComponents(color: color) else {
                print("cannot get components")
                return Color.red
            }
            switch scheme {
            case .light:
                return light?(components).color() ?? color
            case .lightAccessible:
                return lightAccessible?(components).color() ?? color
            case .dark:
                return dark?(components).color() ?? color
            case .darkAccessible:
                return darkAccessible?(components).color() ?? color
            }
        }
    }
}

internal extension FoundationUI.ColorScale {
    enum Scheme {
        case light
        case lightAccessible
        case dark
        case darkAccessible
        
        init(_ environment: EnvironmentValues) {
            let accessibility = (
                contrast: environment.colorSchemeContrast == .increased,
                invertColors: environment.accessibilityInvertColors,
                reduceTransparency: environment.accessibilityReduceTransparency,
                differentiateWithoutColor: environment.accessibilityDifferentiateWithoutColor
            )
            if environment.colorScheme == .light {
                self = accessibility.contrast ? .lightAccessible : .light
            } else {
                self = accessibility.contrast ? .darkAccessible : .dark
            }
        }
    }
    
    struct Overrides {
        var tint: FoundationUI.Tint?
        var hue: CGFloat?
        var saturation: CGFloat?
        var brightness: CGFloat?
        var opacity: CGFloat?
        var colorScheme: ColorScheme?
        var blendMode: BlendMode?
        var shapeStyle = ShapeStyleOverride()
        
        func updateColor(_ color: Color) -> Color {
            guard let components = FoundationUI.ColorScale.getComponents(color: color) else {
                print("Can't get components")
                return .red
            }
            var hue = hue ?? 1
            var saturation = saturation ?? 1
            var brightness = brightness ?? 1
            var alpha = opacity ?? 1
            return components.multiply(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha).color()
        }
        
        struct ShapeStyleOverride {
            typealias Style = any ShapeStyle
            var light: Style?
            var lightAccessible: Style?
            var dark: Style?
            var darkAccessible: Style?
            
            func resolve(in scheme: FoundationUI.ColorScale.Scheme) -> AnyShapeStyle? {
                var shapeStyle: (any ShapeStyle)?
                switch scheme {
                case .light:
                    shapeStyle = light
                case .lightAccessible:
                    shapeStyle = lightAccessible
                case .dark:
                    shapeStyle = dark
                case .darkAccessible:
                    shapeStyle = darkAccessible
                }
                guard let shapeStyle else { return nil }
                return AnyShapeStyle(shapeStyle)
            }
            
            func resolveColor(in environment: EnvironmentValues) -> Color? {
                let scheme = Scheme(environment)
                var shapeStyle: (any ShapeStyle)?
                switch scheme {
                case .light:
                    shapeStyle = light
                case .lightAccessible:
                    shapeStyle = lightAccessible
                case .dark:
                    shapeStyle = dark
                case .darkAccessible:
                    shapeStyle = darkAccessible
                }
                guard let shapeStyle else { return nil }
                return (shapeStyle as? FoundationUI.ColorScale)?.resolveColor(in: environment)
            }
        }
    }
}

extension FoundationUI.ColorScale {
    private static func getComponents(color: Color?) -> Components? {
        #if os(iOS)
        guard let color else { return nil }
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let components = (hueComponent: hue, saturationComponent: saturation, brightnessComponent: brightness, alphaComponent: alpha)
        #endif
        #if os(macOS)
        guard let color, let components = NSColor(color).usingColorSpace(.deviceRGB) else { return nil }
        #endif
        return .init(components.hueComponent, components.saturationComponent, components.brightnessComponent, components.alphaComponent)
    }
    struct Components: Sendable {
        let hue: CGFloat
        let saturation: CGFloat
        let brightness: CGFloat
        let alpha: CGFloat
        
        init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
            self.hue = Self.clamp(hue)
            self.saturation = Self.clamp(saturation)
            self.brightness = Self.clamp(brightness)
            self.alpha = Self.clamp(alpha)
        }
        
        init(_ hue: CGFloat, _ saturation: CGFloat, _ brightness: CGFloat, _ alpha: CGFloat = 1) {
            self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        
        private static func clamp(_ value: CGFloat) -> CGFloat {
            max(0, min(1, value))
        }
        
        func multiply(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1) -> Self {
            .init(self.hue * hue, self.saturation * saturation, self.brightness * brightness, self.alpha * alpha)
        }
        
        func set(hue: CGFloat? = nil, saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> Self {
            .init(hue ?? self.hue, saturation ?? self.saturation, brightness ?? self.brightness, alpha ?? self.alpha)
        }
        
        var isSaturated: Bool {
            saturation > 0
        }
        
        func shapeStyle() -> some ShapeStyle {
            Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
        }
        
        func color() -> Color {
            Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
        }
    }
}

// MARK: EnvironmentValues

private struct FoundationUITintKey: EnvironmentKey {
    static let defaultValue: FoundationUI.Tint = .init(
        light: .init(hue: 0, saturation: 0, brightness: 0.43),
        dark: .init(hue: 0, saturation: 0, brightness: 0.55)
    )
}
private struct FoundationUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}
extension EnvironmentValues {
    var foundationUITint: FoundationUI.Tint {
        get { self[FoundationUITintKey.self] }
        set { self[FoundationUITintKey.self] = newValue }
    }
    var foundationUICornerRadius: CGFloat? {
        get { self[FoundationUICornerRadiusKey.self] }
        set { self[FoundationUICornerRadiusKey.self] = newValue }
    }
}



// MARK: - Previews

internal extension FoundationUI.ColorScale {
    static let colorSchemeSplit: Self = .init(
        light: .fill.tint(color: .red),
        dark: .fill.tint(.accent)
    )
}

struct ColorScaleTestPreview: PreviewProvider {
    static var previews: some View {
        VStack (spacing: 0) {
            Rectangle().frame(width: 100, height: 100)
                .theme().foreground(.colorSchemeSplit.colorScheme(.light))
            Rectangle().frame(width: 100, height: 100)
                .theme().foreground(.background.colorScheme(.light))
            Rectangle().frame(width: 100, height: 100)
                .theme().foreground(.colorSchemeSplit.colorScheme(.dark))
            Rectangle().frame(width: 100, height: 100)
                .theme().foreground(.border.tint(color: .blue).colorScheme(.dark))
        }
        .theme().background()
    }
}
