//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.ModifierLibrary {
    struct CornerRadiusModifier: ViewModifier {
        @OptionalTokenValue<FoundationUI.Theme.Radius> var cornerRadius: CGFloat?
        
        init(cornerRadius: FoundationUI.Theme.Radius? = nil) {
            self._cornerRadius = .init(token: cornerRadius, value: theme.radius, defaultValue: nil)
        }
        
        func body(content: Content) -> some View {
            content
                .environment(\.dynamicCornerRadius, cornerRadius)
        }
    }
}

extension FoundationUI.Modifier {
    static func cornerRadius(_ cornerRadius: FoundationUI.Theme.Radius?) -> Modifier<Library.CornerRadiusModifier> {
        .init(.init(cornerRadius: cornerRadius))
    }
}

// MARK: - EnvironmentValues
private struct FoundationUICornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

internal extension EnvironmentValues {
    var dynamicCornerRadius: CGFloat? {
        get { self[FoundationUICornerRadiusKey.self] }
        set { self[FoundationUICornerRadiusKey.self] = newValue }
    }
}

#Preview {
    VStack {
        Text("Dynamic Radius")
            .frame(maxWidth: .infinity)
            .foundation(.padding(.regular, .vertical))
            // Use Dynamic Corner Radius
            .foundation(.backgroundToken(.fill))
//            .foundation(.back)
            .foundation(.padding(.small))
        Spacer()
        Text("Custom Radius")
            .frame(maxWidth: .infinity)
            .foundation(.padding(.regular, .vertical))
            // Set Corner Radius manually
            .foundation(
                .backgroundToken(.fill, in: .rect(cornerRadius: 12))
            )
            .foundation(.padding(.small))
    }
    .frame(width: 200, height: 150)
    .foundation(.backgroundToken(.backgroundFaded))
    .foundation(.cornerRadius(.xLarge))
    .padding()
}
