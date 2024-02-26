//
//  ColorVariable.swift
//
//
//  Created by Art Lasovsky on 20/12/2023.
//

import Foundation
import SwiftUI

internal extension Color {
    typealias RGBAComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    typealias HSBAComponents = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    @available(macOS 14.0, *)
    func rgbaComponents(in scheme: TrussUI.ColorScheme) -> RGBAComponents {
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

// MARK: - Preview

//@available(macOS 14.0, *)
//private extension TrussUI.Tint {
//    static let systemRed = TrussUI.Tint(color: .red)
//    static let systemYellow = TrussUI.Tint(lightColor: .yellow)
//    static let redEqual = TrussUI.Tint(
//        light: .init(hue: 0.009, saturation: 0.8125, brightness: 1),
//        dark: .init(red: 255 / 255, green: 59 / 255, blue: 48 / 255),
//        lightAccessible: .init(color: .red, colorScheme: .lightAccessible),
//        darkAccessible: .init(color: .red, colorScheme: .lightAccessible)
//    )
//    static let tintFromTint: TrussUI.Tint = .init(
//        light: TrussUI.Tint.systemRed.light,
//        dark: TrussUI.Tint.systemYellow.dark
//    )
//}
//
//private extension TrussUI.Tint {
//    static let red = TrussUI.Tint(
//        light: .init(hue: 0.01, saturation: 0.81, brightness: 1),
//        dark: .init(hue: 0.01, saturation: 0.77, brightness: 1),
//        lightAccessible: .init(hue: 0.98, saturation: 1, brightness: 0.84),
//        darkAccessible: .init(hue: 0.01, saturation: 0.62, brightness: 1))
//}
//
//private extension TrussUI.ColorVariable {
//    static let swiftUI = TrussUI.ColorVariable(
//        light: { $0 },
//        dark: { $0.setRGB(green: $0.green + 0.04, blue: $0.blue + 0.04) },
//        lightAccessible: { $0.multiplied(saturation: 2, brightness: 0.84) },
//        darkAccessible: { $0.multiplied(saturation: 0.76) }
//    )
//    
//    static let mix = TrussUI.ColorVariable(
//        light: TrussUI.ColorVariable.Scale.solid,
//        dark: TrussUI.ColorVariable.Scale.text.opacity(0.5)
//    )
//    static let overrideMix = Self(
//        light: .Scale.solid.opacity(0.5),
//        dark: .Scale.solid.opacity(0.2).colorScheme(.light)
//    )
//}
//
//struct ColorScaleTestPreview: PreviewProvider {
//    struct ColorComponentsTest: View {
//        var body: some View {
//            VStack {
////                TrussUI.ColorVariable.swiftUI.swatch(showValues: .rgb)
//                HStack {
//                    Text("Nested Overrides: ")
//                    TrussUI.Component.roundedRectangle(.regular)
//                        .truss(.size(.small))
//                        .truss(.foreground(.overrideMix.colorScheme(.dark)))
//                        .environment(\.colorScheme, .light)
//                    TrussUI.Component.roundedRectangle(.regular)
//                        .truss(.size(.small))
//                        .truss(.foreground(.overrideMix))
//                        .environment(\.colorScheme, .dark)
//                }
//                if #available(macOS 14, *) {
//                    HStack {
//                        Text("Color Scheme Inheritance: ")
//                        TrussUI.Component.roundedRectangle(.regular)
//                            .truss(.size(.small))
//                            .truss(.foreground(.Scale.solid.colorScheme(.dark)))
//                            .truss(.tint(.systemRed))
//                        TrussUI.Component.roundedRectangle(.regular)
//                            .truss(.size(.small))
//                            .truss(.foreground(.Scale.solid))
//                            .truss(.tint(.systemRed.colorScheme(.dark)))
//                    }
//                    Text("Tint")
//                    TrussUI.Tint.redEqual.swatch()
//                    TrussUI.Tint.tintFromTint.swatch()
//                    TrussUI.Tint.systemRed.swatch(showValues: .hsb)
//                    TrussUI.Tint.red.swatch(showValues: .hsb)
//                    Text("Tint: Color Scheme Override")
//                    TrussUI.Tint.systemRed.colorScheme(.lightAccessible).swatch()
//                    Text("Color Variable")
//                    TrussUI.ColorVariable.Scale.solid.tint(.red).swatch(showValues: .hsb)
//                    TrussUI.ColorVariable.Scale.solid.tint(.systemRed).swatch(showValues: .hsb)
//                    TrussUI.ColorVariable.mix.tint(.systemRed).swatch()
//                    TrussUI.ColorVariable.Scale.backgroundEmphasized.swatch()
//                    TrussUI.ColorVariable.Scale.textFaded.swatch()
//                }
//            }
//            .frame(height: 900)
//        }
//    }
//
//    static var previews: some View {
//        VStack (spacing: 0) {
//            ColorComponentsTest()
//        }
//        .truss(.padding(.regular))
//        .truss(.background())
//    }
//}

// MARK: EnvironmentValues

private struct TrussUITintKey: EnvironmentKey {
    static let defaultValue: TrussUI.ColorVariable? = nil
}
private struct TrussUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

internal extension EnvironmentValues {
    var TrussUITint: TrussUI.ColorVariable? {
        get { self[TrussUITintKey.self] }
        set { self[TrussUITintKey.self] = newValue }
    }
    var TrussUICornerRadius: CGFloat? {
        get { self[TrussUICornerRadiusKey.self] }
        set { self[TrussUICornerRadiusKey.self] = newValue }
    }
}

internal extension EnvironmentValues {
    init(colorScheme: ColorScheme, colorSchemeContrast: ColorSchemeContrast) {
        var env = EnvironmentValues()
        env.colorScheme = colorScheme
        env._colorSchemeContrast = colorSchemeContrast
        self = env
    }
}
