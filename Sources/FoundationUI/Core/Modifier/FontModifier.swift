//
//  FontModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUIModifier where Self == FoundationUI.Modifier.FontModifier {
    static func font(_ token: FoundationUI.Theme.Font.Token) -> Self {
        FoundationUI.Modifier.FontModifier(token: token)
    }
}

public extension FoundationUI.Modifier {
    struct FontModifier: FoundationUIModifier {
        public let token: FoundationUI.Theme.Font.Token
        
        private var font: Font {
            FoundationUI.theme.font(token)
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
