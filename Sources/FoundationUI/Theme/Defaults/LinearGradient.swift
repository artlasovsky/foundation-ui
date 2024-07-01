//
//  LinearGradient.swift
//
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.DefaultTheme {
    public var linearGradient: Variable.LinearGradient { .init() }
}

extension SwiftUI.LinearGradient {
    public static var foundation = FoundationUI.theme.linearGradient
}

public extension FoundationUI.DefaultTheme.Variable {
    struct LinearGradient: FoundationVariable {
        public typealias Result = FoundationLinearGradient

        public func callAsFunction(_ scale: Token) -> Result {
            let configuration = scale.value
            return FoundationLinearGradient(
                colors: configuration.colors,
                startPoint: configuration.startPoint,
                endPoint: configuration.endPoint
            )
        }
        
        public func callAsFunction(colors: [FoundationUI.Theme.Color], startPoint: UnitPoint, endPoint: UnitPoint) -> Result {
            FoundationLinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
        }
        
        public struct Configuration: Sendable {
            let colors: [FoundationUI.Theme.Color]
            let startPoint: UnitPoint
            let endPoint: UnitPoint
        }
        
        public struct Token: Sendable {
            public var value: FoundationUI.Theme.LinearGradient.Configuration
            
            public init(_ value: FoundationUI.Theme.LinearGradient.Configuration) {
                self.value = value
            }
            public init(colors: [FoundationUI.Theme.Color], startPoint: UnitPoint, endPoint: UnitPoint) {
                self.value = .init(colors: colors, startPoint: startPoint, endPoint: endPoint)
            }
            internal static var `default` = Self(.init(colors: [.primary, .red], startPoint: .top, endPoint: .bottom))
        }
        
        public struct FoundationLinearGradient: ShapeStyle {
            let colors: [FoundationUI.Theme.Color]
            let startPoint: UnitPoint
            let endPoint: UnitPoint
            public func resolve(in environment: EnvironmentValues) -> SwiftUI.LinearGradient {
                .init(
                    colors: colors.map({ $0.resolveColor(in: environment) }),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            }
        }
    }
}



#Preview {
    VStack {
        Rectangle()
            .foundation(.size(.regular))
            .foundation(.clip())
            .foregroundStyle(FoundationUI.theme.linearGradient(.default))
        
        Rectangle()
            .foundation(.size(.regular))
            .foundation(.clip())
            .foregroundStyle(FoundationUI.theme.linearGradient(
                colors: [
                    .primary.scale(.text),
                    .red.scale(.borderEmphasized)
                ],
                startPoint: .top,
                endPoint: .bottom
            ))
    }
    .foundation(.cornerRadius(.regular))
    .padding()
}
