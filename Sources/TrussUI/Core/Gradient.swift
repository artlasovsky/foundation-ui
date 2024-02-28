//
//  Gradient.swift
//
//
//  Created by Art Lasovsky on 26/12/2023.
//

import Foundation
import SwiftUI

public extension TrussUI {    
    struct Gradient: ShapeStyle {
        let colorVariables: [TrussUI.ColorVariable]
        let swiftUIColors: [Color]
        let startPoint: Self.Point
        
        public init(_ colorVariables: [TrussUI.ColorVariable], startPoint: Self.Point = .top) {
            self.colorVariables = colorVariables
            self.swiftUIColors = []
            self.startPoint = startPoint
        }
        public init(colors: [Color], startPoint: Self.Point = .top) {
            self.colorVariables = []
            self.swiftUIColors = colors
            self.startPoint = startPoint
        }
        
        public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
            let endPoint = startPoint.opposite.unitPoint
            let startPoint = startPoint.unitPoint
            
            var colors: [Color] {
                swiftUIColors.isEmpty
                ? self.colorVariables.map({ $0.color(environment) })
                : swiftUIColors
            }
            
            return AnyShapeStyle(LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            ))
        }
    }
}

extension TrussUI.Gradient {
    public enum Point: Sendable {
        case top
        case bottom
        case leading
        case trailing
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
        
        public var opposite: Self {
            switch self {
            case .top:
                return .bottom
            case .bottom:
                return .top
            case .leading:
                return .trailing
            case .trailing:
                return .leading
            case .topLeading:
                return .bottomTrailing
            case .topTrailing:
                return .bottomLeading
            case .bottomLeading:
                return .topTrailing
            case .bottomTrailing:
                return .topLeading
            }
        }
        public var unitPoint: UnitPoint {
            switch self {
            case .top:
                return .top
            case .bottom:
                return .bottom
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .topLeading:
                return .topLeading
            case .topTrailing:
                return .topTrailing
            case .bottomLeading:
                return .bottomLeading
            case .bottomTrailing:
                return .bottomTrailing
            }
        }
    }
}
