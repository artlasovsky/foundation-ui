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
//    func backgroundWithBorder(_ color: FoundationUI.Color, cornerRadius: CGFloat = 0) -> some View {
//        content
//            .theme().background(color.background, cornerRadius: cornerRadius)
//            .theme().border(color.border, width: 2, cornerRadius: cornerRadius)
//    }
    // Usage example:
    // - control label padding
    // - control background
    // - combine with ViewModifiers
}

struct MacOSApp_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    HStack {
                        Text("Window")
                        Image(systemName: "chevron.compact.right")
                        Text("Content")
                    }
                        .font(.theme.small)
                        .theme().foreground(.text)
                        .theme().padding(\.xSmall, .vertical)
                        .theme().padding(\.regular, .horizontal)
                        .theme().size(height: \.small)
                        .theme().background(.solid.opacity(0.2), cornerRadius: \.regular)
                    Spacer()
                }
                .overlay(alignment: .leading) {
                    HStack {
                        Circle().theme().size(12).foregroundStyle(.red)
                        Circle().theme().size(12).foregroundStyle(.yellow)
                        Circle().theme().size(12).foregroundColor(.green)
                    }.saturation(0.75)
                }
                .theme().padding(\.halfStep.regular, .horizontal)
                .theme().size(height: \.large)
                .theme().background(.element)
                Rectangle().frame(height: 1)
                    .theme().foreground(.backgroundFaded)
                HStack {
                    Text("Sidebar")
                    Spacer()
                }
                .theme().padding()
                Spacer()
            }
            .theme().clip(cornerRadius: \.window)
            .theme().background(cornerRadius: \.window, shadow: \.xxLarge)
            .theme().border(.scale.border.opacity(0.5), placement: .inside, cornerRadius: \.window)
            .theme().border(.scale.backgroundFaded, width: 0.5, placement: .outside, cornerRadius: \.window)
        }
        .theme().padding(\.large)
        .frame(width: 500, height: 350)
    }
}

struct Demo_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("\(FoundationUI.Variable.padding.regular)")
            Text("\(FoundationUI.Variable.padding.halfStep.regular)")
            VStack {
                HStack(spacing: .theme.spacing.regular) {
                    Text("FoundationUI")
                        .font(.theme.body)
                        .padding(.vertical, .theme.padding.regular)
                        .padding(.horizontal, .theme.padding.large)
                        .theme().background(cornerRadius: .theme.radius.large - .theme.padding.regular)
//                        .theme().border(.theme.accent.border, width: 2, cornerRadius: .theme.radius.large - .theme.padding.regular)
                    Text("Button")
                        .padding(.vertical, .theme.padding.regular)
                        .padding(.horizontal, .theme.padding.large)
//                        .theme().backgroundWithBorder(.theme.accent, cornerRadius: .theme.radius.large - .theme.padding.regular)
                }
                .theme().padding(\.regular)
                .theme().border(width: 2, cornerRadius: \.large)
            }
        }
        .padding()
    }
}
