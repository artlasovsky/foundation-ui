//
//  ThemeConfiguration.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation

// MARK: - Theme Configuration

public protocol ThemeConfiguration: Sendable {
    associatedtype Padding = FoundationVariable
    associatedtype Spacing = FoundationVariable
	associatedtype Length = FoundationVariable
    associatedtype Size = FoundationVariable
    associatedtype Radius = FoundationVariable
    associatedtype Color = FoundationColorVariable
    associatedtype Shadow = FoundationVariable
    associatedtype Font = FoundationVariable
	associatedtype Gradient = FoundationVariable
    
    var padding: Padding { get }
    var spacing: Spacing { get }
	var length: Length { get }
	var size: Size { get }
    var radius: Radius { get }
    
    var shadow: Shadow { get }
    var font: Font { get }
    var color: Color { get }
	var gradient: Gradient { get }
}
