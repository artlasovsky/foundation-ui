//
//  MaskModifier.swift
//  
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension TrussUIModifier where Self == TrussUI.Modifier.LinearGradientMaskModifier {
    static func gradientMask(_ variable: TrussUI.Variable.LinearGradient?) -> Self {
        .init(linearGradient: variable)
    }
    
    static func gradientMask(_ colors: [TrussUI.DynamicColor], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> Self {
        .init(linearGradient: .init(colors, startPoint: startPoint, endPoint: endPoint))
    }
}

public extension TrussUI.Modifier {
    struct LinearGradientMaskModifier: TrussUIModifier {
        let linearGradient: TrussUI.Variable.LinearGradient?
        
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

private extension TrussUI.Variable.LinearGradient {
    static let clearTop = Self([.clear, .black], startPoint: .top, endPoint: .bottom)
}

struct MaskModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .truss(.size(.large))
                .truss(.gradientMask(.clearTop))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
