//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.SizeModifier {
    static func size(width: TrussUI.Variable.Size? = nil, height: TrussUI.Variable.Size? = nil) -> Self {
        TrussUI.Modifier.SizeModifier(width: width, height: height)
    }
    static func size(_ side: TrussUI.Variable.Size) -> Self {
        TrussUI.Modifier.SizeModifier(width: side, height: side)
    }
}

public extension TrussUI.Modifier {
    struct SizeModifier: TrussUIModifier {
        private let width: TrussUI.Variable.Size?
        private let height: TrussUI.Variable.Size?
        
        init(width: TrussUI.Variable.Size?, height: TrussUI.Variable.Size?) {
            self.width = width
            self.height = height
        }
        
        private var alignment: Alignment = .center
        
        public func body(content: Content) -> some View {
            let width = width?.value
            let height = height?.value
            if width == .infinity || height == .infinity {
                content.frame(maxWidth: width, maxHeight: height, alignment: alignment)
            } else {
                content.frame(width: width, height: height, alignment: alignment)
            }
        }
        
        public func alignment(_ alignment: Alignment) -> Self {
            var copy = self
            copy.alignment = alignment
            return copy
        }
    }
}
