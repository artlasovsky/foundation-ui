//
//  FoundationUI.swift
//
//
//  Created by Art Lasovsky on 20/12/2023.
//

import Foundation
import SwiftUI

public struct FoundationUI {
    private init() {}
}

// Test
extension FoundationUI.Variable.Radius {
    public static var button: FoundationUI.Variable.Radius = .init(value: 7)
}

extension FoundationUI.DynamicColor {
    static let brand: Self = .init(.init(hue: 0.5, saturation: 0.8, brightness: 1))
}

struct Testing_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Button")
                .foundation(.padding(.regular))
                .foundation(.foreground(.primary.text))
                .foundation(.background(\.fill).cornerRadius(.button))
                .foundation(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
