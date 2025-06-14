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
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        @Environment(\.dynamicCornerRadiusStyle) private var dynamicCornerRadiusStyle
        let shape: S
        public func body(content: Content) -> some View {
            content
                .clipShape(
                    ShapeBuilder.resolveShape(
                        shape,
                        dynamicCornerRadius: dynamicCornerRadius,
                        dynamicCornerRadiusStyle: dynamicCornerRadiusStyle
                    )
                )
        }
    }
}

public extension FoundationModifier {
    static func clip<S: Shape>(_ shape: S = .concentricShape()) -> FoundationModifier<FoundationModifierLibrary.ClipModifier<S>> {
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
                .foundation(.cornerRadius(.regular))
        }
        .padding()        
    }
}
