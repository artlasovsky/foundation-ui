//
//  File.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct TintModifier: ViewModifier {
        let tint: FoundationUI.Theme.Color
        public func body(content: Content) -> some View {
            content
                .environment(\.dynamicTint, tint)
        }
    }
}

public extension FoundationUI.Modifier {
    static func tint(_ color: FoundationUI.Theme.Color) -> Modifier<Library.TintModifier> {
        .init(.init(tint: color))
    }
    
    @available(macOS 14.0, *)
    static func tintColor(_ color: Color) -> Modifier<Library.TintModifier> {
        .init(.init(tint: .init(.from(color: color))))
    }
}
