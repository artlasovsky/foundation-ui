//
//  Demo.swift
//
//
//  Created by Art Lasovsky on 11/1/23.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Overrides

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
    func backgroundWithBorder(_ tint: FoundationUI.Tint, cornerRadius: CGFloat = 0) -> some View {
        content
            .theme().background(.background.tint(tint), cornerRadius: cornerRadius)
            .theme().border(.border.tint(tint), width: 2, cornerRadius: cornerRadius)
    }
    // Usage example:
    // - control label padding
    // - control background
    // - combine with ViewModifiers
}

// MARK: - Demo

struct Demo_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("\(FoundationUI.Variable.padding.regular)")
            Text("\(FoundationUI.Variable.padding.halfStep.regular)")
            VStack {
                HStack(spacing: .theme.spacing.regular) {
                    Text("FoundationUI")
                        .theme().font(\.body)
                        .theme().padding(\.regular, .vertical)
                        .theme().padding(\.large, .horizontal)
//                        .theme().tint(.primary)
//                        .theme().border(cornerRadius: .theme.radius.large - .theme.radius.regular)
//                        .theme().background(.fillFaded, cornerRadius: .theme.radius.large - .theme.padding.regular)
//                        .theme().foreground(.text)
//                        .theme().tint(.accent)
                    Text("Button")
                        .theme().padding(\.regular, .vertical)
                        .theme().padding(\.large, .horizontal)
                        .theme().backgroundWithBorder(.accent, cornerRadius: .theme.radius.large - .theme.padding.regular)
                }
                .theme().padding(\.regular)
                .theme().border(width: 2, cornerRadius: \.large)
            }
        }
        .padding()
    }
}
