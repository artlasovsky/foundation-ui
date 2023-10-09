//
//  File.swift
//  
//
//  Created by Art Lasovsky on 10/7/23.
//

import Foundation
import FoundationUICore
import SwiftUI

extension FoundationUI.Modifier.Border {
    static let `default` = Self(color: .primary.scale.border)
}
extension FoundationUI.Modifier.Background {
    static let window = Self(style: .theme.accent.scale.background, cornerRadius: .theme.radius.regular, cornerRadiusStyle: .continuous)
}

extension FoundationUI.Modifier.Shadow: FoundationUISize {
    public typealias V = Self
    private static let color = Color.black.opacity(0.35)
    public static var xSmall    = Self(Self.color.opacity(0.5), radius: 2, x: 0, y: 2)
    public static var small     = Self(Self.color.opacity(0.78), radius: 2.5, x: 0, y: 2)
    public static var regular   = Self(Self.color, radius: 5, x: 0, y: 5)
    public static var large     = Self(Self.color, radius: 7, x: 0, y: 6)
    public static var xLarge    = Self(Self.color, radius: 8, x: 0, y: 6)
    public static var xxLarge   = Self(Self.color, radius: 10, x: 0, y: 7)
}

extension FoundationUI.Modifier {
    func border(_ style: Border) -> some View {
        content.modifier(style)
    }
    func background(_ style: Background) -> some View {
        content.modifier(style)
    }
    func shadow(_ style: Shadow) -> some View {
        content.modifier(style)
    }
}

#Preview {
    let color = Color.theme.accent
    return VStack {
        Text("Hello")
            .padding()
            .foregroundStyle(color.scale.text)
            .theme.border(.default)
            .theme.background(color.scale.elementActive,
                              cornerRadius: .theme.radius.regular,
                              shadow: .regular)
        Text("Hello")
            .padding()
            .foregroundStyle(color.scale.text)
            .theme.border(.default)
            .theme.background(color.scale.elementActive,
                              cornerRadius: .theme.radius.regular,
                              shadow: nil)
    }
    .padding()
    .theme.background(.theme.primary.scale.background)
}
