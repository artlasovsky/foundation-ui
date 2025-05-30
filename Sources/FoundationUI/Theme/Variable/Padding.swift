//
//  Padding.swift
//  
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public extension Theme {
    @frozen
	struct Padding: FoundationVariableWithCGFloatValue {
        public var value: CGFloat
		public var environmentAdjustment: EnvironmentAdjustment?
        init() {
            self.value = 0
        }
        public init(value: CGFloat) {
            self.value = value
        }
    }
}

struct Padding_Preview: PreviewProvider {
    struct PaddingTest: View {
        let label: String
        let value: Theme.Padding
        var body: some View {
            VStack(alignment: .leading, spacing: 1) {
                Text("\(label) \(Int(value.value))")
                    .font(.caption)
                Rectangle()
                    .frame(width: value.value)
                    .frame(height: 14)
            }
        }
    }
    static var previews: some View {
        VStack(alignment: .leading) {
            PaddingTest(label: "xxSmall", value: .xxSmall)
            PaddingTest(label: "xSmall", value: .xSmall)
            PaddingTest(label: "small", value: .small)
            PaddingTest(label: "regular", value: .regular)
            PaddingTest(label: "large", value: .large)
            PaddingTest(label: "xLarge", value: .xLarge)
            PaddingTest(label: "xxLarge", value: .xxLarge)
			Text("\(Theme.Padding.large.value)")
			Text("\(Theme.Padding.large.resolve(theme: .none))")
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

