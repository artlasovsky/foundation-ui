import XCTest
import SwiftUI
@testable import TrussUI

private let lightColor = TrussUI.ColorComponents(hue: 0.1, saturation: 0.8, brightness: 1)
private let lightAccessibleColor = lightColor.multiply(saturation: 1.2)
private let darkColor = TrussUI.ColorComponents(hue: 0.1, saturation: 0.7, brightness: 1)
private let darkAssessibleColor = darkColor.multiply(saturation: 1.2)
private let color = TrussUI.DynamicColor(
    light: lightColor,
    dark: darkColor,
    lightAccessible: lightAccessibleColor,
    darkAccessible: darkAssessibleColor
)

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
        
        let adjusted: TrussUI.DynamicColor = color
            .opacity(opacityAdjust)
            .hue(hueAdjust)
            .saturation(saturationAdjust)
            .brightness(brightnessAdjust)
        
        let target = Color(
            hue: hueAdjust,
            saturation: lightColor.saturation * saturationAdjust,
            brightness: lightColor.brightness * brightnessAdjust,
            opacity: lightColor.opacity * opacityAdjust
        )
        let env = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        XCTAssert(adjusted.resolveColor(in: env) == target)
    }
    
    func testConditionalAdjust() throws {
        let env = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        
        let saturated = TrussUI.DynamicColor(.init(hue: 0, saturation: 0.4, brightness: 1))
        let grayscale = TrussUI.DynamicColor(.init(hue: 0, saturation: 0.0, brightness: 1))
        
        func conditional(_ components: TrussUI.ColorComponents) -> TrussUI.ColorComponents {
            components.multiply(brightness: components.isSaturated ? 0.9 : 0.8)
        }
        
        let adjustedSaturated = saturated
            .makeVariation(light: conditional(_:), dark: { $0 })
        let adjustedGrayscale = grayscale
            .makeVariation(light: conditional(_:), dark: { $0 })
        
        XCTAssert(adjustedSaturated.resolveColor(in: env) == Color(hue: 0, saturation: 0.4, brightness: 0.9))
        XCTAssert(adjustedGrayscale.resolveColor(in: env) == Color(hue: 0, saturation: 0, brightness: 0.8))
    }
    
    // TODO: Create mixed
    // TODO: BlendMode
    // TODO: UI Test with Environment
}
