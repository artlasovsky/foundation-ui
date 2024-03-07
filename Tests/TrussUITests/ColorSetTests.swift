import XCTest
@testable import TrussUI

final class ColorSetTests: XCTestCase {
    static let colorSet = TrussUI.ColorSet(
        light: .init(hue: 0.08, saturation: 0.8, brightness: 0.9),
        dark: .init(hue: 0.08, saturation: 0.75, brightness: 0.85)
    )
    
    static let tintedColorSet = TrussUI.TintedColorSet.tint(colorSet)
    
    func testColorSetComparison() throws {
        let targetColorSet = TrussUI.ColorSet(
            light: .init(hue: 0.08, saturation: 0.8, brightness: 0.9),
            dark: .init(hue: 0.08, saturation: 0.75, brightness: 0.85)
        )
        let targetTintedColorSet = TrussUI.TintedColorSet(
            light: .init(hue: 0.08, saturation: 0.8, brightness: 0.9),
            dark: .init(hue: 0.08, saturation: 0.75, brightness: 0.85)
        )
        // Same Type Comparison
        XCTAssertEqual(Self.colorSet, targetColorSet)
        // Same Protocol Comparison
        XCTAssertTrue(Self.colorSet == targetTintedColorSet)
    }
    
    func testTintedColorSetAdjustments() throws {
        let targetTintedColorSet = TrussUI.TintedColorSet(
            light: .init(hue: 0.08, saturation: 0.8, brightness: 0.9),
            dark: .init(hue: 0.08, saturation: 0.75, brightness: 0.85)
        )
        // set opacity to 1/2
        var adjusted = targetTintedColorSet.opacity(0.5)
        XCTAssertFalse(Self.colorSet == adjusted)
        
        // set opacity back to initial
        adjusted = adjusted.opacity(2)
        XCTAssertTrue(Self.colorSet == adjusted)
    }
    
    func testTintedColorSplitComparison() throws {
        // split init inheritance
        var adjusted = TrussUI.TintedColorSet(
            lightSet: Self.tintedColorSet,
            dark: Self.tintedColorSet
        )
        XCTAssertTrue(Self.colorSet == adjusted)
        
        adjusted = adjusted.blendMode(.softLight)
        XCTAssertFalse(Self.tintedColorSet.light == adjusted.light)
        
        adjusted = TrussUI.TintedColorSet(
            lightSet: Self.tintedColorSet,
            dark: Self.tintedColorSet.blendMode(.plusLighter)
        )
        XCTAssertTrue(Self.tintedColorSet.light == adjusted.light)
        XCTAssertFalse(Self.tintedColorSet.dark == adjusted.dark)
        
        adjusted = TrussUI.TintedColorSet(
            lightSet: Self.tintedColorSet,
            dark: Self.tintedColorSet.colorScheme(.light)
        )
        XCTAssertFalse(Self.colorSet == adjusted)
        XCTAssertTrue(Self.tintedColorSet.light == adjusted.dark)
    }
}
