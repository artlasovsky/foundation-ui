//
//  DynamicGradient.swift
//  
//
//  Created by Art Lasovsky on 12/07/2024.
//

import Foundation
import SwiftUI

@available(macOS 13.0, *)
struct DynamicGradient: ShapeStyle {
    struct Stop {
        let color: FoundationUI.Theme.Color
        let location: CGFloat
    }
    let stops: [Stop]
    
    init(stops: [Stop]) {
        self.stops = stops
    }
    
    init(colors: [FoundationUI.Theme.Color]) {
        self.stops = colors.enumerated().map({ item in
            var location: CGFloat
            if item.offset == 0 {
                location = 0
            } else if item.offset == colors.count - 1 {
                location = 1
            } else {
                location = CGFloat(item.offset) / CGFloat(colors.count - 1)
            }
            return .init(color: item.element, location: location)
        })
    }
    
    func resolve(in environment: EnvironmentValues) -> Gradient {
        Gradient(stops: stops.map({
            .init(
                color: $0.color.resolveColor(in: environment),
                location: $0.location
            )
        }))
    }
    
    func resolve(_ colorScheme: FoundationUI.ColorScheme) -> Gradient {
        Gradient(stops: stops.map({
            .init(
                color: $0.color.resolveColor(in: .init(colorScheme: colorScheme.colorScheme, colorSchemeContrast: colorScheme.colorSchemeContrast)),
                location: $0.location
            )
        }))
    }
}

@available(macOS 13.0, *)
extension DynamicGradient {
    func linearGradient(startPoint: UnitPoint, endPoint: UnitPoint, in colorScheme: FoundationUI.ColorScheme) -> LinearGradient {
        .init(gradient: self.resolve(colorScheme), startPoint: startPoint, endPoint: endPoint)
    }
    func radialGradient(center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat, in colorScheme: FoundationUI.ColorScheme) -> RadialGradient {
        .init(gradient: self.resolve(colorScheme), center: center, startRadius: startRadius, endRadius: endRadius)
    }
    func angularGradient(center: UnitPoint, angle: Angle, in colorScheme: FoundationUI.ColorScheme) -> AngularGradient {
        .init(gradient: self.resolve(colorScheme), center: center, angle: angle)
    }
    func angularGradient(center: UnitPoint, startAngle: Angle, endAngle: Angle, in colorScheme: FoundationUI.ColorScheme) -> AngularGradient {
        .init(gradient: self.resolve(colorScheme), center: center, startAngle: startAngle, endAngle: endAngle)
    }
}
