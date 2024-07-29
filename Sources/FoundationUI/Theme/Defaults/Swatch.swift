//
//  Swatch.swift
//
//
//  Created by Art Lasovsky on 29/07/2024.
//

import Foundation
import SwiftUI

public extension Theme.Padding {
    func swatch() -> some View {
        Swatch("Padding", value: Theme.default.padding) { title, value in
            HStack {
                Text(title)
                    .foundation(.foreground(.primary.variant(.textSubtle)))
                    .foundation(.size(width: .value(.infinity), alignment: .trailing))
                Text(String(format: "%.2f", value))
                    .foundation(.size(width: .value(.infinity), alignment: .leading))
            }
            .frame(width: 150)
        }
    }
}

struct Swatch<Value: FoundationVariable & DefaultFoundationVariableTokenScale, Content: View>: View where Value.Token == Value {
    let title: String
    let content: (_ title: String, _ value: Value.Result) -> Content
    let value: Value
    
    init(_ title: String, value: Value, content: @escaping (_ title: String, _ value: Value.Result) -> Content) {
        self.title = title
        self.content = content
        self.value = value
    }
    
    public var body: some View {
        VStack {
            Text(title)
            ForEach(Value.all) { token in
                tokenView(token.name, token.value)
            }
        }
        .foundation(.padding())
    }
    
    func tokenView(_ title: String, _ token: Value.Token) -> some View {
        content(title, value(token))
    }
}
//
struct Swatch_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Theme.default.padding.swatch()
            Theme.default.shadow.swatch()
        }
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

