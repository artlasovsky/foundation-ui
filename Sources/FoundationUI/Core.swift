//
//  Core.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

public struct FoundationUI: FoundationUIDefault {
    private init() {}
    public struct Variable {}
    public struct Modifier {
        internal let content: AnyView
        internal init(_ content: some View) {
            self.content = AnyView(content)
        }
    }
    public struct Component {}
}

// Using protocol to have overridable default theme
public protocol FoundationUIDefault {}

// MARK: - Configuration
public extension FoundationUI {
    struct Color : ShapeStyle {
        public let light: SwiftUI.Color
        public let lightAccessible: SwiftUI.Color?
        public let dark: SwiftUI.Color
        public let darkAccessible: SwiftUI.Color?
        
        public init(light: SwiftUI.Color, lightAccessible: SwiftUI.Color? = nil, dark: SwiftUI.Color, darkAccessible: SwiftUI.Color? = nil) {
            self.light = light
            self.lightAccessible = lightAccessible
            self.dark = dark
            self.darkAccessible = darkAccessible
        }
        public init(_ universal: SwiftUI.Color, accessible: SwiftUI.Color? = nil) {
            self.light = universal
            self.lightAccessible = accessible
            self.dark = universal
            self.darkAccessible = accessible
        }
        public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {            
            return resolveColor(in: environment)
        }
        public func resolveColor(in environment: EnvironmentValues) -> SwiftUI.Color {
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
}

public struct VariableConfig<Value> {
    let xxSmall: Value
    let xSmall: Value
    let small: Value
    let regular: Value
    let large: Value
    let xLarge: Value
    let xxLarge: Value
}

extension VariableConfig where Value == CGFloat {
    public init(regular: Value, multiplier: Value) {
        let small = regular / multiplier
        let xSmall = small / multiplier
        let xxSmall = xSmall / multiplier
        let large = regular * multiplier
        let xLarge = large * multiplier
        let xxLarge = xLarge * multiplier
        self.init(
            xxSmall: xxSmall,
            xSmall: xSmall,
            small: small,
            regular: regular,
            large: large,
            xLarge: xLarge,
            xxLarge: xxLarge)
    }
}

public protocol VariableScale<Value> {
    associatedtype Value
    typealias Config = any VariableScale<Value>
    var config: VariableConfig<Value> { get }
}

public extension VariableScale {
    var xxSmall: Value { config.xxSmall }
    var xSmall: Value { config.xSmall }
    var small: Value { config.small }
    var regular: Value { config.regular }
    var large: Value { config.large }
    var xLarge: Value { config.xLarge }
    var xxLarge: Value { config.xxLarge }
}

public struct VariableFunctionConfig<Value> {
    let xxSmall: () -> Value
    let xSmall: () -> Value
    let small: () -> Value
    let regular: () -> Value
    let large: () -> Value
    let xLarge: () -> Value
    let xxLarge: () -> Value
}


public protocol VariableFunctionScale<Value> {
    associatedtype Value
    typealias Config = any VariableFunctionScale<Value>
    var config: VariableFunctionConfig<Value> { get }
}

public extension VariableFunctionScale {
    func xxSmall() -> Value { config.xxSmall() }
    func xSmall() -> Value { config.xSmall() }
    func small() -> Value { config.small() }
    func regular() -> Value { config.regular() }
    func large() -> Value { config.large() }
    func xLarge() -> Value { config.xLarge() }
    func xxLarge() -> Value { config.xxLarge() }
}
