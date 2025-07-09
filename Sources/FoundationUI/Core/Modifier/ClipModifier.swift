//
//  ClipModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct ClipModifier<S: Shape>: ViewModifier {
		@Environment(\.dynamicConcentricRoundedRectangle) private var dynamicConcentricRoundedRectangle
        let shape: S
		
		@ShapeBuilder
		private var resolvedShape: some Shape {
			if shape is DynamicConcentricRoundedRectangle {
				dynamicConcentricRoundedRectangle
			} else {
				shape
			}
		}
		
        public func body(content: Content) -> some View {
            content
                .clipShape(resolvedShape)
        }
    }
}

public extension FoundationModifier {
    static func clip<S: Shape>(_ shape: S = .dynamicConcentricRoundedRectangle()) -> FoundationModifier<FoundationModifierLibrary.ClipModifier<S>> {
        .init(.init(shape: shape))
    }
}

struct ClipModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
				.foundation(.size(square: .regular))
                .overlay {
                    Rectangle()
                        .foundation(.size(width: .large, height: .small))
                }
                .foundation(.clip())
                .foundation(.concentricRoundedRectangle(.regular))
        }
        .padding()        
    }
}
