//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

@frozen @MainActor
public struct FoundationModifier<M: ViewModifier> {    
    let value: M
    
    public init(_ value: M) {
        self.value = value
    }
}

public struct FoundationModifierLibrary {}

// MARK: - View extension
public extension View {
    @ViewBuilder
    func foundation<M: ViewModifier>(
        _ modifier: FoundationModifier<M>,
        bypass: Bool = false
    ) -> some View {
        if bypass {
            self
        } else {
            self.modifier(modifier.value)
        }
    }
	
	func theme<M: ViewModifier>(_ modifier: FoundationModifier<M>, bypass: Bool = false) -> some View {
		foundation(modifier, bypass: bypass)
	}
}
