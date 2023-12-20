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


public protocol FoundationUIStyleDefaults {
    static var cornerRadiusStyle: RoundedCornerStyle { get }
}

// Using protocol to have overridable default theme
public protocol FoundationUIVariableDefaults {
    static var padding: FoundationUI.Variable.Padding { get }
    static var spacing: FoundationUI.Variable.Spacing { get }
    static var radius: FoundationUI.Variable.Radius { get }
    static var shadow: FoundationUI.Variable.Shadow { get }
    
    static var animation: FoundationUI.Variable.Animation { get }
    
    static var font: FoundationUI.Variable.Font { get }
}
