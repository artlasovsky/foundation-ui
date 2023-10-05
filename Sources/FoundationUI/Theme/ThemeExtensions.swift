//
//  File.swift
//  
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

// Set of several different value sets
public enum ThemeCGFloatProperties {
    public typealias padding = FoundationUI.Padding
    public typealias radius = FoundationUI.Padding
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

