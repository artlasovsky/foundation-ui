import XCTest
@testable import TrussUI

final class ColorComponentsAdjustments: XCTestCase {
    let target = TrussUI.ColorComponents(hue: 0.08, saturation: 0.8, brightness: 0.8)
    func testAdjustingColorComponents() throws {
        let source = TrussUI.ColorComponents(hue: 0, saturation: 0.4, brightness: 1)
        let adjusted = source.set(hue: 0.08).multiply(saturation: 2).set(brightness: 0.8)
        XCTAssertEqual(target, adjusted)
    }
    
    func testAdjustingDynamicColorComponents() throws {
        let source: TrussUI.DynamicColorComponents = .init(hue: 0, saturation: 0.4, brightness: 1)
        let adjusted: TrussUI.DynamicColorComponents = source.set(hue: 0.08).multiply(saturation: 2).set(brightness: 0.8)
        XCTAssertTrue(target == adjusted)
        XCTAssertTrue(source != adjusted)
    }
    func testApplyDynamicColorAdjustmentsToOtherComponents() throws {
        let source: TrussUI.ColorComponents = .init(hue: 0, saturation: 0.4, brightness: 1)
        let dynamic: TrussUI.DynamicColorComponents = .init(source)
        XCTAssertTrue(source == dynamic)
        let adjusted: TrussUI.DynamicColorComponents = dynamic.set(hue: 0.08).multiply(saturation: 2).set(brightness: 0.8)
        let adjustedSource = adjusted.applyAdjustmentsTo(source)
        XCTAssertTrue(adjusted == adjustedSource)
    }
}
