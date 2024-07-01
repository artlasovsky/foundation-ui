//
//  MaskModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.LinearGradientMaskModifier {
    static func gradientMask(_ token: FoundationUI.Theme.LinearGradient.Token?) -> Self {
        .init(token: token)
    }
    
    static func gradientMask(_ colors: [FoundationUI.Theme.Color], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> Self {
        .init(token: .init(colors: colors, startPoint: startPoint, endPoint: endPoint))
    }
}

public extension FoundationUI.Modifier {
    struct LinearGradientMaskModifier: FoundationUIModifier {
        let token: FoundationUI.Theme.LinearGradient.Token?
        
        public func body(content: Content) -> some View {
            if let token {
                content.mask {
                    Rectangle()
                        .foregroundStyle(FoundationUI.theme.linearGradient(token))
                    }
            } else {
                content
            }
        }
    }
}


#if DEBUG
private extension FoundationUI.DefaultTheme.Variable.LinearGradient.Token {
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
