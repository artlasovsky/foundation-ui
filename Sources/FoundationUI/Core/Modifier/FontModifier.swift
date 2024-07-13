//
//  FontModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct FontModifier: ViewModifier {
        @TokenValue<FoundationUI.Theme.Font> private var font: Font
        
        init(_ token: FoundationUI.Theme.Font) {
            self._font = .init(token: token, value: Theme.font)
        }
        public func body(content: Content) -> some View {
            content
                .font(font)
        }
    }
}

public extension FoundationUI.Modifier {
    static func font(_ token: FoundationUI.Theme.Font) -> Modifier<Library.FontModifier> {
        .init(.init(token))
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
