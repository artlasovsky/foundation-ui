//
//  Font.swift
//
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Font

extension Theme {
    @frozen
	public struct Font: FoundationVariableWithValue {
        public typealias Result = SwiftUI.Font
        
        public var value: SwiftUI.Font
		public var environmentAdjustment: EnvironmentAdjustment?
        
        public init() { self = .init(.body) }
        
        public init(value: SwiftUI.Font) {
            self.value = value
        }
		
		public static func family<Weight: FontWeight>(_ name: Theme.Font.Family<Weight>, size: CGFloat, weight: Weight = .defaultWeight, scaling: FontFamilyScaling = .textStyle(.body)) -> Self {
			.init(value: .foundationFamily(name, size: size, weight: weight, scaling: scaling))
		}
    }
}


// MARK: - Preview

struct Font_Preview: PreviewProvider {
    struct FontTest: View {
        let label: String
        let value: Theme.Font
        var body: some View {
            VStack(alignment: .leading, spacing: 1) {
                Text("\(label)")
                    .font(value.value)
            }
        }
    }
    static var previews: some View {
        VStack(alignment: .leading) {
            FontTest(label: "xxSmall", value: .xxSmall)
            FontTest(label: "xSmall", value: .xSmall)
            FontTest(label: "small", value: .small)
            FontTest(label: "regular", value: .regular)
            FontTest(label: "large", value: .large)
            FontTest(label: "xLarge", value: .xLarge)
            FontTest(label: "xxLarge", value: .xxLarge)
			Divider()
				.frame(maxWidth: 200)
				.padding(.bottom, 16)
			Text("Font Family")
				.foundation(.font(.init(.foundationFamily(.system, size: 12, weight: .bold))))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
