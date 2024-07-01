//
//  ForegroundModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ForegroundModifier<FoundationUI.Theme.Color> {
    static func foreground(_ color: FoundationUI.Theme.Color) -> Self {
        .init(style: .style(color))
    }
    
    static func foregroundTinted(_ token: FoundationUI.Theme.Color.Token) -> Self {
        .init(style: .token(token))
    }
}

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ForegroundModifier<Color> {
    static func foregroundColor(_ color: SwiftUI.Color) -> Self {
        .init(style: .style(color))
    }
}

#warning("Add more ShapeStyles (gradient, ...)")


public extension FoundationUI.Modifier {
    struct ForegroundModifier<Style: ShapeStyle>: FoundationUIModifier {
        enum ForegroundStyle<S: ShapeStyle> {
            case token(FoundationUI.Theme.Color.Token)
            case style(S)
        }
        
        @Environment(\.dynamicColorTint) private var environmentTint
        
        let style: ForegroundStyle<Style>
        
        public func body(content: Content) -> some View {
            switch style {
            case .style(let style):
                content.foregroundStyle(style)
            case .token(let token):
                content.foregroundStyle(environmentTint.scale(token))
            }
        }
    }
}


#Preview {
    VStack {
        Text("Foreground")
            .foundation(.foreground(.red))
        Text("Foreground Tint")
            .foundation(.foregroundTinted(.text))
            .foundation(.tint(.red))
        Text("Foreground SwiftUI")
            .foundation(.foregroundColor(.red))
    }
    .padding()
}
