//
//  GradientModifier.swift
//  
//
//  Created by Art Lasovsky on 12/07/2024.
//

import Foundation
import SwiftUI

@available(macOS 13.0, *)
public extension FoundationUI.ModifierLibrary {
    struct GradientModifier: ViewModifier {
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.colorSchemeContrast) private var colorSchemeContrast
        
        let gradient: DynamicGradient
        let style: Style
        
        @ViewBuilder
        public func body(content: Content) -> some View {
            let gradient = gradient.resolve(in: .init(colorScheme: colorScheme, colorSchemeContrast: colorSchemeContrast))
            switch style {
            case .linear(let startPoint, let endPoint):
                content.foregroundStyle(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
            case .angular(let center, let angle):
                content.foregroundStyle(AngularGradient(gradient: gradient, center: center, angle: angle))
            case .radial(let center, let startRadius, let endRadius):
                content.foregroundStyle(RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius))
            }
        }
        
        public enum Style {
            case linear(_ startPoint: UnitPoint, _ endPoint: UnitPoint)
            case radial(_ center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)
            case angular(_ center: UnitPoint, angle: Angle)
        }
    }
}

@available(macOS 13.0, *)
public extension FoundationUI.Modifier {
    static func gradient(_ gradient: DynamicGradient, style: Library.GradientModifier.Style = .linear(.top, .bottom)) -> Modifier<Library.GradientModifier> {
        .init(.init(gradient: gradient, style: style))
    }
}

@available(macOS 13.0, *)
struct GradientPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .foundation(.size(.regular))
                .foundation(.clip())
                .foundation(.gradient(.init(colors: [.primary.token(.text), .red.token(.borderEmphasized)])))
            Rectangle()
                .foundation(.size(.regular))
                .foundation(.clip())
                .foregroundStyle(DynamicGradient(colors: [.primary.token(.text), .red.token(.borderEmphasized)])
                    .linearGradient(startPoint: .top, endPoint: .bottom, in: .light))
        }
        .foundation(.cornerRadius(.regular))
        .padding()
    }
}
