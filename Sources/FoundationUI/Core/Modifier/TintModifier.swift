//
//  File.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.ModifierLibrary {
    struct TintModifier: ViewModifier {
        let tint: FoundationUI.Theme.Color
        func body(content: Content) -> some View {
            content
                .environment(\.dynamicTint, tint)
        }
    }
}

extension FoundationUI.Modifier {
    static func tint(_ color: FoundationUI.Theme.Color) -> Modifier<Library.TintModifier> {
        .init(.init(tint: color))
    }
    
    @available(macOS 14.0, *)
    static func tintColor(_ color: Color) -> Modifier<Library.TintModifier> {
        .init(.init(tint: .from(color: color)))
    }
}
