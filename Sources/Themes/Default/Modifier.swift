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
    private static let color = Color.black.opacity(0.35)
    public static var xSmall    = Self(.init(Self.color.opacity(0.8), radius: 3, x: 0, y: 3))
    public static var small     = Self(.init(Self.color, radius: 4, x: 0, y: 4))
    public static var regular   = Self(.init(Self.color, radius: 5, x: 0, y: 5))
    public static var large     = Self(.init(Self.color, radius: 7, x: 0, y: 6))
    public static var xLarge    = Self(.init(Self.color, radius: 8, x: 0, y: 6))
    public static var xxLarge   = Self(.init(Self.color, radius: 10, x: 0, y: 7))
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
    VStack {
        Text("Hello")
            .padding()
            .theme.border(.default)
//            .theme.background(.theme.accent.scale.background, cornerRadius: .theme.radius.regular)
            .theme.background(.window)
            .theme.shadow(.regular)
    }
    .padding()
    .theme.background(.theme.primary.scale.background)
}
