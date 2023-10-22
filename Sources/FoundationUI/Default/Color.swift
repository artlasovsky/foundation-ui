//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//

import Foundation
import SwiftUI

// MARK: - Extension
public extension Color {
    typealias foundation = FoundationUI.Color
    typealias theme = Self.foundation
}

public extension ShapeStyle {
    typealias foundation = FoundationUI.Color
    typealias theme = Self.foundation
}
#warning("TODO: Vibrancy (plusBlend) variant based on color scheme")

// MARK: - Color
public extension FoundationUI.Color {
    static var primary: Self {
        .init(light: .init(hue: 0, saturation: 0, brightness: 0.43),
              dark: .init(hue: 0, saturation: 0, brightness: 0.55))
    }
    static var accent: Self { .init(.blue) }
}

internal extension FoundationUI.Color {
    private func getComponents(color: Color?) -> Components? {
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
    private init(
        light: Components,
        lightAccessible: Components? = nil,
        dark: Components,
        darkAccessible: Components? = nil
    ) {
        let light = Color(hue: light.hue, saturation: light.saturation, brightness: light.brightness, opacity: light.alpha)
        let dark = Color(hue: dark.hue, saturation: dark.saturation, brightness: dark.brightness, opacity: dark.alpha)
        func getAccessible(_ components: Components? = nil) -> Color? {
            guard let components else { return nil }
            return .init(hue: components.hue, saturation: components.saturation, brightness: components.brightness, opacity: components.alpha)
        }
        let lightAccessible = getAccessible(lightAccessible)
        let darkAccessible = getAccessible(darkAccessible)
        self.init(light: light, lightAccessible: lightAccessible, dark: dark, darkAccessible: darkAccessible)
    }
    private func adjust(
        light: @escaping (_ source: Components) -> Components,
        lightAccessible: ((_ source: Components?) -> Components)? = nil,
        dark: @escaping (_ source: Components) -> Components,
        darkAccessible: ((_ source: Components?) -> Components)? = nil
    ) -> Self {
        guard let lightComponents = getComponents(color: self.light),
              let darkComponents = getComponents(color: self.dark)
        else { return self }
        return .init(
            light: light(lightComponents),
            lightAccessible: lightAccessible?(getComponents(color: self.lightAccessible)),
            dark: dark(darkComponents),
            darkAccessible: darkAccessible?(getComponents(color: self.darkAccessible))
        )
    }
}

public extension FoundationUI.Color {
    func opacity(_ value: CGFloat) -> Self {
        self.adjust(
            light: { $0.set(alpha: value)},
            dark: { $0.set(alpha: value)})
    }
}

extension FoundationUI.Color {
    public struct Components {
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
    }
}

extension FoundationUI.Color {
    /// App background
    public var backgroundFaded: Self { getScale(0) }
    /// Content background
    public var background: Self { getScale(1) }
    /// Subtle background
    public var backgroundEmphasized: Self { getScale(2) }
    /// UI element background
    public var element: Self { getScale(3) }
    /// Hovered UI element background
    public var elementHovered: Self { getScale(4) }
    /// Active / Selected UI element background
    public var elementActive: Self { getScale(5) }
    /// Subtle borders and separators
    public var borderFaded: Self { getScale(6) }
    /// UI element border and focus rings
    public var border: Self { getScale(7) }
    /// Hovered UI element border
    public var borderEmphasized: Self { getScale(8) }
    /// Solid backgrounds
    public var solid: Self { getScale(9) }
    /// Hovered solid backgrounds
    public var solidEmphasized: Self { getScale(10) }
    /// Low-contrast text
    public var textFaded: Self { getScale(11) }
    /// High-contrast text
    public var text: Self { getScale(12) }
    
    internal func getScale(_ index: Int) -> Self {
        scale[index] ?? self
    }
    
    internal var scale: [Int:Self] {
        [
            0: adjust(
                light: { $0.multiply(saturation: 0.03).set(brightness: $0.isSaturated ? 1 : 0.99) },
                dark: { $0.multiply(saturation: 0.3).set(brightness: $0.isSaturated ? 0.06 : 0.05) }
            ),
            1: adjust(
                light: { $0.multiply( saturation: 0.06, brightness: 2.18 ) },
                dark: { $0.multiply( saturation: 0.35, brightness: 0.2 ) }),
            2: adjust(
                light: { $0.multiply( saturation: 0.2, brightness: 2.1 ) },
                dark: { $0.multiply( saturation: 0.45, brightness: 0.25 ) }
            ),
            3: adjust(
                light: { $0.multiply( saturation: 0.3, brightness: 1.9 ) },
                dark: { $0.multiply( saturation: 0.5, brightness: 0.32 ) }
            ),
            4: adjust(
                light: { $0.multiply( saturation: 0.4, brightness: 1.8 ) },
                dark: { $0.multiply( saturation: 0.6, brightness: 0.45 ) }
            ),
            5: adjust(
                light: { $0.multiply( saturation: 0.5, brightness: 1.7 )},
                dark: { $0.multiply( saturation: 0.7, brightness: 0.55 ) }
            ),
            6: adjust(
                light: { $0.multiply( saturation: 0.7, brightness: 1.5 ) },
                dark: { $0.multiply( saturation: 0.75, brightness: 0.7 ) }
            ),
            7: adjust(
                light: { $0.multiply( saturation: 0.8, brightness: 1.4 ) },
                dark: { $0.multiply( saturation: 0.85, brightness: 0.8 ) }
            ),
            8: adjust(
                light: { $0.multiply(saturation: 0.9, brightness: 1.1 ) },
                dark: { $0.multiply(saturation: 0.9, brightness: 0.9 ) }
            ),
            9: self,
            10: adjust(
                light: { $0.multiply(saturation: 1.1, brightness: 0.9) },
                dark: { $0.multiply(saturation: 0.95, brightness: 1.1) }
            ),
            11: adjust(
                light: { $0.multiply(saturation: 0.9, brightness: 0.76) },
                dark: { $0.multiply(saturation: 0.4, brightness: $0.isSaturated ? 1.2 : 1.5) }
            ),
            12: adjust(
                light: { $0.multiply(saturation: 0.95, brightness: 0.35) },
                dark: { $0.multiply(saturation: 0.2, brightness: $0.isSaturated ? 1.9 : 1.7) }
            )
        ]
    }
}

struct ShapeStylePreview: PreviewProvider {
    struct SelectedColor: View {
        let style: FoundationUI.Color
        
        var body: some View {
            HStack {
                ForEach(Array(style.scale.keys.sorted()), id: \.self) { index in
                    VStack {
                        Text("\(index)")
                            .foregroundStyle(style.text)
                        Rectangle()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(style.getScale(index))
                    }
                }
            }
        }
    }
    static var previews: some View {
        VStack(spacing: 0) {
            VStack {
                SelectedColor(style: .primary)
                SelectedColor(style: .accent)
            }
            .padding()
            .background(.theme.primary.backgroundFaded)
            .colorScheme(.light)
            VStack {
                SelectedColor(style: .primary)
                SelectedColor(style: .accent)
            }
            .padding()
            .background(.theme.primary.backgroundFaded)
            .colorScheme(.dark)
        }
    }
}
