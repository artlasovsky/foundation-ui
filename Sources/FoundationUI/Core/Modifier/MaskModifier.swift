//
//  MaskModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.LinearGradientMaskModifier {
    static func gradientMask(_ scale: FoundationUI.Theme.LinearGradient.Scale?) -> Self {
        .init(scale: scale)
    }
    
    static func gradientMask(_ colors: [FoundationUI.Theme.Color], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> Self {
        .init(scale: .init(colors: colors, startPoint: startPoint, endPoint: endPoint))
    }
}

public extension FoundationUI.Modifier {
    struct LinearGradientMaskModifier: FoundationUIModifier {
        let scale: FoundationUI.Theme.LinearGradient.Scale?
        
        public func body(content: Content) -> some View {
            if let scale {
                content.mask {
                    Rectangle()
                        .foregroundStyle(FoundationUI.theme.linearGradient(scale))
                    }
            } else {
                content
            }
        }
    }
}


#if DEBUG
private extension FoundationUI.DefaultTheme.Token.LinearGradient.Scale {
    static let clearTop = Self(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
}
#endif

#Preview {
    VStack {
        Rectangle()
            .foundation(.size(.large))
            .foundation(.gradientMask(.clearTop))
            .foregroundStyle(LinearGradient.foundation(.clearTop))
    }
    .padding()
}
