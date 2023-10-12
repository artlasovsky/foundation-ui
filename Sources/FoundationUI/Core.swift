//
//  Core.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

public struct FoundationUI {
    public struct Padding {}
    public struct Radius {}
    
    public struct Color: ShapeStyle {
        public typealias Color = SwiftUI.Color
        public let light: Color
        public let lightAccessible: Color?
        public let dark: Color
        public let darkAccessible: Color?
        
        public init(light: Color, lightAccessible: Color? = nil, dark: Color, darkAccessible: Color? = nil) {
            self.light = light
            self.lightAccessible = lightAccessible
            self.dark = dark
            self.darkAccessible = darkAccessible
        }
        public init(_ universal: Color, accessible: Color? = nil) {
            self.light = universal
            self.lightAccessible = accessible
            self.dark = universal
            self.darkAccessible = accessible
        }
        public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
            // TODO: Accessibility
            var color = environment.colorScheme == .light ? light : dark
            let accessibility = (
                contrast: environment.colorSchemeContrast == .increased,
                invertColors: environment.accessibilityInvertColors,
                reduceTransparency: environment.accessibilityReduceTransparency,
                differentiateWithoutColor: environment.accessibilityDifferentiateWithoutColor
            )
            if accessibility.contrast {
                color = environment.colorScheme == .light ? lightAccessible ?? light : darkAccessible ?? dark
            }
            
            return color
        }
    }
    
    // TODO: Not Implemented yet
    public struct Font {}
}


// MARK: - Value Extensions
// Set of several different value sets
public enum ThemeCGFloatProperties {
    public typealias padding = FoundationUI.Padding
    public typealias radius = FoundationUI.Radius
}

public extension CGFloat {
    typealias theme = ThemeCGFloatProperties
    typealias foundation = ThemeCGFloatProperties
}

public extension Color {
    typealias theme = FoundationUI.Color
    typealias foundation = FoundationUI.Color
}

public extension ShapeStyle {
    typealias theme = FoundationUI.Color
    typealias foundation = FoundationUI.Color
}
