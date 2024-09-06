//
//  Font.swift
//
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
    public struct Font: FoundationVariableWithValue {
        public typealias Result = SwiftUI.Font
        
        public func callAsFunction(_ scale: Self) -> SwiftUI.Font {
            scale.value
        }
        
        public var value: SwiftUI.Font
        
        public init() { self = .init(.body) }
        
        public init(value: SwiftUI.Font) {
            self.value = value
        }
    }
}



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
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
