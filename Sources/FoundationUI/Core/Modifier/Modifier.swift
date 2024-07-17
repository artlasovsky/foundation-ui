//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension FoundationUI {
    public struct Modifier<M: ViewModifier> {
        public typealias Modifier = FoundationUI.Modifier
        public typealias Library = FoundationUI.ModifierLibrary
        
        let value: M
        
        init(_ value: M) {
            self.value = value
        }
    }
}

extension FoundationUI {
    public struct ModifierLibrary {}
}

// MARK: - View extension
public extension View {
    func theme<M: ViewModifier>(_ modifier: FoundationUI.Modifier<M>) -> some View {
        self.modifier(modifier.value)
    }
    func foundation<M: ViewModifier>(_ modifier: FoundationUI.Modifier<M>) -> some View {
        self.modifier(modifier.value)
    }
}

public struct DynamicRoundedRectangle: Shape {
    public var cornerRadius: CGFloat = 0
    public var padding: CGFloat = 0
    public var style: RoundedCornerStyle = .continuous

    public func setCornerRadius(_ cornerRadius: CGFloat?) -> Self {
        guard let cornerRadius else { return self }
        var copy = self
        copy.cornerRadius = cornerRadius
        return copy
    }

    public func path(in rect: CGRect) -> Path {
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

public extension Shape where Self == DynamicRoundedRectangle {
    static func dynamicRoundedRectangle(padding: CGFloat = 0) -> Self { .init(padding: padding) }
}

public extension Shape where Self == RoundedRectangle {
    static func roundedRectangle(_ cornerRadius: FoundationUI.Theme.Radius.Token) -> Self {
        .init(cornerRadius: FoundationUI.theme.radius(cornerRadius))
    }
}

public struct ViewShape: Shape {
    public func path(in rect: CGRect) -> Path {
        .init()
    }
}

public extension Shape where Self == ViewShape {
    static var viewShape: Self { .init() }
}
