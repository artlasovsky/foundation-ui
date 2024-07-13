//
//  ThemeConfiguration.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

// MARK: - Theme Configuration

public protocol ThemeConfiguration {
    associatedtype Padding = FoundationVariable
    associatedtype Spacing = FoundationVariable
    associatedtype Size = FoundationVariable
    associatedtype Radius = FoundationVariable
    associatedtype Color = FoundationColorVariable
    associatedtype Shadow = FoundationVariable
    associatedtype Font = FoundationVariable
    
    var padding: Padding { get }
    var spacing: Spacing { get }
    var size: Size { get }
    var radius: Radius { get }
    
    var shadow: Shadow { get }
    var font: Font { get }
    var color: Color { get }
}

public protocol FoundationUITheme {
    associatedtype Theme = ThemeConfiguration
    static var theme: Theme { get }
}

public let Theme = FoundationUI.theme

extension FoundationUI: FoundationUITheme {}
