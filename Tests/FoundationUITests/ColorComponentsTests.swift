import XCTest
import SwiftUI
@testable import FoundationUI

final class ColorComponentsInitializers: XCTestCase {
    func testHex() throws {
        checkHex("f30", target: (255, 51, 0, 255))
        checkHex("#f30", target: (255, 51, 0, 255))
        checkHex("FF3300", target: (255, 51, 0, 255))
        checkHex("ff3300ff", target: (255, 51, 0, 255))
        checkHex("FF3300FF", target: (255, 51, 0, 255))
        
        checkHex("fa3b30", target: (250, 59, 48, 255))
        checkHex("#fa3b30", target: (250, 59, 48, 255))
        
        checkHex("fa3b30fa", target: (250, 59, 48, 250))
        checkHex("#fa3b30fa", target: (250, 59, 48, 250))
    }
    
    func testIdenticalInitialization() throws {
        let hsb = ColorComponents(hue: 3 / 360, saturation: 0.81, brightness: 1)
        let hsb360 = ColorComponents(hue360: 3, saturation: 81, brightness: 100)
        let hex = ColorComponents(hex: "#FF3B30")
        let rgb = ColorComponents(red: 1, green: 59 / 255, blue: 48 / 255)
        let rgb8 = ColorComponents(red8bit: 255, green: 59, blue: 48)
        let color = Color(hue: 3 / 360, saturation: 0.81, brightness: 1)
        
        XCTAssertEqualColors(hsb, rgb)
        XCTAssertEqualColors(hsb, hsb360)
        XCTAssertEqualColors(hsb, rgb8)
        XCTAssertEqualColors(hsb, hex)
        XCTAssert(hsb.color == color)
    }
    
    func testMultiply() throws {
        let color = ColorComponents(
            hue: 0.01,
            saturation: 0.81,
            brightness: 1,
            opacity: 1
        )
        
        let hueAdjust: CGFloat = 2,
            saturationAdjust: CGFloat = 0.53,
            brightnessAdjust: CGFloat = 0.75,
            opacityAdjust: CGFloat = 1
        
        let adjusted = color
            .hue(hueAdjust)
            .saturation(saturationAdjust)
            .brightness(brightnessAdjust)
            .opacity(opacityAdjust)
        let targetColor = ColorComponents(
            hue: color.hue * hueAdjust,
            saturation: color.saturation * saturationAdjust,
            brightness: color.brightness * brightnessAdjust,
            opacity: color.opacity * opacityAdjust
        )
        
        XCTAssert(adjusted == targetColor, "\(adjusted) \n should be equal to \(targetColor)")
    }
    
    func testOverride() throws {
        let color = ColorComponents(
            hue: 0.01,
            saturation: 0.81,
            brightness: 1,
            opacity: 1
        )
        
        let hueAdjust: CGFloat = 2,
            saturationAdjust: CGFloat = 0.53,
//            brightnessAdjust: CGFloat = nil,
            opacityAdjust: CGFloat = 1
        
        let adjusted = color
            .hue(hueAdjust, method: .override)
            .saturation(saturationAdjust, method: .override)
//            .brightness(brightnessAdjust, method: .override)
            .opacity(opacityAdjust, method: .override)
        let targetColor = ColorComponents(
            hue: hueAdjust,
            saturation: saturationAdjust,
            brightness: color.brightness,
            opacity: opacityAdjust
        )
        
        XCTAssert(adjusted == targetColor, "\(adjusted) \n should be equal to \(targetColor)")
    }
    
    #warning("Conditional Adjustment Tests")
}

private func XCTAssertEqualColors(
    _ first: ColorComponents,
    _ second: ColorComponents,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssert(first == second, "\(first) not precisely equal to \(second)", file: file, line: line)
}

private func XCTAssertComponent<V: Numeric>(
    name: String? = nil,
    value: V,
    correct: V,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssert(value == correct, [name, "should be \(correct), but got \(value)"].compactMap({ $0 }).joined(separator: " "), file: file, line: line)
}

private func checkHex(
    _ hex: String,
    target: (r: Int, g: Int, b: Int, a: Int),
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssertEqual(ColorComponents(hex: hex), .init(red8bit: target.r, green: target.g, blue: target.b, opacity: target.a))
}
