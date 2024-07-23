//
//  Radius.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
    public struct Radius: DefaultFoundationAdjustableVariableWithMultiplier {
        public var value: CGFloatWithMultiplier
        public var adjust: @Sendable (CGFloatWithMultiplier) -> CGFloat
        
        public init(value configuration: CGFloatWithMultiplier) {
            value = configuration
            adjust = { _ in configuration.base }
        }
        public init(adjust: @escaping @Sendable (CGFloatWithMultiplier) -> CGFloat) {
            value = .init(base: 0, multiplier: 0)
            self.adjust = adjust
        }
        
        public func callAsFunction(_ token: Self) -> CGFloat {
            token.adjust(value).precise(0)
        }
    }
}

extension Theme.Radius {
    static let zero = Self(value: 0)
}

struct RadiusPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(Theme.Radius.Token.all) { token in
                RoundedRectangle(cornerRadius: .foundation(.radius(token.value)))
                    .foundation(.size(.large))
                    .foundation(.foreground(.dynamic(.solid)))
                    .overlay {
                        Text(token.name)
                            .foundation(.foreground(.dynamic(.background)))
                            .foundation(.font(.xSmall))
                    }
            }
        }
        .foundation(.padding(.regular))
    }
}
