//
//  FontModifier.swift
//
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct FontModifier: ViewModifier {
		@Environment(\.self) private var environment
		let fontToken: Theme.Font
        
        public func body(content: Content) -> some View {
            content
                .font(font)
        }
		
		private var font: Font {
			fontToken.resolve(in: environment)
		}
    }
}

public extension FoundationModifier {
    static func font(_ token: Theme.Font) -> FoundationModifier<FoundationModifierLibrary.FontModifier> {
		.init(.init(fontToken: token))
    }
}

struct FontModifierPreview: PreviewProvider {
    static var previews: some View {
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
}
