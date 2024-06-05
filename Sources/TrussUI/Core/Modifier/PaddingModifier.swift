//
//  PaddingModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.PaddingModifier {
    static func padding(_ variable: TrussUI.Variable.Padding = .regular) -> Self {
        TrussUI.Modifier.PaddingModifier(variable: variable)
    }
}
public extension TrussUI.Modifier {
    struct PaddingModifier: TrussUIModifier {
        private let variable: TrussUI.Variable.Padding
        
        init(variable: TrussUI.Variable.Padding) {
            self.variable = variable
        }
        
        private var edges: Edge.Set = .all
        
        public func body(content: Content) -> some View {
            content.padding(edges, variable.value)
        }
        
        public func edges(_ edges: Edge.Set) -> Self {
            var copy = self
            copy.edges = edges
            return copy
        }
    }
}
