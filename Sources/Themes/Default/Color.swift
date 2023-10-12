//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 10/6/23.
//
import Foundation
import SwiftUI

// TODO: Split Default Color theme into separate packaged
// To import modifiers, but not colors

import FoundationUICore

internal extension FoundationUI.Color {
        typealias AdjustStyle = (_ source: HSBA) -> HSBA
        
        private func getComponents(color: Color) -> HSBA? {
            guard let components = NSColor(color).usingColorSpace(.deviceRGB) else { return nil }
            return .init(components.hueComponent, components.saturationComponent, components.brightnessComponent, components.alphaComponent)
        }
        private init(light: HSBA, dark: HSBA) {
            self.init(
                light: .init(hue: light.hue, saturation: light.saturation, brightness: light.brightness, opacity: light.alpha),
                dark: .init(hue: dark.hue, saturation: dark.saturation, brightness: dark.brightness, opacity: dark.alpha)
            )
        }
        private func adjust(light: @escaping AdjustStyle, dark: @escaping AdjustStyle) -> Self {
            guard let lightComponents = getComponents(color: self.light),
                  let darkComponents = getComponents(color: self.dark)
            else { return self }
            return .init(light: light(lightComponents), dark: dark(darkComponents))
        }
}

extension FoundationUI.Color {
    public struct HSBA {
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
                            .foregroundStyle(style.getScale(12))
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
            .background(.theme.primary.background)
            .colorScheme(.light)
            VStack {
                SelectedColor(style: .primary)
                SelectedColor(style: .accent)
            }
            .padding()
            .background(.theme.primary.background)
            .colorScheme(.dark)
        }
    }
}
