//
//  ForegroundModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.ForegroundModifier {
    static func foreground(_ tint: FoundationUI.DynamicColor) -> Self {
        .init(tint: tint, keyPath: nil)
    }
    
    static func foreground(_ keyPath: FoundationUI.DynamicColor.VariationKeyPath = \.text) -> Self {
        .init(tint: nil, keyPath: keyPath)
    }
}

public extension FoundationUI.Modifier {
    struct ForegroundModifier: FoundationUIModifier {
        @DynamicColorTint private var tint
        
        init(tint: FoundationUI.DynamicColor?, keyPath: FoundationUI.DynamicColor.VariationKeyPath?) {
            self._tint = .init(tint, keyPath: keyPath)
        }
        
        public func body(content: Content) -> some View {
            content.foregroundStyle(tint)
        }
    }
}


struct ForegroundModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Foreground")
                .foundation(.foreground(.red))
            Text("Foreground")
                .foundation(.foreground(\.text))
                .foundation(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
