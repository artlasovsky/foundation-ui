//
//  Defaults.swift
//  
//
//  Created by Art Lasovsky on 20/12/2023.
//

import Foundation
import SwiftUI

public struct FoundationUI {
    private init() {}
}


public protocol FoundationUIDefaultCornerRadiusStyle {
    static var cornerRadiusStyle: RoundedCornerStyle { get }
}

public extension FoundationUIDefaultCornerRadiusStyle {
    static var cornerRadiusStyle: RoundedCornerStyle { .continuous }
}

// Using protocol to have overridable default theme
public protocol FoundationUIScalableDefaults {
    associatedtype Padding: Scalable
    associatedtype Spacing: Scalable
    associatedtype Radius: Scalable
    associatedtype Size: Scalable
    
    associatedtype Shadow: Scalable
    
    typealias Scale = FoundationUI.Scale
    
    static var padding: Padding { get }
    static var spacing: Spacing { get }
    static var radius: Radius { get }
    static var size: Size { get }
    
    static var shadow: Shadow { get }
    static var animation: Scale.Animation { get }
    static var font: Scale.Font { get }
}
