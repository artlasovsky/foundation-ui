//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension FoundationUI {
    @frozen
    public struct Modifier<M: ViewModifier> {
        public typealias Modifier = FoundationUI.Modifier
        public typealias Library = FoundationUI.ModifierLibrary
        
        let value: M
        
        init(_ value: M) {
            self.value = value
        }
    }
}

extension FoundationUI {
    public struct ModifierLibrary {}
}

// MARK: - View extension
public extension View {
    @ViewBuilder
    func foundation<M: ViewModifier>(_ modifier: FoundationUI.Modifier<M>, bypass: Bool = false) -> some View {
        if bypass {
            self
        } else {
            self.modifier(modifier.value)
        }
    }
}
