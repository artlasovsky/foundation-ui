//
//  File.swift
//  
//
//  Created by Art Lasovsky on 1/4/2023.
//

import Foundation
import SwiftUI

func getRoundedRectangle(_ radius: CGFloat) -> RoundedRectangle {
    RoundedRectangle(cornerRadius: radius, style: .continuous)
}
func getVariantValue<K: VariantKey, V: Any>(_ value: ValueWithVariant<K, V>, key: K?) -> V {
    if let key {
        return value.variants[key] ?? value.default
    } else {
        return value.default
    }
}

func getBlendMode(_ colorScheme: ColorScheme) -> BlendMode {
    return colorScheme == .dark ? .plusLighter : .plusDarker
}

func getTint(_ tint: TintVariant?) -> Color? {
    guard let tint else { return nil }
    if case .custom(let color) = tint {
        return color
    }
    return FoundationUIConfig.shared.tint[tint]
}
