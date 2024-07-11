//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.SizeModifier {
    static func size(width: FoundationUI.Theme.Size.Token? = nil, height: FoundationUI.Theme.Size.Token? = nil) -> Self {
        FoundationUI.Modifier.SizeModifier(width: width, height: height)
    }
    static func size(_ square: FoundationUI.Theme.Size.Token) -> Self {
        FoundationUI.Modifier.SizeModifier(width: square, height: square)
    }
}

public extension FoundationUI.Modifier {
    struct SizeModifier: FoundationUIModifier {
        private let widthScale: FoundationUI.Theme.Size.Token?
        private let heightScale: FoundationUI.Theme.Size.Token?
        
        init(width: FoundationUI.Theme.Size.Token?, height: FoundationUI.Theme.Size.Token?) {
            self.widthScale = width
            self.heightScale = height
        }
        
        private var alignment: Alignment = .center
        
        private var width: CGFloat? {
            guard let widthScale else { return nil }
            return FoundationUI.theme.size(widthScale)
        }
        
        private var height: CGFloat? {
            guard let heightScale else { return nil }
            return FoundationUI.theme.size(heightScale)
        }
        
        public func body(content: Content) -> some View {
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

#Preview {
    VStack {
        Rectangle().foundation(.size(.xSmall))
        Rectangle().foundation(.size(.small))
        Rectangle().foundation(.size(.regular))
        Rectangle().foundation(.size(.large))
    }
    .padding()
}
