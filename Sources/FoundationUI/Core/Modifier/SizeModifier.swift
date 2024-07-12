//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.ModifierLibrary {
    struct SizeModifier: ViewModifier {
        @OptionalTokenValue<FoundationUI.Theme.Size> private var width: CGFloat?
        @OptionalTokenValue<FoundationUI.Theme.Size> private var height: CGFloat?
        private let alignment: Alignment
        
        init(width: FoundationUI.Theme.Size.Token?, height: FoundationUI.Theme.Size.Token?, alignment: Alignment) {
            self._width = .init(token: width, value: theme.size, defaultValue: nil)
            self._height = .init(token: height, value: theme.size, defaultValue: nil)
            self.alignment = alignment
        }
        
        public func body(content: Content) -> some View {
            if width == .infinity || height == .infinity {
                content.frame(maxWidth: width, maxHeight: height, alignment: alignment)
            } else {
                content.frame(width: width, height: height, alignment: alignment)
            }
        }
    }
}

extension FoundationUI.Modifier {
    static func size(
        width: FoundationUI.Theme.Size.Token? = nil,
        height: FoundationUI.Theme.Size.Token? = nil,
        alignment: Alignment = .center
    ) -> Modifier<Library.SizeModifier> {
        .init(.init(width: width, height: height, alignment: alignment))
    }
    
    static func size(
        _ square: FoundationUI.Theme.Size.Token,
        alignment: Alignment = .center
    ) -> Modifier<Library.SizeModifier> {
        .init(.init(width: square, height: square, alignment: alignment))
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
