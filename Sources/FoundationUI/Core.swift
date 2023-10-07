//
//  Core.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

public struct FoundationUI {
    public struct Padding { internal init() {} }
    public struct Radius { internal init() {} }
    
    public struct Color { internal init() {} }
    
    // TODO: Not Implemented yet
    public struct Font { internal init() {} }
    public struct Shadow {
        public let color: SwiftUI.Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
        public init(_ color: SwiftUI.Color = .black, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }
}


// MARK: - Value Extensions
// Set of several different value sets
public enum ThemeCGFloatProperties {
    public typealias padding = FoundationUI.Padding
    public typealias radius = FoundationUI.Padding
}

public extension View {
    func shadow(_ value: FoundationUI.Shadow) -> some View {
        self
            .shadow(color: value.color, radius: value.radius, x: value.x, y: value.y)
    }
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
