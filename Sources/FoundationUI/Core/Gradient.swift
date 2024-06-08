//
//  Gradient.swift
//
//
//  Created by Art Lasovsky on 26/12/2023.
//

import Foundation
import SwiftUI

extension Gradient {
    static func from(tint: FoundationUI.DynamicColor?, variation: [FoundationUI.DynamicColor.VariationKeyPath], in environment: EnvironmentValues) -> Self? {
        guard !variation.isEmpty else { return nil }
        let tint: FoundationUI.DynamicColor = tint ?? environment.dynamicColorTint
        let colors: [Color] = variation.map({ tint[keyPath: $0].resolveColor(in: environment) })
        return .init(colors: colors)
    }
    static func from(colors: [FoundationUI.DynamicColor], in environment: EnvironmentValues) -> Self? {
        guard !colors.isEmpty else { return nil }
        let colors: [Color] = colors.map({ $0.resolveColor(in: environment) })
        return .init(colors: colors)
    }
    
    func linearGradient(startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        .init(gradient: self, startPoint: startPoint, endPoint: endPoint)
    }
}
