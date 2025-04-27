import Testing
import SwiftUI
@testable import FoundationUI

extension Theme.Color: FoundationThemeColor {}

private let lightColor = ColorComponents(hue: 0.1, saturation: 0.8, brightness: 1)
private let lightAccessibleColor = lightColor.saturation(1.2)
private let darkColor = ColorComponents(hue: 0.1, saturation: 0.7, brightness: 1)
private let darkAssessibleColor = darkColor.saturation(1.2)
private let color = DynamicColor(
    light: lightColor,
    dark: darkColor,
    lightAccessible: lightAccessibleColor,
    darkAccessible: darkAssessibleColor
)

@available(macOS 14.0, iOS 17.0, *)
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
@Suite("DynamicColor")
struct DynamicColorTests {
	@Test func initialization() async throws {
		#expect(color.resolveColor(in: .init(colorScheme: .light, colorSchemeContrast: .standard)) == lightColor.color)
		#expect(color.resolveColor(in: .init(colorScheme: .light, colorSchemeContrast: .increased)) == lightAccessibleColor.color)
		#expect(color.resolveColor(in: .init(colorScheme: .dark, colorSchemeContrast: .standard)) == darkColor.color)
		#expect(color.resolveColor(in: .init(colorScheme: .dark, colorSchemeContrast: .increased)) == darkAssessibleColor.color)
	}
    
	@Test func simpleAdjust() throws {
        let hueAdjust: CGFloat = 0.2
        let saturationAdjust: CGFloat = 0.8
        let brightnessAdjust: CGFloat = 2
        let opacityAdjust: CGFloat = 0.5
        
        let adjusted: DynamicColor = color
            .hue(hueAdjust)
            .saturation(saturationAdjust)
            .brightness(brightnessAdjust)
            .opacity(opacityAdjust)
        
        let targetLight = ColorComponents(
            hue: lightColor.hue * hueAdjust,
            saturation: lightColor.saturation * saturationAdjust,
            brightness: lightColor.brightness * brightnessAdjust,
            opacity: lightColor.opacity * opacityAdjust
        )
        
		#expect(adjusted.light == targetLight)
        
        if #available(macOS 14.0, iOS 17.0, *) {
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
			#expect(resolvedAdjusted == resolvedTarget)
			#expect(resolvedAdjusted.red == resolvedTarget.red)
			#expect(resolvedAdjusted.green == resolvedTarget.green)
			#expect(resolvedAdjusted.blue == resolvedTarget.blue)
			#expect(resolvedAdjusted.opacity == resolvedTarget.opacity)
        }
    }
    
    @Test func conditionalAdjust() throws {
        let env = EnvironmentValues(colorScheme: .light, colorSchemeContrast: .standard)
        
        let saturated = DynamicColor(.init(hue: 0, saturation: 0.4, brightness: 1))
        let grayscale = DynamicColor(.init(hue: 0, saturation: 0.0, brightness: 1))
        
        func conditionalBrightness(_ components: ColorComponents) -> CGFloat {
            components.isSaturated ? 0.9 : 0.8
        }
        
        let adjustedSaturated = saturated
            .brightness(dynamic: conditionalBrightness(_:))
        let adjustedGrayscale = grayscale
            .brightness(dynamic: conditionalBrightness(_:))
        
		#expect(adjustedSaturated.resolveColor(in: env) == Color(hue: 0, saturation: 0.4, brightness: 0.9))
		#expect(adjustedGrayscale.resolveColor(in: env) == Color(hue: 0, saturation: 0, brightness: 0.8))
    }
    
    @Test func colorSchemeOverride() throws {
		let color = Theme.Color.primary.color
        
		#expect(color.light == color.colorScheme(.light).dark)
		#expect(color.light == color.colorScheme(.light).light)
		#expect(color.light == color.colorScheme(.light).lightAccessible)
		#expect(color.light == color.colorScheme(.light).darkAccessible)
        
		#expect(color.light.opacity(0.5) == color.colorScheme(.light).opacity(0.5).darkAccessible)
    }
    
    #warning("BlendMode Tests")
    #warning("Variation Tests")
    #warning("SwiftUI Tests")
    #warning("AppKit / UIKit Tests")
    // TODO: Check new Color.mix modifier
}
