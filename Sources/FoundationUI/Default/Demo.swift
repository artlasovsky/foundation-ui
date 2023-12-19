//
//  Demo.swift
//
//
//  Created by Art Lasovsky on 11/1/23.
//

import Foundation
import SwiftUI

// MARK: - Demo


// MARK: macOS Extensions
extension FoundationUI.ColorScale {
    static let windowTopGlare = FoundationUI.ColorScale(
        light: .backgroundFaded.opacity(0.8),
        dark: .border.opacity(0.9)
    )
    static let windowInnerBorder = FoundationUI.ColorScale(
        light: .backgroundFaded.opacity(0.5),
        dark: .border.opacity(0.5)
    )
    static let windowOuterBorder = FoundationUI.ColorScale(
        light: .border.opacity(0.2),
        dark: .backgroundFaded
    )
    static let windowToolbarBackground = FoundationUI.ColorScale(
        light: .backgroundFaded,
        dark: .fillFaded
    )
    static let windowToolbarElementBackground = Self.windowToolbarElementBackground()
    static func windowToolbarElementBackground(_ isPressed: Bool = false) -> FoundationUI.ColorScale {
        return FoundationUI.ColorScale(
            light: .fill.opacity(isPressed ? 0.4 : 0.2),
            dark: .fill.opacity(isPressed ? 1 : 0.6)
        )
    }
    static let windowBackground = FoundationUI.ColorScale(light: .background,
                                                          dark: .backgroundEmphasized)
    static let divider = FoundationUI.ColorScale(light: .border.opacity(0.2),
                              dark: .backgroundFaded)
    
}

extension FoundationUI.Modifier {
    @ViewBuilder func windowBorder() -> some View {
        content
            .theme().cornerRadius(nil)
            .theme().border(.windowOuterBorder, placement: .outside)
            .theme().border(.windowInnerBorder, placement: .inside)
            .overlay(alignment: .top) {
                Color.clear
                    .theme().size(height: \.small)
                    .theme().border(gradient: .init([.windowTopGlare, .clear, .clear], startPoint: .top),
                                    placement: .inside)
            }
            .theme().cornerRadius(\.window)
    }
}

extension FoundationUI.Variable.Size {
    var toolbarElementHeight: CGFloat { .theme.size.small }
}

extension FoundationUI.Variable.Radius {
    var toolbarElementRadius: CGFloat { .theme.radius.halfStep.small }
}

// MARK: Default Theme Overrides

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

struct macOSWindow<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack {
            VStack(spacing: 0) { content }
            .theme().clip(cornerRadius: \.window)
            .theme().background(.windowBackground, cornerRadius: \.window, shadow: \.xxLarge)
            .theme().windowBorder()
        }
        .theme().padding(\.xLarge)
        .frame(width: 500, height: 350)
    }
}

struct macOSToolbarButton: View {
    let systemImage: String
    struct macOSToolbarButtonStyle: ButtonStyle {
        @State private var isHovered: Bool = false
        func makeBody(configuration: Configuration) -> some View {
            let isPressed = configuration.isPressed
            configuration.label
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .theme().foreground(isPressed ? .text : .textFaded)
                .theme().font(\.xLarge)
                .theme().padding(\.halfStep.xSmall, .vertical)
                .theme().padding(\.small, .horizontal)
                .theme().size(height: \.toolbarElementHeight)
                .theme().background(isHovered ? .windowToolbarElementBackground(isPressed) : .clear,
                                    cornerRadius: \.toolbarElementRadius)
                .contentShape(Rectangle())
                .onHover { isHovered = $0 }
        }
    }
    var body: some View {
        Button("Sidebar", systemImage: systemImage, action: {})
            .buttonStyle(macOSToolbarButtonStyle())
    }
}

struct macOSToolbar<Content: View>: View {
    let content: () -> Content
    var body: some View {
        HStack {
            Spacer()
            content()
            Spacer()
        }
        .overlay(alignment: .trailing) {
            macOSToolbarButton(systemImage: "sidebar.right")
                .offset(x: .theme.spacing.halfStep.small)
        }
        .overlay(alignment: .leading) {
            HStack {
                Circle()
                    .theme().size(12)
                    .theme().foreground(.solid)
                    .theme().tint(color: .red)
                Circle().theme().size(12).foregroundStyle(.yellow)
                Circle().theme().size(12).foregroundColor(.green)
            }.saturation(0.75)
        }
        .theme().padding(\.halfStep.regular, .horizontal)
        .theme().size(height: \.large)
        .theme().background(.windowToolbarBackground)
    }
}

struct MacOSApp_Preview: PreviewProvider {
    static var previews: some View {
        macOSWindow {
            macOSToolbar {
                HStack {
                    Text("Window")
                    Image(systemName: "chevron.compact.right")
                    Text("Content")
                }
                    .font(.theme.small)
                    .theme().foreground(.text)
                    .theme().padding(\.xSmall, .vertical)
                    .theme().padding(\.regular, .horizontal)
                    .theme().size(height: \.toolbarElementHeight)
                    .theme().background(.windowToolbarElementBackground,
                                        cornerRadius: \.toolbarElementRadius)
            }
            Rectangle().frame(height: 1)
                .theme().foreground(.divider)
            HStack(alignment: .top, spacing: .theme.spacing.xLarge) {
                VStack(alignment: .leading) {
                    Text("Text Emphasized")
                        .theme().foreground(.textEmphasized)
                    Text("Text")
                        .theme().foreground(.text)
                    Text("Text Faded")
                        .theme().foreground(.textFaded)
                }
                VStack(alignment: .leading) {
                    Button("Clipped Button", action: {})
                        .buttonStyle(.plain)
                        .fixedSize()
                        .theme().size(width: \.xLarge, height: \.small)
                        .theme().clip()
                        .theme().background()
                        .theme().border()
                        /// `.cornerRadius(.\regular)` will be applied to the `.theme()` elements above
                        .theme().cornerRadius(\.regular)
                        .theme().tint(.accent)
                    Button("Button", action: {})
                        .buttonStyle(.plain)
                        .theme().padding(\.regular, .horizontal)
                        .theme().size(height: \.small)
                        .theme().background(.fillFaded.opacity(0.3), cornerRadius: \.regular)
                        .theme().foreground(.text.tint(.primary))
                        .theme().border(.backgroundFaded, width: 0.5, placement: .outside, cornerRadius: \.regular)
                        .theme().border(.fillFaded.opacity(0.9), cornerRadius: \.regular)
                        // Top glare gradient
                        .overlay(alignment: .top) {
                            Color.clear
                                .theme().border(gradient: .init([.borderFaded.opacity(0.5), .clear, .clear, .clear],
                                                                startPoint: .top),
                                                cornerRadius: \.regular)
                                .theme().size(height: \.small)
                        }
                        .theme().tint(color: .blue)
                }
                VStack(alignment: .leading) {
                    Text("Blend Mode")
                    Rectangle().theme().size(\.regular)
                        .theme().foreground(.fill)
                    Rectangle().theme().size(\.regular)
                        .theme().foreground(.text.blendMode(.overlay))
                        .offset(x: 10, y: -20)
                }
                .theme().tint(color: .red)
                Spacer()
            }
            .theme().padding()
            Spacer()
        }
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
