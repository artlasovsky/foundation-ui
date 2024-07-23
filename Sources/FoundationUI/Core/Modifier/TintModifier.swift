//
//  File.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct TintModifier: ViewModifier {
        let tint: Theme.Color
        public func body(content: Content) -> some View {
            content
                .environment(\.dynamicTint, tint)
        }
    }
}

public extension FoundationModifier {
    static func tint(_ color: Theme.Color) -> FoundationModifier<Library.TintModifier> {
        .init(.init(tint: color))
    }
    
    static func tintColor(_ color: Color) -> FoundationModifier<Library.TintModifier> {
        .init(.init(tint: .init(.from(color: color))))
    }
}
