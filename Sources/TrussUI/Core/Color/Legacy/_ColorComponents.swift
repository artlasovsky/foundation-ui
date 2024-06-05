//
//  _ColorComponents.swift
//  
//
//  Created by Art Lasovsky on 07/02/2024.
//

import Foundation
import SwiftUI

#warning("Move Swatch to ColorComponents")

//// MARK: - Swatch
//internal extension CGFloat {
//    func eightBitValue() -> Int {
//        let roundingRule = FloatingPointRoundingRule.toNearestOrEven
//        return Int((self * 255).rounded(roundingRule))
//    }
//    func eightBitValueString() -> String {
//        return String(eightBitValue())
//    }
//    func twoFloatValue() -> String {
//        String(format: "%.2f", self)
//    }
//    func toHexValue() -> String {
//        String(format:"%02X", eightBitValue())
//    }
//}
//
//internal extension TrussUIColorComponents {
//    func hex() -> String {
//        [
//            red.toHexValue(),
//            green.toHexValue(),
//            blue.toHexValue(),
//            opacity.toHexValue()
//        ].joined()
//    }
//}
//
//private extension TrussUI.Variable.Font {
//    static let swatch = Self(.system(size: 8).monospacedDigit())
//}
//
//public extension TrussUIColorComponents {
//    func swatch(_ mode: SwatchColorModel? = nil) -> some View {
//        HStack {
//            TrussUI.Shape.roundedSquare(.regular, size: .regular.offset(.half.down))
//                .foregroundStyle(self.shapeStyle())
//            if let mode {
//                VStack(alignment: .leading) {
//                    HStack(spacing: 4) {
//                        VStack(alignment: .leading, spacing: 0) {
//                            switch mode {
//                            case .hsb:
//                                Text("H")
//                                Text("S")
//                                Text("B")
//                                Text("A")
//                            case .rgb, .rgb8:
//                                Text("R")
//                                Text("G")
//                                Text("B")
//                                Text("A")
//                            case .hex:
//                                EmptyView()
//                            }
//                        }
//                        VStack(alignment: .leading, spacing: 0) {
//                            switch mode {
//                            case .hsb:
//                                Text(hue.twoFloatValue())
//                                Text(saturation.twoFloatValue())
//                                Text(brightness.twoFloatValue())
//                                Text(opacity.twoFloatValue())
//                            case .rgb:
//                                Text(red.twoFloatValue())
//                                Text(green.twoFloatValue())
//                                Text(blue.twoFloatValue())
//                                Text(opacity.twoFloatValue())
//                            case .rgb8:
//                                Text(red.eightBitValueString())
//                                Text(green.eightBitValueString())
//                                Text(blue.eightBitValueString())
//                                Text(opacity.eightBitValueString())
//                            case .hex:
//                                let hex = hex()
//                                HStack(spacing: 0) {
//                                    Text(hex.prefix(6))
//                                    Text(hex.suffix(2)).opacity(0.7)
//                                }
//                            }
//                        }
//                    }
//                }
//                .truss(.font(.swatch))
//            }
//        }
//    }
//}
//
//public enum SwatchColorModel: String {
//    case hsb
//    case rgb
//    case rgb8
//    case hex
//}
//
//struct ColorComponents_Preview: PreviewProvider {
//    static var previews: some View {
//        let colorSet = TrussUI.ColorSet.primary
//        VStack(alignment: .leading) {
//            colorSet.light.swatch(.rgb8)
//            colorSet.dark.swatch(.hsb)
//            colorSet.lightAccessible.swatch(.rgb)
//            colorSet.darkAccessible.swatch(.hex)
//        }
//        .padding()
//        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
//    }
//}
