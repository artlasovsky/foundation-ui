//
//  PaddingModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.PaddingModifier {
    static func padding(_ variable: FoundationUI.Variable.Padding = .regular) -> Self {
        FoundationUI.Modifier.PaddingModifier(variable: variable)
    }
}
public extension FoundationUI.Modifier {
    struct PaddingModifier: FoundationUIModifier {
        private let variable: FoundationUI.Variable.Padding
        
        init(variable: FoundationUI.Variable.Padding) {
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
