//
//  ClipModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct ClipModifier<S: Shape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        let shape: S
        public func body(content: Content) -> some View {
            content
                .clipShape(ShapeBuilder.resolveShape(shape, dynamicCornerRadius: dynamicCornerRadius))
        }
    }
}

public extension FoundationUI.Modifier {
    static func clip<S: Shape>(_ shape: S = .dynamicRoundedRectangle()) -> Modifier<Library.ClipModifier<S>> {
        .init(.init(shape: shape))
    }
}

#Preview {
    VStack {
        Rectangle()
            .foundation(.size(.regular))
            .overlay {
                Rectangle()
                    .foundation(.size(width: .large, height: .small))
            }
            .foundation(.clip())
            .foundation(.cornerRadius(.regular))
    }
    .padding()
}
