//
//  ForegroundModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.ForegroundModifier {
    static func foreground(_ tint: TrussUI.DynamicColor) -> Self {
        .init(tint: tint, keyPath: nil)
    }
    
    static func foreground(_ keyPath: TrussUI.DynamicColor.VariationKeyPath = \.text) -> Self {
        .init(tint: nil, keyPath: keyPath)
    }
}

public extension TrussUI.Modifier {
    struct ForegroundModifier: TrussUIModifier {
        @DynamicColorTint private var tint
        
        init(tint: TrussUI.DynamicColor?, keyPath: TrussUI.DynamicColor.VariationKeyPath?) {
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
                .truss(.foreground(.red))
            Text("Foreground")
                .truss(.foreground(\.text))
                .truss(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
