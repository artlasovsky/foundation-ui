//
//  Padding.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public extension Theme {
    @frozen
    struct Padding: DefaultFoundationAdjustableVariableWithMultiplier {
        public typealias Result = CGFloat
        public let value: CGFloatWithMultiplier
        public let adjust: @Sendable (CGFloatWithMultiplier) -> CGFloat
        
        public init(value: CGFloatWithMultiplier) {
            self.value = value
            self.adjust = { _ in value.base }
        }
        
        public init(adjust: @escaping @Sendable (CGFloatWithMultiplier) -> CGFloat) {
            self.adjust = adjust
            self.value = .init(base: 0, multiplier: 0)
        }
    }
}

public extension Theme.Padding {
    static func swatch() -> some View {
        Swatch("Padding", value: Theme.default.padding) {
            CGFloatSwatchLayout($0, $1)
        }
    }
}

struct Padding_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Theme.Padding.swatch()
        }
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

