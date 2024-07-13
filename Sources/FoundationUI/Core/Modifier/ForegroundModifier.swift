//
//  ForegroundModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct ForegroundModifier<S: ShapeStyle>: ViewModifier {
        let style: S
        
        public func body(content: Content) -> some View {
            content
                .foregroundStyle(style)
        }
    }
}

public extension FoundationUI.Modifier {
    public typealias Foreground<Style: ShapeStyle> = Modifier<Library.ForegroundModifier<Style>>
    public typealias ThemeColor = FoundationUI.Theme.Color
    
    static func foreground(_ color: ThemeColor) -> Foreground<ThemeColor> {
        .init(.init(style: color))
    }
    
    static func foregroundStyle<S: ShapeStyle>(_ style: S) -> Foreground<S> {
        .init(.init(style: style))
    }
    
    static func foregroundColor(_ color: Color) -> Foreground<Color> {
        .init(.init(style: color))
    }
    
    static func foregroundToken(_ token: ThemeColor.Token) -> Foreground<ThemeColor.Token> {
        .init(.init(style: token))
    }
}


#Preview {
    VStack {
        Text("Foreground")
            .foundation(.foreground(.red))
        Text("Foreground Tint")
            .foundation(.foregroundToken(.text))
            .foundation(.tint(.red))
        Text("Foreground SwiftUI")
            .foundation(.foregroundColor(.red))
    }
    .padding()
}
