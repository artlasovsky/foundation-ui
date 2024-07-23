//
//  DynamicGradient.swift
//  
//
//  Created by Art Lasovsky on 12/07/2024.
//

import Foundation
import SwiftUI

public struct DynamicGradient: ShapeStyle {
    public struct Stop: Sendable {
        let color: Theme.Color
        let location: CGFloat
        
        public init(color: Theme.Color, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }
    
    public enum GradientType: Sendable {
        case linear(startPoint: UnitPoint, endPoint: UnitPoint)
        case radial(center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)
        case angular(center: UnitPoint, startAngle: Angle, endAngle: Angle? = nil)
    }
    
    let stops: [Stop]
    let type: GradientType
    
    public init(stops: [Stop], type: GradientType) {
        self.stops = stops
        self.type = type
    }
    
    public init(colors: [Theme.Color], type: GradientType) {
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
        self.type = type
    }
    
    @ShapeStyleBuilder
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        let stops: [Gradient.Stop] = stops.map { .init(color: $0.color.resolveColor(in: environment), location: $0.location )}
        switch type {
        case .linear(let startPoint, let endPoint):
            LinearGradient(stops: stops, startPoint: startPoint, endPoint: endPoint)
        case .radial(let center, let startRadius, let endRadius):
            RadialGradient(stops: stops, center: center, startRadius: startRadius, endRadius: endRadius)
        case .angular(let center, let startAngle, let endAngle):
            if let endAngle {
                AngularGradient(stops: stops, center: center, startAngle: startAngle, endAngle: endAngle)
            } else {
                AngularGradient(stops: stops, center: center, angle: startAngle)
            }
        }
    }
    
    func resolve(_ colorScheme: FoundationColorScheme) -> Gradient {
        Gradient(stops: stops.map({
            .init(
                color: $0.color.resolveColor(in: .init(colorScheme: colorScheme.colorScheme, colorSchemeContrast: colorScheme.colorSchemeContrast)),
                location: $0.location
            )
        }))
    }
}

public extension ShapeStyle where Self == DynamicGradient {
    static func dynamicGradient(colors: [Theme.Color], type: DynamicGradient.GradientType = .linear(startPoint: .top, endPoint: .bottom)) -> DynamicGradient {
        .init(colors: colors, type: type)
    }
    
    static func dynamicGradient(stops: [DynamicGradient.Stop], type: DynamicGradient.GradientType = .linear(startPoint: .top, endPoint: .bottom)) -> DynamicGradient {
        .init(stops: stops, type: type)
    }
    static func dynamicGradient(_ gradient: DynamicGradient) -> DynamicGradient {
        gradient
    }
}

struct DynamicGradient_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.dynamicGradient(colors: [.blue, .clear], type: .linear(startPoint: .topLeading, endPoint: .bottom)))
        }
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}


