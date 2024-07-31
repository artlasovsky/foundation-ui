//
//  Swatch.swift
//
//
//  Created by Art Lasovsky on 29/07/2024.
//

import Foundation
import SwiftUI

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
                .foundation(.foreground(.dynamic(.textSubtle)))
                .foundation(.padding(.small, .bottom))
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

struct CGFloatSwatchLayout: View {
    let title: String
    let value: CGFloat
    
    init(_ title: String, _ value: CGFloat) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
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

struct Swatch_Preview: PreviewProvider {
    static var previews: some View {
        HStack {
            Theme.Padding.swatch()
            Theme.Shadow.swatch()
        }
        .foundation(.padding())
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

