//
//  Demo.swift
//
//
//  Created by Art Lasovsky on 11/1/23.
//

import Foundation
import SwiftUI

// MARK: - Default Theme Overrides

// Override default variable scale:
private extension FoundationUI.Variable {
    static var padding: Padding { .init(base: 20) }
}

// Extending variable scale:
private extension FoundationUI.Variable.Padding {
    // Adding `.xxxLarge` padding value,
    // the value will be one step up from the existed `.xxLarge`
    var xxxLarge: CGFloat { stepUp(1).xxLarge }
    
    // We can set constant value as well
    var content: CGFloat { 12 }
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
            VStack {
                HStack(spacing: .theme.spacing.regular) {
                    Rectangle()
                        .theme().size(\.xLarge)
                        .theme().border()
                        .overlay {
                            HStack {
                                Rectangle()
                                    .theme().padding(\.regular, .top)
                                    .theme().foreground(.fill)
                                Rectangle()
                                    .theme().padding(FoundationUI.Variable.padding.regular, .top)
                                    .theme().foreground(.fill)
                            }
                        }
//                    Text("FoundationUI")
//                        .theme().font(\.body)
//                        .theme().padding(\.regular, .vertical)
//                        .theme().padding(\.large, .horizontal)
//                        .theme().tint(.primary)
//                        .theme().border(cornerRadius: .theme.radius.large - .theme.radius.regular)
//                        .theme().background(.fillFaded, cornerRadius: .theme.radius.large - .theme.padding.regular)
//                        .theme().foreground(.text)
//                        .theme().tint(.accent)
//                    Text("Button")
//                        .theme().padding(\.regular, .vertical)
//                        .theme().padding(\.large, .horizontal)
//                        .theme().backgroundWithBorder(.accent, cornerRadius: .theme.radius.large - .theme.padding.regular)
                }
                .theme().padding(\.regular)
                .theme().border(width: 2, cornerRadius: \.large)
            }
        }
        .padding()
    }
}
