//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension FoundationUI {
    struct Modifier<M: ViewModifier> {
        typealias Modifier = FoundationUI.Modifier
        typealias Library = FoundationUI.ModifierLibrary
        
        let value: M
        
        init(_ value: M) {
            self.value = value
        }
    }
}

extension FoundationUI {
    struct ModifierLibrary {}
}

// MARK: - View extension
extension View {
    func theme<M: ViewModifier>(_ modifier: FoundationUI.Modifier<M>) -> some View {
        self.modifier(modifier.value)
    }
    func foundation<M: ViewModifier>(_ modifier: FoundationUI.Modifier<M>) -> some View {
        self.modifier(modifier.value)
    }
}

private struct DynamicTintKey: EnvironmentKey {
    static let defaultValue: FoundationUI.Theme.Color = .dynamic
}

extension EnvironmentValues {
    var dynamicTint: FoundationUI.Theme.Color {
        get { self[DynamicTintKey.self] }
        set { self[DynamicTintKey.self] = newValue }
    }
}

struct DynamicRoundedRectangle: Shape {
    var cornerRadius: CGFloat = 0
    var padding: CGFloat = 0
    var style: RoundedCornerStyle = .continuous

    func setCornerRadius(_ cornerRadius: CGFloat?) -> Self {
        guard let cornerRadius else { return self }
        var copy = self
        copy.cornerRadius = cornerRadius
        return copy
    }

    func path(in rect: CGRect) -> Path {
        .init(
            roundedRect: .init(
                x: rect.minX + padding,
                y: rect.minY + padding,
                width: rect.width - padding * 2,
                height: rect.height - padding * 2
            ),
            cornerRadius: cornerRadius - padding,
            style: style
        )
    }
}

extension Shape where Self == DynamicRoundedRectangle {
    static func dynamicRoundedRectangle(padding: CGFloat = 0) -> Self { .init(padding: padding) }
}

extension Shape where Self == RoundedRectangle {
    static func roundedRectangle(_ cornerRadius: FoundationUI.Theme.Radius.Token) -> Self {
        .init(cornerRadius: FoundationUI.theme.radius(cornerRadius))
    }
}

struct ViewShape: Shape {
    func path(in rect: CGRect) -> Path {
        .init()
    }
}

extension Shape where Self == ViewShape {
    static var viewShape: Self { .init() }
}

@available(macOS 14.0, *)
struct _Modifier: View {
    @State private var toggle: Bool = false
    var body: some View {
        Text("Hello\(toggle ? "1" : "!")")
            .fixedSize()
            .foundation(.size(.regular))
            .background {
                Rectangle()
                    .foundation(.foregroundToken(.fill))
            }
//            .theme(.size(.regular))
//            .overlay(.red, in: .dynamicRoundedRectangle(padding: 0))
////            .clipShape(.dynamicRoundedRectangle(padding: 0))
//            .theme(.clip(.dynamicRoundedRectangle()))
////            ._theme()
//            .theme(.padding(.regular, adjustNestedCornerRadius: .soft))
////            .foregroundStyle(.dynamic(.fill))
////            .background(.white, in: .rect(cornerRadius: 8))
////            ._theme(.foreground(.primary))
//            .theme(.foregroundToken(.solid))
////            ._theme(.foregroundStyle(LinearGradient(colors: [.accentColor, .green], startPoint: .top, endPoint: .bottom)))
////            ._theme(.foregroundStyle(.accentColor))
////            ._theme(.background(.orange, in: .dynamicRoundedRectangle(padding: 4)))
//            .theme(.backgroundStyle(.orange, in: .dynamicRoundedRectangle()))
//            .theme(.padding(.small, adjustNestedCornerRadius: .sharp))
//            .theme(.background(.white, in: .dynamicRoundedRectangle()))
////            ._theme(.border(LinearGradient(colors: [.gray, .clear], startPoint: .bottom, endPoint: .top), in: .dynamicRoundedRectangle(padding: 5)))
////            ._theme(.shadow(style: .black.opacity(0.3), radius: 2.5, y: 1.5, in: .dynamicRoundedRectangle(padding: 2)))
//            .theme(.shadow(style: .black.opacity(0.3), radius: 2.5, y: 1.5, in: .dynamicRoundedRectangle(padding: 2)))
//            .theme(.cornerRadius(.xLarge))
//            .environment(\.dynamicTint, .from(color: .accentColor))
    }
}

@available(macOS 14.0, *)
#Preview {
    _Modifier()
        .padding()
}
