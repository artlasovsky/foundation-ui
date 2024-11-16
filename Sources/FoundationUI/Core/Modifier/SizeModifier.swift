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
		@OptionalTokenValue<Theme.Length> private var width: CGFloat?
		@OptionalTokenValue<Theme.Length> private var height: CGFloat?
        private let alignment: Alignment
        
		init(width: Theme.Length?, height: Theme.Length?, alignment: Alignment) {
			self._width = .init(token: width, value: Theme.default.length, defaultValue: nil)
			self._height = .init(token: height, value: Theme.default.length, defaultValue: nil)
            self.alignment = alignment
        }
		
		init(size: Theme.Size, alignment: Alignment) {
			self.init(width: size.value.width, height: size.value.height, alignment: alignment)
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
		width: Theme.Length? = nil,
		height: Theme.Length? = nil,
        alignment: Alignment = .center
    ) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
        .init(.init(width: width, height: height, alignment: alignment))
    }
    
    static func size(
		square: Theme.Length,
        alignment: Alignment = .center
    ) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
        .init(.init(width: square, height: square, alignment: alignment))
    }
	
	static func size(
		_ size: Theme.Size,
		alignment: Alignment = .center
	) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
		.init(.init(size: size, alignment: alignment))
	}
}

private extension Theme.Size {
	static let cgFloat = Theme.Size(width: 40, height: 60)
	static let test = Theme.Size(width: .large, height: .regular)
}

struct SizeModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
			Rectangle().foundation(.size(square: .xSmall))
			Rectangle().foundation(.size(square: .small))
			Rectangle().foundation(.size(square: .regular))
			Rectangle().foundation(.size(square: .large))
			Rectangle().foundation(.size(.cgFloat))
			Rectangle().foundation(.size(.test))
        }
        .padding()
    }
}
