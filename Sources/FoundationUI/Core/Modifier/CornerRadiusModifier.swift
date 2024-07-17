//
//  CornerRadiusModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct CornerRadiusModifier: ViewModifier {
        @OptionalTokenValue<FoundationUI.Theme.Radius> var cornerRadius: CGFloat?
        
        init(cornerRadius: FoundationUI.Theme.Radius? = nil) {
            self._cornerRadius = .init(token: cornerRadius, value: Theme.radius, defaultValue: nil)
        }
        
        public func body(content: Content) -> some View {
            content
                .environment(\.dynamicCornerRadius, cornerRadius)
        }
    }
}

public extension FoundationUI.Modifier {
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
        .foundation(.background(.dynamic(.backgroundFaded)))
        .foundation(.cornerRadius(.xLarge))
        .padding()
    }
}
