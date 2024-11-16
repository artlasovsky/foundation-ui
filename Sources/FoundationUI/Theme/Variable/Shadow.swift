//
//  Shadow.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
    public struct Shadow: FoundationVariableWithValue {
        public func callAsFunction(_ token: Self) -> Configuration {
            token.value
        }
        
        public var value: Configuration
        
        public init() {
            self = .init(color: .clear, radius: 0)
        }
        
        public init(color: Theme.Color, radius: CGFloat, spread: CGFloat = 0, x: CGFloat = 0, y: CGFloat = 0) {
            self.value = .init(color: color, radius: radius, spread: spread, x: x, y: y)
        }
        
        public init(value: Configuration) {
            self.value = value
        }
        
        public struct Configuration: Sendable, Hashable {
            var color: Theme.Color
            var radius: CGFloat
            var spread: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
        }
    }
}

struct ShadowPreview: PreviewProvider {
    struct ShadowSample: View {
        let label: String
        let value: Theme.Shadow
        var body: some View {
            Text(label)
                .foundation(.size(.small.up(.half)))
                .foundation(.background(.white))
                .foundation(.backgroundShadow(value))
                .foundation(.cornerRadius(.regular))
                .foundation(.font(.xxSmall))
        }
    }
    static var previews: some View {
        VStack {
            ShadowSample(label: "xxSmall", value: .xxSmall)
            ShadowSample(label: "xSmall", value: .xSmall)
            ShadowSample(label: "small", value: .small)
            ShadowSample(label: "regular", value: .regular)
            ShadowSample(label: "large", value: .large)
            ShadowSample(label: "xLarge", value: .xLarge)
            ShadowSample(label: "xxLarge", value: .xxLarge)
        }
        .padding()
    }
}
