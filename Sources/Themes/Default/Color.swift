//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//
import Foundation
import SwiftUI
#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif

import FoundationUICore

extension Color {
    // TODO: visionOS?
    #if os(iOS)
    init(light: UIColor, lightAccessible: UIColor? = nil, dark: UIColor, darkAccessible: UIColor? = nil) {
        #if os(watchOS)
        // In watchOS, apps typically use a dark background
        // https://developer.apple.com/design/human-interface-guidelines/color
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            return traits.accessibilityContrast == .high ? darkAccessible ?? dark : dark
        }))
        #else
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified:
                return traits.accessibilityContrast == .high ? lightAccessible ?? light : light
                
            case .dark:
                return traits.accessibilityContrast == .high ? darkAccessible ?? dark : dark
                
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \(traits.userInterfaceStyle)")
                return light
            }
        }))
        #endif
    }
    #endif
    #if os(macOS)
    init(light: NSColor, lightAccessible: NSColor? = nil, dark: NSColor, darkAccessible: NSColor? = nil) {
        self.init(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            switch appearance.name {
            case .aqua,
                 .vibrantLight:
                return light
            case .accessibilityHighContrastAqua,
                 .accessibilityHighContrastVibrantLight:
                return lightAccessible ?? light
            case .darkAqua,
                 .vibrantDark:
                return dark
            case .accessibilityHighContrastDarkAqua,
                 .accessibilityHighContrastVibrantDark:
                return darkAccessible ?? dark
            default:
                assertionFailure("Unknown appearance: \(appearance.name)")
                return light
            }
        }))
    }
    #endif
}

internal extension Color {
#if os(macOS)
    init(gray: CGFloat, grayDark: CGFloat? = nil) {
        self.init(
            light: .init(colorSpace: Self.colorSpace, hue: 0, saturation: 0, brightness: gray, alpha: 1),
            dark: .init(colorSpace: Self.colorSpace, hue: 0, saturation: 0, brightness: grayDark ?? gray, alpha: 1)
        )
    }
    init(light: HSBA, dark: HSBA?) {
        let dark = dark ?? light
        self.init(light: .init(colorSpace: Self.colorSpace, hue: light.h, saturation: light.s, brightness: light.b, alpha: light.a),
                  dark: .init(colorSpace: Self.colorSpace, hue: dark.h, saturation: dark.s, brightness: dark.b, alpha: dark.a))
    }
    
    private var nsColor: NSColor {
        NSColor(self)
    }
    static var colorSpace: NSColorSpace { .displayP3 }
    private var colorUsingColorSpace: NSColor? {
        nsColor.usingColorSpace(Self.colorSpace)
    }
    private var colorNameComponent: NSColor.Name {
        nsColor.colorNameComponent
    }
    private var isSaturated: Bool {
        colorUsingColorSpace?.saturationComponent ?? 0 > 0
    }
    
    private func getComponents() -> HSBA {
        var h: CGFloat = 0,
            s: CGFloat = 0,
            b: CGFloat = 0,
            a: CGFloat = 0
        
        colorUsingColorSpace?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    private func settingComponents(
        light: OptionalHSBA,
        lightAccessible: OptionalHSBA? = nil,
        dark: OptionalHSBA,
        darkAccessible: OptionalHSBA? = nil
    ) -> Color {
        .init(NSColor(name: colorNameComponent, dynamicProvider: { appearance in
            var (h, s, b, a) = getComponents()
            switch appearance.name {
            case .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
                let lightAccessible = lightAccessible ?? light
                h = lightAccessible.h ?? h
                s = lightAccessible.s ?? s
                b = lightAccessible.b ?? b
                a = lightAccessible.a ?? a
            case .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                let darkAccessible = darkAccessible ?? dark
                h = darkAccessible.h ?? h
                s = darkAccessible.s ?? s
                b = darkAccessible.b ?? b
                a = darkAccessible.a ?? a
            case .darkAqua, .vibrantDark:
                h = dark.h ?? h
                s = dark.s ?? s
                b = dark.b ?? b
                a = dark.a ?? a
            default:
                h = light.h ?? h
                s = light.s ?? s
                b = light.b ?? b
                a = light.a ?? a
            }
            return .init(colorSpace: Self.colorSpace,
                         hue: clamp(h),
                         saturation: clamp(s),
                         brightness: clamp(b),
                         alpha: clamp(a))
        }))
    }
    private func adjustingComponents(
        light: HSBA,
        lightAccessible: HSBA? = nil,
        dark: HSBA,
        darkAccessible: HSBA? = nil
    ) -> Color {
        .init(NSColor(name: colorNameComponent, dynamicProvider: { appearance in
            var (h, s, b, a) = getComponents()
            switch appearance.name {
            case .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
                let lightAccessible = lightAccessible ?? light
                h *= lightAccessible.h
                s *= lightAccessible.s
                b *= lightAccessible.b
                a *= lightAccessible.a
            case .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                let darkAccessible = darkAccessible ?? dark
                h *= darkAccessible.h
                s *= darkAccessible.s
                b *= darkAccessible.b
                a *= darkAccessible.a
            case .darkAqua, .vibrantDark:
                h *= dark.h
                s *= dark.s
                b *= dark.b
                a *= dark.a
            default:
                h *= light.h
                s *= light.s
                b *= light.b
                a *= light.a
                
            }
            return .init(colorSpace: Self.colorSpace,
                         hue: clamp(h),
                         saturation: clamp(s),
                         brightness: clamp(b),
                         alpha: clamp(a))
        }))
    }
#elseif os(iOS)
    init(gray: CGFloat, grayDark: CGFloat? = nil) {
        self.init(
            light: .init(hue: 0, saturation: 0, brightness: gray, alpha: 1),
            dark: .init(hue: 0, saturation: 0, brightness: grayDark ?? gray, alpha: 1)
        )
    }
    init(light: HSBA, dark: HSBA?) {
        let dark = dark ?? light
        self.init(
            light: .init(hue: light.h, saturation: light.s, brightness: light.b, alpha: light.a),
            dark: .init(hue: dark.h, saturation: dark.s, brightness: dark.b, alpha: dark.a)
        )
    }
    private var uiColor: UIColor {
        UIColor(self)
    }
    private func getComponents() -> HSBA {
        var h: CGFloat = 0,
            s: CGFloat = 0,
            b: CGFloat = 0,
            a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    private var isSaturated: Bool {
        getComponents().s > 0
    }
    
    private func adjustingComponents(
        light: HSBA,
        lightAccessible: HSBA? = nil,
        dark: HSBA,
        darkAccessible: HSBA? = nil
    ) -> Color {
        .init(uiColor: .init(dynamicProvider: { trait in
            var (h, s, b, a) = getComponents()
            switch trait.userInterfaceStyle {
            case .dark:
                switch trait.accessibilityContrast {
                case .high:
                    let darkAccessible = darkAccessible ?? dark
                    h *= darkAccessible.h
                    s *= darkAccessible.s
                    b *= darkAccessible.b
                    a *= darkAccessible.a
                default:
                    h *= dark.h
                    s *= dark.s
                    b *= dark.b
                    a *= dark.a
                }
            default:
                switch trait.accessibilityContrast {
                case .high:
                    let lightAccessible = lightAccessible ?? light
                    h *= lightAccessible.h
                    s *= lightAccessible.s
                    b *= lightAccessible.b
                    a *= lightAccessible.a
                default:
                    h *= light.h
                    s *= light.s
                    b *= light.b
                    a *= light.a
                }
            }
            return .init(hue: clamp(h),
                         saturation: clamp(s),
                         brightness: clamp(b),
                         alpha: clamp(a))
        }))
    }
    private func settingComponents(
        light: OptionalHSBA,
        lightAccessible: OptionalHSBA? = nil,
        dark: OptionalHSBA,
        darkAccessible: OptionalHSBA? = nil
    ) -> Color {
        .init(uiColor: .init(dynamicProvider: { trait in
            var (h, s, b, a) = getComponents()
            switch trait.userInterfaceStyle {
            case .dark:
                switch trait.accessibilityContrast {
                case .high:
                    let darkAccessible = darkAccessible ?? dark
                    h = darkAccessible.h ?? h
                    s = darkAccessible.s ?? s
                    b = darkAccessible.b ?? b
                    a = darkAccessible.a ?? a
                default:
                    h = dark.h ?? h
                    s = dark.s ?? s
                    b = dark.b ?? b
                    a = dark.a ?? a
                }
            default:
                switch trait.accessibilityContrast {
                case .high:
                    let lightAccessible = lightAccessible ?? light
                    h = lightAccessible.h ?? h
                    s = lightAccessible.s ?? s
                    b = lightAccessible.b ?? b
                    a = lightAccessible.a ?? a
                default:
                    h = light.h ?? h
                    s = light.s ?? s
                    b = light.b ?? b
                    a = light.a ?? a
                }
            }
            return .init(hue: clamp(h),
                         saturation: clamp(s),
                         brightness: clamp(b),
                         alpha: clamp(a))
        }))
    }
#endif
}


internal extension Color {
    
    
    private func swatch(_ index: Int, transparent: Bool = false) -> Self {
        (transparent ? transparentScale : baseScale)[index] ?? self
    }
    
    var baseScale: [Int: Self] {
        return [
            1:  self
                .adjustingSaturation(light: 0.1, dark: 0.35)
                .adjustingBrightness(light: 2.25, dark: 0.2),
            2:  self
                .adjustingSaturation(light: 0.2, dark: 0.45)
                .adjustingBrightness(light: 2.1, dark: 0.25),
            3:  self
                .adjustingSaturation(light: 0.3, dark: 0.5)
                .adjustingBrightness(light: 1.9, dark: 0.32),
            4:  self
                .adjustingSaturation(light: 0.4, dark: 0.6)
                .adjustingBrightness(light: 1.8, dark: 0.45),
            5:  self
                .adjustingSaturation(light: 0.5, dark: 0.7)
                .adjustingBrightness(light: 1.7, dark: 0.55),
            6:  self
                .adjustingSaturation(light: 0.7, dark: 0.75)
                .adjustingBrightness(light: 1.5, dark: 0.7),
            7:  self
                .adjustingSaturation(light: 0.8, dark: 0.85)
                .adjustingBrightness(light: 1.4, dark: 0.8),
            8:  self
                .adjustingSaturation(light: 0.9, dark: 0.9)
                .adjustingBrightness(light: 1.1, dark: 0.9),
            9:  self,
            10: self
                .adjustingSaturation(light: 1.1, dark: 0.95)
                .adjustingBrightness(light: 0.9, dark: 1.1),
            11: self
                .adjustingSaturation(light: 0.9, dark: 0.7)
                .adjustingBrightness(light: 0.76, dark: isSaturated ? 1.8 : 1.5),
            12: self
                .adjustingSaturation(light: 0.95, dark: 0.5)
                .adjustingBrightness(light: 0.35, dark: isSaturated ? 1.9 : 1.7)
        ]
    }
    var transparentScale: [Int: Self] {
        [
            1:  self.settingOpacity(light: 0.1),
            2:  self.settingOpacity(light: 0.1),
            3:  self.settingOpacity(light: 0.1),
            4:  self.settingOpacity(light: 0.1),
            5:  self.settingOpacity(light: 0.1),
            6:  self.settingOpacity(light: 0.1),
            7:  self.settingOpacity(light: 0.1),
            8:  self.settingOpacity(light: 0.1),
            9:  self.settingOpacity(light: 0.1),
            10: self
                .adjustingSaturation(light: 1.55, dark: 0.9)
                .adjustingBrightness(light: isSaturated ? 0.95 : 0.64, dark: 10)
                .settingOpacity(light: 0.8, dark: isSaturated ? 0.9 : 0.6)
                ,
            11: self.scale.textFaded
                .adjustingSaturation(light: 2.1, dark: 1.05)
                .adjustingBrightness(light: isSaturated ? 0.95 : 0.7, dark: isSaturated ? 2 : 2)
                .settingOpacity(light: isSaturated ? 0.75 : 0.85, dark: isSaturated ? 0.95 : 0.8),
            12: self.scale.text
                .adjustingSaturation(light: 3, dark: 1)
                .adjustingBrightness(light: isSaturated ? 0.85 : 0, dark: 2)
                .settingOpacity(light: 0.9, dark: 0.9)
        ]
    }
}

// MARK: Set / Adjust color
private extension Color {
    private func clamp(_ value: CGFloat) -> CGFloat {
        max(0, min(1, value))
    }
    private func adjustingBrightness(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return adjustingComponents(light: (1, 1, light, 1), dark: (1, 1, dark, 1))
    }
    private func adjustingSaturation(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return adjustingComponents(light: (1, light, 1, 1), dark: (1, dark, 1, 1))
    }
    private func settingBrightness(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return settingComponents(light: (nil, nil, light, nil), dark: (nil, nil, dark, nil))
    }
    private func settingOpacity(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return settingComponents(light: (nil, nil, nil, light), dark: (nil, nil, nil, dark))
    }
}

// MARK: Inits
public extension Color {
    typealias HSBA = (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)
    typealias OptionalHSBA = (h: CGFloat?, s: CGFloat?, b: CGFloat?, a: CGFloat?)
}

public extension Color {
    var scale: Scale {
        Scale(color: self, transparent: false)
    }
    var scaleA: Scale {
        Scale(color: self, transparent: true)
    }
    
    struct Scale {
        let color: Color
        let isTransparent: Bool
        init(color: Color, transparent: Bool) {
            self.color = color
            self.isTransparent = transparent
        }
        /// App background
        public var background: Color { color.swatch(1, transparent: isTransparent) }
        /// Subtle background
        public var backgroundEmphasized: Color { color.swatch(2, transparent: isTransparent) }
        /// UI element background
        public var element: Color { color.swatch(3, transparent: isTransparent) }
        /// Hovered UI element background
        public var elementHovered: Color { color.swatch(4, transparent: isTransparent) }
        /// Active / Selected UI element background
        public var elementActive: Color { color.swatch(5, transparent: isTransparent) }
        /// Subtle borders and separators
        public var borderFaded: Color { color.swatch(6, transparent: isTransparent) }
        /// UI element border and focus rings
        public var border: Color { color.swatch(7, transparent: isTransparent) }
        /// Hovered UI element border
        public var borderEmphasized: Color { color.swatch(8, transparent: isTransparent) }
        /// Solid backgrounds
        public var solid: Color { color.swatch(9, transparent: isTransparent) }
        /// Hovered solid backgrounds
        public var solidEmphasized: Color { color.swatch(10, transparent: isTransparent) }
        /// Low-contrast text
        public var textFaded: Color { color.swatch(11, transparent: isTransparent) }
        /// High-contrast text
        public var text: Color { color.swatch(12, transparent: isTransparent) }
    }
}

private struct ColorScalePreviews: View {
    struct Swatch: View {
        let color: Color
        let colorIndex: Int
        var body: some View {
            VStack(spacing: .theme.padding.small) {
                Rectangle()
                    .frame(width: 25, height: 20)
                    .foregroundColor(color.baseScale[colorIndex])
                Rectangle()
                    .frame(width: 25, height: 20)
                    .foregroundColor(color.transparentScale[colorIndex])
            }
        }
    }
    struct ColorScale: View {
        let color: Color
        var body: some View {
            HStack(spacing: .theme.padding.small) {
                ForEach(Array(color.baseScale.keys.sorted()), id: \.self) { index in
                    VStack(spacing: .theme.padding.xSmall) {
                        Text("\(index)")
                        Swatch(color: color, colorIndex: index)
                    }
                }
            }
        }
    }
    
    struct TestScale: View {
        @Environment(\.colorScheme) private var colorScheme
        var body: some View {
            VStack(spacing: .theme.padding.regular) {
                Text(colorScheme == .dark ? "Dark" : "Light")
                    .foregroundStyle(.theme.primary.scale.text)
                ColorScale(color: .theme.primary)
                ColorScale(color: .theme.accent)
                ColorScale(color: .orange)
            }
            .padding()
            .background(Color.init(light: .white, dark: .black))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TestScale().colorScheme(.light)
            TestScale().colorScheme(.dark)
        }
        .padding([.bottom, .horizontal], -1)
        .font(.system(size: 10, design: .monospaced))
        .preferredColorScheme(.light)
        .padding(.vertical, 50)
    }
}

//Text("Hello World")
//                .padding(.horizontal, .theme.padding.large)
//                .padding(.vertical, .theme.padding.regular)
//                .background(Color.theme.accent.scale.backgroundEmphasized)
//                .foregroundStyle(.theme.accent.scaleA.text)
//                .clipShape(RoundedRectangle(cornerRadius: .theme.radius.regular))
//                .padding(.theme.padding.small)
#Preview("Color Scales") {
    ColorScalePreviews()
}
