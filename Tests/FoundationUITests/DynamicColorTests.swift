import XCTest
import SwiftUI
@testable import FoundationUI

private let lightColor = FoundationUI.ColorComponents(hue: 0.1, saturation: 0.8, brightness: 1)
private let lightAccessibleColor = lightColor.saturation(1.2)
private let darkColor = FoundationUI.ColorComponents(hue: 0.1, saturation: 0.7, brightness: 1)
private let darkAssessibleColor = darkColor.saturation(1.2)
private let color = FoundationUI.DynamicColor(
    light: lightColor,
    dark: darkColor,
    lightAccessible: lightAccessibleColor,
    darkAccessible: darkAssessibleColor
)

@available(macOS 14.0, *)
extension Color {
    func preciseResolve(in env: EnvironmentValues) -> Color.Resolved {
        let resolved = self.resolve(in: env)
        return .init(
            red: resolved.red.precise(),
            green: resolved.green.precise(),
            blue: resolved.blue.precise()
        )
    }
}

final class DynamicColorTests: XCTestCase {
    func testInit() throws {
        XCTAssert(color.resolveColor(in: .init(colorScheme: .light, colorSchemeContrast: .standard)) == lightColor.color)
        XCTAssert(color.resolveColor(in: .init(colorScheme: .light, colorSchemeContrast: .increased)) == lightAccessibleColor.color)
        XCTAssert(color.resolveColor(in: .init(colorScheme: .dark, colorSchemeContrast: .standard)) == darkColor.color)
        XCTAssert(color.resolveColor(in: .init(colorScheme: .dark, colorSchemeContrast: .increased)) == darkAssessibleColor.color)
    }
    
    func testSimpleAdjust() throws {
        let hueAdjust: CGFloat = 0.2
        let saturationAdjust: CGFloat = 0.8
        let brightnessAdjust: CGFloat = 2
        let opacityAdjust: CGFloat = 0.5
        
        let adjusted: FoundationUI.DynamicColor = color
            .hue(hueAdjust)
            .saturation(saturationAdjust)
            .brightness(brightnessAdjust)
            .opacity(opacityAdjust)
        
        let targetLight = FoundationUI.ColorComponents(
            hue: lightColor.hue * hueAdjust,
            saturation: lightColor.saturation * saturationAdjust,
            brightness: lightColor.brightness * brightnessAdjust,
            opacity: lightColor.opacity * opacityAdjust
        )
        
        XCTAssert(adjusted.light == targetLight)
        
        if #available(macOS 14.0, *) {
            // Compare with SwiftUI.Color
            let targetColor = Color(
                hue: lightColor.hue * hueAdjust,
                saturation: lightColor.saturation * saturationAdjust,
                brightness: lightColor.brightness * brightnessAdjust,
                opacity: lightColor.opacity * opacityAdjust
            )
            let env = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
            let resolvedAdjusted = adjusted.resolveColor(in: env).preciseResolve(in: env)
            let resolvedTarget = targetColor.preciseResolve(in: env)
            XCTAssert(resolvedAdjusted == resolvedTarget)
            XCTAssert(resolvedAdjusted.red == resolvedTarget.red)
            XCTAssert(resolvedAdjusted.green == resolvedTarget.green)
            XCTAssert(resolvedAdjusted.blue == resolvedTarget.blue)
            XCTAssert(resolvedAdjusted.opacity == resolvedTarget.opacity)
        }
    }
    
    func testConditionalAdjust() throws {
        let env = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        
        let saturated = FoundationUI.DynamicColor(.init(hue: 0, saturation: 0.4, brightness: 1))
        let grayscale = FoundationUI.DynamicColor(.init(hue: 0, saturation: 0.0, brightness: 1))
        
        func conditionalBrightness(_ components: FoundationUI.ColorComponents) -> CGFloat {
            components.isSaturated ? 0.9 : 0.8
        }
        
        let adjustedSaturated = saturated
            .brightness(dynamic: conditionalBrightness(_:))
        let adjustedGrayscale = grayscale
            .brightness(dynamic: conditionalBrightness(_:))
        
        XCTAssert(adjustedSaturated.resolveColor(in: env) == Color(hue: 0, saturation: 0.4, brightness: 0.9))
        XCTAssert(adjustedGrayscale.resolveColor(in: env) == Color(hue: 0, saturation: 0, brightness: 0.8))
    }
    
    func testColorSchemeOverride() throws {
        let color = FoundationUI.DynamicColor.primary.scale(.background)
        
        XCTAssert(color.light == color.colorScheme(.light).dark)
        XCTAssert(color.light == color.colorScheme(.light).light)
        XCTAssert(color.light == color.colorScheme(.light).lightAccessible)
        XCTAssert(color.light == color.colorScheme(.light).darkAccessible)
        
        XCTAssert(color.light.opacity(0.5) == color.colorScheme(.light).opacity(0.5).darkAccessible)
    }
    
    #warning("BlendMode Tests")
    #warning("Variation Tests")
    #warning("SwiftUI Tests")
    #warning("AppKit / UIKit Tests")
    // TODO: Check new Color.mix modifier
}
