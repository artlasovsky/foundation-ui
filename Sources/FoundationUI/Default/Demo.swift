//
//  Demo.swift
//
//
//  Created by Art Lasovsky on 11/1/23.
//

import Foundation
import SwiftUI

// MARK: - Demo

// Default Theme Overrides

// Override Theme `VariableScale`:
private extension FoundationUI.Variable {
//    public static var padding: Padding { .init(.init(regular: 6, multiplier: 2)) }
}
// Extend Theme
private extension FoundationUI.Variable.Font {
    var body: Value { .body.bold() }
}

// Extending Modifiers
extension FoundationUI.Modifier {
    func backgroundWithBorder(_ color: FoundationUI.Color, cornerRadius: CGFloat = 0) -> some View {
        content
            .theme().background(color.background, cornerRadius: cornerRadius)
            .theme().border(color.border, width: 2, cornerRadius: cornerRadius)
    }
    // Usage example:
    // - control label padding
    // - control background
    // - combine with ViewModifiers
}

struct Demo_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack(spacing: .theme.spacing.regular) {
                Text("FoundationUI")
                    .font(.theme.body)
                    .padding(.vertical, .theme.padding.regular)
                    .padding(.horizontal, .theme.padding.large)
                    .theme().background(cornerRadius: .theme.radius.large - .theme.padding.regular)
                    .theme().border(.theme.accent.border, width: 2, cornerRadius: .theme.radius.large - .theme.padding.regular)
                Text("Button")
                    .padding(.vertical, .theme.padding.regular)
                    .padding(.horizontal, .theme.padding.large)
                    .theme().backgroundWithBorder(.theme.accent, cornerRadius: .theme.radius.large - .theme.padding.regular)
            }
            .theme().padding(\.regular)
            .theme().border(width: 2, cornerRadius: \.large)
        }
        .padding()
    }
}
