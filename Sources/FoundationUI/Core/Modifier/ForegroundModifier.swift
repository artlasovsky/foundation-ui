//
//  ForegroundModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct ForegroundModifier<S: ShapeStyle>: ViewModifier {
        let style: S
        
        public func body(content: Content) -> some View {
            content
                .foregroundStyle(style)
        }
    }
}

public extension FoundationModifier {
    typealias Foreground<Style: ShapeStyle> = FoundationModifier<Library.ForegroundModifier<Style>>
    typealias ThemeColor = Theme.Color
    
    static func foreground(_ color: ThemeColor) -> Foreground<ThemeColor> {
        .init(.init(style: color))
    }
    
    static func foregroundStyle<S: ShapeStyle>(_ style: S) -> Foreground<S> {
        .init(.init(style: style))
    }
    
    static func foregroundColor(_ color: Color) -> Foreground<Color> {
        .init(.init(style: color))
    }
}


struct ForegroundModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Foreground")
                .foundation(.foreground(.red))
            Text("Foreground Tint")
                .foundation(.foreground(.dynamic(.text)))
                .foundation(.tint(.red))
            Text("Foreground SwiftUI")
                .foundation(.foregroundColor(.red))
        }
        .padding()
    }
}
