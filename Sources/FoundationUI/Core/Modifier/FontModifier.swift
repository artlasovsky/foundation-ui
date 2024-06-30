//
//  FontModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.FontModifier {
    static func font(_ variable: FoundationUI.Theme.Font.Scale) -> Self {
        FoundationUI.Modifier.FontModifier(scale: variable)
    }
}

public extension FoundationUI.Modifier {
    struct FontModifier: FoundationUIModifier {
        public let scale: FoundationUI.Theme.Font.Scale
        
        private var font: Font {
            FoundationUI.theme.font(scale)
        }
        public func body(content: Content) -> some View {
            content.font(font)
        }
    }
}

#Preview {
    VStack {
        Text("xxSmall").foundation(.font(.xxSmall))
        Text("xSmall").foundation(.font(.xSmall))
        Text("small").foundation(.font(.small))
        Text("regular").foundation(.font(.regular))
        Text("large").foundation(.font(.large))
        Text("xLarge").foundation(.font(.xLarge))
        Text("xxLarge").foundation(.font(.xxLarge))
    }
    .padding()
}
