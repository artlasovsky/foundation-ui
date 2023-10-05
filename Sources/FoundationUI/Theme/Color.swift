//
//  Color.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI
#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif

extension Color {
    // TODO: visionOS
    #if os(iOS)
    init(light: UIColor, accessibleLight: UIColor? = nil, dark: UIColor, accessibleDark: UIColor? = nil) {
        #if os(watchOS)
        // In watchOS, apps typically use a dark background
        // https://developer.apple.com/design/human-interface-guidelines/color
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            return traits.accessibilityContrast == .high ? accessibleDark ?? dark : dark
        }))
        #else
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified:
                return traits.accessibilityContrast == .high ? accessibleLight ?? light : light
                
            case .dark:
                return traits.accessibilityContrast == .high ? accessibleDark ?? dark : dark
                
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \(traits.userInterfaceStyle)")
                return light
            }
        }))
        #endif
    }
    #endif
    #if os(macOS)
    init(light: NSColor, accessibleLight: NSColor? = nil, dark: NSColor, accessibleDark: NSColor? = nil) {
        self.init(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            switch appearance.name {
            case .aqua,
                 .vibrantLight:
                return light
            case .accessibilityHighContrastAqua,
                 .accessibilityHighContrastVibrantLight:
                return accessibleLight ?? light
            case .darkAqua,
                 .vibrantDark:
                return dark
            case .accessibilityHighContrastDarkAqua,
                 .accessibilityHighContrastVibrantDark:
                return accessibleDark ?? dark
            default:
                assertionFailure("Unknown appearance: \(appearance.name)")
                return light
            }
        }))
    }
    #endif
}

// TODO: Auto scale from Color
// e.g. medium gray -> [0 - V - 12]
// TODO: Transparent variant

//struct SemanticScale {
//    let color: Color
//    
//    var background: Color {
//        color.scale[1]
//    }
//}

enum ScaleKeys: Int {
    case background = 1             // App background
    case backgroundEmphasized = 2   // Subtle background
    case element = 3                // UI element background
    case elementHovered = 4         // Hovered UI element background
    case elementActive = 5          // Active / Selected UI element background
    case borderFaded = 6            // Subtle borders and separators
    case border = 7                 // UI element border and focus rings
    case borderEmphasized = 8       // Hovered UI element border
    case solid = 9                  // Solid backgrounds
    case solidEmphasized = 10       // Hovered solid backgrounds
    case textFaded = 11             // Low-contrast text
    case text = 12                  // High-contrast text
}

extension Color {
    private var nsColor: NSColor {
        NSColor(self)
    }
    
    func semantic(_ key: ScaleKeys) -> Self {
        scale[key.rawValue] ?? self
    }
    
    var scaleTransparent: [Int: Self] {
        [
            1:  self,
            2:  self,
            3:  self,
            4:  self,
            5:  self,
            6:  self,
            7:  self,
            8:  self,
            9:  self,
            10: self,
            11: self.semantic(.textFaded)
                .adjustingSaturation(light: 2.1, dark: 1.05)
                .adjustingBrightness(light: isSaturated ? 0.95 : 0.7, dark: isSaturated ? 2 : 2)
                .settingOpacity(light: isSaturated ? 0.75 : 0.85, dark: isSaturated ? 0.95 : 0.8),
            12: self.semantic(.text)
                .adjustingSaturation(light: 3, dark: 1)
                .adjustingBrightness(light: isSaturated ? 0.85 : 0, dark: 2)
                .settingOpacity(light: 0.9, dark: 0.9)
        ]
    }
    
    private var isSaturated: Bool {
        self.nsColor.usingColorSpace(.displayP3)?.saturationComponent ?? 0 > 0
    }
    
    var scale: [Int: Self] {
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
    typealias HSBA = (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)
    typealias OptionalHSBA = (h: CGFloat?, s: CGFloat?, b: CGFloat?, a: CGFloat?)
    
    private func settingComponents(light: OptionalHSBA, dark: OptionalHSBA) -> Color {
        return Color(NSColor(name: self.nsColor.colorNameComponent, dynamicProvider: { appearance in
            // resolve different cases here
            func clamp(_ value: CGFloat) -> CGFloat {
                max(0, min(1, value))
            }
            var h: CGFloat = 0,
                s: CGFloat = 0,
                b: CGFloat = 0,
                a: CGFloat = 0
            
            self.nsColor.usingColorSpace(.displayP3)?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            switch appearance.name {
            case .aqua, .vibrantLight:
                h = light.h ?? h
                s = light.s ?? s
                b = light.b ?? b
                a = light.a ?? a
            default:
                // dark temp
                h = dark.h ?? h
                s = dark.s ?? s
                b = dark.b ?? b
                a = dark.a ?? a
            }
            return .init(colorSpace: .displayP3,
                         hue: clamp(h),
                         saturation: clamp(s),
                         brightness: clamp(b),
                         alpha: clamp(a))
        }))
    }

    private func adjustingComponents(light: HSBA, dark: HSBA) -> Color {
        return Color(NSColor(name: self.nsColor.colorNameComponent, dynamicProvider: { appearance in
            // resolve different cases here
            func clamp(_ value: CGFloat) -> CGFloat {
                max(0, min(1, value))
            }
            var h: CGFloat = 0,
                s: CGFloat = 0,
                b: CGFloat = 0,
                a: CGFloat = 0
            
            self.nsColor.usingColorSpace(.displayP3)?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            switch appearance.name {
            case .aqua, .vibrantLight:
                h *= light.h
                s *= light.s
                b *= light.b
                a *= light.a
            default:
                // dark temp
                h *= dark.h
                s *= dark.s
                b *= dark.b
                a *= dark.a
            }
            return .init(colorSpace: .displayP3,
                         hue: clamp(h),
                         saturation: clamp(s),
                         brightness: clamp(b),
                         alpha: clamp(a))
        }))
    }
    private func adjustingBrightness(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return self.adjustingComponents(light: (1, 1, light, 1), dark: (1, 1, dark, 1))
    }
    private func adjustingSaturation(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return self.adjustingComponents(light: (1, light, 1, 1), dark: (1, dark, 1, 1))
    }
    private func settingBrightness(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return self.settingComponents(light: (nil, nil, light, nil), dark: (nil, nil, dark, nil))
    }
    private func settingOpacity(light: CGFloat, dark: CGFloat? = nil) -> Color {
        let dark = dark ?? light
        return self.settingComponents(light: (nil, nil, nil, light), dark: (nil, nil, nil, dark))
    }
}

extension Color {
    init(gray: CGFloat, grayDark: CGFloat? = nil) {
        self.init(
            light: .init(colorSpace: .displayP3, hue: 0, saturation: 0, brightness: gray, alpha: 1),
            dark: .init(colorSpace: .displayP3, hue: 0, saturation: 0, brightness: grayDark ?? gray, alpha: 1)
        )
    }
    init(light: HSBA, dark: HSBA?) {
        let dark = dark ?? light
        self.init(light: .init(colorSpace: .displayP3, hue: light.h, saturation: light.s, brightness: light.b, alpha: light.a),
                  dark: .init(colorSpace: .displayP3, hue: dark.h, saturation: dark.s, brightness: dark.b, alpha: dark.a))
    }
}

extension FoundationColor {
    static var secondary: Color {
        .init(gray: 0.43, grayDark: 0.55)
    }
    static var accent: Color {
        .blue
//        .init(light: (0.57, 1, 0.5, 1), dark: (0.57, 1, 0.5, 1))
    }
}


#Preview {
    struct Swatch: View {
        let color: Color
        let colorIndex: Int
        var body: some View {
            VStack(spacing: .theme.padding.small) {
                Rectangle()
                    .frame(width: 40, height: 20)
                    .foregroundColor(color.scale[colorIndex])
                Rectangle()
                    .frame(width: 40, height: 20)
                    .foregroundColor(color.scaleTransparent[colorIndex])
            }
        }
    }
    struct ColorScale: View {
        let color: Color
        var body: some View {
            HStack(spacing: .theme.padding.small) {
                ForEach(Array(color.scale.keys.sorted()), id: \.self) { index in
                    VStack(spacing: .theme.padding.xsmall) {
                        Text("\(index)")
                            .font(.system(size: 10, design: .monospaced))
                        Swatch(color: color, colorIndex: index)
                    }
                }
            }
        }
    }
    
    struct TestScale: View {
        var body: some View {
            VStack(spacing: .theme.padding.regular) {
//                HStack {
//                    Text("Text")
//                        .padding(.theme.padding.small)
//                        .background(Color.theme.secondary.semantic(.background))
//                        .foregroundColor(.theme.secondary.semantic(.text))
//                    Text("Text")
//                        .padding(.theme.padding.small)
//                        .background(Color.theme.secondary.semantic(.background))
//                        .foregroundColor(.theme.secondary.semantic(.textFaded))
//                    Text("Text")
//                        .padding(.theme.padding.small)
//                        .background(Color.theme.accent.semantic(.background))
//                        .foregroundColor(.theme.accent.semantic(.textFaded))
//                }
                ColorScale(color: .theme.secondary)
                ColorScale(color: .theme.accent)
                ColorScale(color: .orange)
            }
            .padding()
            .background(Color.init(light: .white, dark: .black))
        }
    }
    
    return VStack(spacing: 0) {
        TestScale().colorScheme(.light)
        TestScale().colorScheme(.dark)
    }
    .padding(-1)
    .preferredColorScheme(.light)
    .frame(height: 500)
}
