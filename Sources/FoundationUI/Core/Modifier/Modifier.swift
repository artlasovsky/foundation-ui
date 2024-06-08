//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension FoundationUI {
    public enum Modifier {}
}

public protocol FoundationUIModifier: ViewModifier {}

// MARK: - View extension
public extension View {
    func foundation(_ modifier: some FoundationUIModifier) -> some View {
        self.modifier(modifier)
    }
}
