//
//  FoundationColorVariable.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public protocol FoundationColorVariable: ShapeStyle {
    associatedtype Token
    
    func scale(_ token: Token) -> Self
    func callAsFunction(_ color: Self) -> Self
    
    func hue(_ value: CGFloat) -> Self
    func saturation(_ value: CGFloat) -> Self
    func brightness(_ value: CGFloat) -> Self
    func opacity(_ value: CGFloat) -> Self
}

public extension FoundationColorVariable {
    func callAsFunction(_ color: Self) -> Self {
        color
    }
}
