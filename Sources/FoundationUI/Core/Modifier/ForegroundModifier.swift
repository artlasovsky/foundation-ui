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
    static func foreground(_ color: Theme.Color) -> FoundationModifier<FoundationModifierLibrary.ForegroundModifier<Theme.Color>> {
        .init(.init(style: color))
    }
    
    static func foregroundStyle<S: ShapeStyle>(_ style: S) -> FoundationModifier<FoundationModifierLibrary.ForegroundModifier<S>> {
        .init(.init(style: style))
    }
    
    static func foregroundColor(_ color: Color) -> FoundationModifier<FoundationModifierLibrary.ForegroundModifier<Color>> {
        .init(.init(style: color))
    }
	
	static func foregroundGradient(_ gradient: Theme.Gradient) -> FoundationModifier<FoundationModifierLibrary.ForegroundModifier<Theme.Gradient>> {
		.init(.init(style: gradient))
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
