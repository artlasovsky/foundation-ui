//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.CornerRadiusModifier {
    static func cornerRadius(_ token: FoundationUI.Theme.Radius.Token?) -> Self {
        FoundationUI.Modifier.CornerRadiusModifier(scale: token)
    }
}
public extension FoundationUI.Modifier {
    struct CornerRadiusModifier: FoundationUIModifier {
        let scale: FoundationUI.Theme.Radius.Token?
        
        private var value: CGFloat? {
            guard let scale else { return nil }
            return FoundationUI.theme.radius(scale)
        }
        
        public func body(content: Content) -> some View {
            content.environment(\.dynamicCornerRadius, value)
        }
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
            .foundation(.padding(.regular).edges(.vertical))
            // Use Dynamic Corner Radius
            .foundation(.backgroundTinted(.fill))
            .foundation(.padding(.small))
        Spacer()
        Text("Custom Radius")
            .frame(maxWidth: .infinity)
            .foundation(.padding(.regular).edges(.vertical))
            // Set Corner Radius manually
            .foundation(
                .backgroundTinted(.fill)
                .cornerRadius(.init(value: 12))
            )
            .foundation(.padding(.small))
    }
    .frame(width: 200, height: 150)
    .foundation(.backgroundTinted(.backgroundFaded))
    .foundation(.cornerRadius(.xLarge))
    .padding()
}
