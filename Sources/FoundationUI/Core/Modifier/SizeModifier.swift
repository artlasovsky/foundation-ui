//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct SizeModifier: ViewModifier {
        @OptionalTokenValue<FoundationUI.Theme.Size> private var width: CGFloat?
        @OptionalTokenValue<FoundationUI.Theme.Size> private var height: CGFloat?
        private let alignment: Alignment
        
        init(width: FoundationUI.Theme.Size?, height: FoundationUI.Theme.Size?, alignment: Alignment) {
            self._width = .init(token: width, value: Theme.size, defaultValue: nil)
            self._height = .init(token: height, value: Theme.size, defaultValue: nil)
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

public extension FoundationUI.Modifier {
    static func size(
        width: FoundationUI.Theme.Size? = nil,
        height: FoundationUI.Theme.Size? = nil,
        alignment: Alignment = .center
    ) -> Modifier<Library.SizeModifier> {
        .init(.init(width: width, height: height, alignment: alignment))
    }
    
    static func size(
        _ square: FoundationUI.Theme.Size,
        alignment: Alignment = .center
    ) -> Modifier<Library.SizeModifier> {
        .init(.init(width: square, height: square, alignment: alignment))
    }
}

struct SizeModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle().foundation(.size(.xSmall))
            Rectangle().foundation(.size(.small))
            Rectangle().foundation(.size(.regular))
            Rectangle().foundation(.size(.large))
        }
        .padding()
    }
}
