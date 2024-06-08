//
//  MaskModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.LinearGradientMaskModifier {
    static func gradientMask(_ variable: FoundationUI.Variable.LinearGradient?) -> Self {
        .init(linearGradient: variable)
    }
    
    static func gradientMask(_ colors: [FoundationUI.DynamicColor], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> Self {
        .init(linearGradient: .init(colors, startPoint: startPoint, endPoint: endPoint))
    }
}

public extension FoundationUI.Modifier {
    struct LinearGradientMaskModifier: FoundationUIModifier {
        let linearGradient: FoundationUI.Variable.LinearGradient?
        
        public func body(content: Content) -> some View {
            if let linearGradient {
                content.mask {
                        linearGradient
                    }
            } else {
                content
            }
        }
    }
}

private extension FoundationUI.Variable.LinearGradient {
    static let clearTop = Self([.clear, .black], startPoint: .top, endPoint: .bottom)
}

struct MaskModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .foundation(.size(.large))
                .foundation(.gradientMask(.clearTop))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
