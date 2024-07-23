//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct SizeModifier: ViewModifier {
        @OptionalTokenValue<Theme.Size> private var width: CGFloat?
        @OptionalTokenValue<Theme.Size> private var height: CGFloat?
        private let alignment: Alignment
        
        init(width: Theme.Size?, height: Theme.Size?, alignment: Alignment) {
            self._width = .init(token: width, value: Theme.default.size, defaultValue: nil)
            self._height = .init(token: height, value: Theme.default.size, defaultValue: nil)
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

public extension FoundationModifier {
    static func size(
        width: Theme.Size? = nil,
        height: Theme.Size? = nil,
        alignment: Alignment = .center
    ) -> FoundationModifier<Library.SizeModifier> {
        .init(.init(width: width, height: height, alignment: alignment))
    }
    
    static func size(
        _ square: Theme.Size,
        alignment: Alignment = .center
    ) -> FoundationModifier<Library.SizeModifier> {
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
