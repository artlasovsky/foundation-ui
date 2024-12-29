//
//  FoundationColorVariable.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public protocol FoundationColorVariable: FoundationVariable, ShapeStyle, AdjustableByEnvironment {
    associatedtype Variant
    associatedtype Resolved = ShapeStyle
    associatedtype ColorValue
    var color: ColorValue { get }
	var environmentAdjustment: (@Sendable (_ environment: EnvironmentValues) -> Self?)? { get set }
    
    func variant(_ variant: Variant) -> Self
    static func dynamic(_ variant: Variant) -> Self
    
    func hue(_ hue: CGFloat) -> Self
    func saturation(_ saturation: CGFloat) -> Self
    func brightness(_ brightness: CGFloat) -> Self
    func opacity(_ opacity: CGFloat) -> Self
    
    func colorScheme(_ colorScheme: FoundationColorScheme) -> Self
    func blendMode(_ blendMode: BlendMode) -> Self
    
    func resolve(in: EnvironmentValues) -> Resolved
}

public extension FoundationColorVariable {
    func callAsFunction(_ value: Self) -> Self {
        value
    }
}
