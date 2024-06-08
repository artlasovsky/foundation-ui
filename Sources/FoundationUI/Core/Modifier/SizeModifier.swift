//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.SizeModifier {
    static func size(width: FoundationUI.Variable.Size? = nil, height: FoundationUI.Variable.Size? = nil) -> Self {
        FoundationUI.Modifier.SizeModifier(width: width, height: height)
    }
    static func size(_ side: FoundationUI.Variable.Size) -> Self {
        FoundationUI.Modifier.SizeModifier(width: side, height: side)
    }
}

public extension FoundationUI.Modifier {
    struct SizeModifier: FoundationUIModifier {
        private let width: FoundationUI.Variable.Size?
        private let height: FoundationUI.Variable.Size?
        
        init(width: FoundationUI.Variable.Size?, height: FoundationUI.Variable.Size?) {
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
