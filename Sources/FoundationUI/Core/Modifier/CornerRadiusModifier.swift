//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct CornerRadiusModifier: ViewModifier {
        @OptionalTokenValue<Theme.Radius> var cornerRadius: CGFloat?
        var style: RoundedCornerStyle
        
        init(cornerRadius: Theme.Radius? = nil, style: RoundedCornerStyle) {
            self._cornerRadius = .init(
                token: cornerRadius,
                value: Theme.default.radius,
                defaultValue: nil
            )
            self.style = style
        }
        
        public func body(content: Content) -> some View {
            content
                .environment(\.dynamicCornerRadius, cornerRadius)
                .environment(\.dynamicCornerRadiusStyle, style)
        }
    }
}

public extension FoundationModifier {
    static func cornerRadius(_ cornerRadius: Theme.Radius?, style: RoundedCornerStyle = .continuous) -> FoundationModifier<FoundationModifierLibrary.CornerRadiusModifier> {
        .init(.init(cornerRadius: cornerRadius, style: style))
    }
}

// MARK: - EnvironmentValues
private struct FoundationUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}
private struct FoundationUICornerRadiusStyleKey: EnvironmentKey {
    static let defaultValue: RoundedCornerStyle = .continuous
}

internal extension EnvironmentValues {
    var dynamicCornerRadius: CGFloat? {
        get { self[FoundationUICornerRadiusKey.self] }
        set { self[FoundationUICornerRadiusKey.self] = newValue }
    }
    var dynamicCornerRadiusStyle: RoundedCornerStyle {
        get { self[FoundationUICornerRadiusStyleKey.self] }
        set { self[FoundationUICornerRadiusStyleKey.self] = newValue }
    }
}

struct CornerRadiusModifiefPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Dynamic Radius")
                .frame(maxWidth: .infinity)
                .foundation(.padding(.regular, .vertical))
                // Use Dynamic Corner Radius
                .foundation(.background(.dynamic(.fill)))
    //            .foundation(.back)
                .foundation(.padding(.small))
            Spacer()
            Text("Custom Radius")
                .frame(maxWidth: .infinity)
                .foundation(.padding(.regular, .vertical))
                // Set Corner Radius manually
                .foundation(
                    .background(.dynamic(.fill), in: .rect(cornerRadius: 12))
                )
                .foundation(.padding(.small))
        }
        .frame(width: 200, height: 150)
        .foundation(.background(.dynamic(.backgroundSubtle)))
        .foundation(.cornerRadius(.xLarge))
        .padding()
    }
}
