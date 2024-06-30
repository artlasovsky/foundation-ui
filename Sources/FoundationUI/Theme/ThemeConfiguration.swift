//
//  ThemeProtocols.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

// MARK: - Theme Configuration

public protocol ThemeConfiguration {
    associatedtype Padding = FoundationToken
    associatedtype Spacing = FoundationToken
    associatedtype Size = FoundationToken
    associatedtype Radius = FoundationToken
    associatedtype Color = FoundationColorToken
    associatedtype Shadow = FoundationToken
    associatedtype Font = FoundationToken
    associatedtype LinearGradient = FoundationToken
    
    var padding: Padding { get }
    var spacing: Spacing { get }
    var size: Size { get }
    var radius: Radius { get }
    
    var shadow: Shadow { get }
    var font: Font { get }
    var color: Color { get }
    
    var linearGradient: LinearGradient { get }
}

public protocol FoundationUITheme {
    associatedtype Theme = ThemeConfiguration
    static var theme: Theme { get }
}

extension FoundationUI: FoundationUITheme {}

extension CGFloat {
    public static var foundation: FoundationUI.Theme { FoundationUI.theme }
}
