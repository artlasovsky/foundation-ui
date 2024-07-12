//
//  BackgroundModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.ModifierLibrary {
    struct BackgroundModifier<Style: ShapeStyle, S: Shape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        let style: Style
        let shape: S
        
        func body(content: Content) -> some View {
            content
                .background {
                    ShapeBuilder.resolveShape(shape, dynamicCornerRadius: dynamicCornerRadius)
                        .foregroundStyle(style)
                }
        }
    }
}


extension FoundationUI.Modifier {
    static func background<S: Shape, VM: ViewModifier>(
        _ color: FoundationUI.Theme.Color,
        in shape: S = .viewShape,
        modifier: VM = EmptyModifier()
    ) -> Modifier<Library.BackgroundModifier<FoundationUI.Theme.Color, S>> {
        .init(.init(style: color, shape: shape))
    }
    
    static func backgroundStyle<Style: ShapeStyle, S: Shape, VM: ViewModifier>(
        _ style: Style,
        in shape: S = .viewShape,
        modifier: VM = EmptyModifier()
    ) -> Modifier<Library.BackgroundModifier<Style, S>> {
        .init(.init(style: style, shape: shape))
    }
    
    static func backgroundColor<S: Shape, VM: ViewModifier>(
        _ color: Color,
        in shape: S = .viewShape,
        modifier: VM = EmptyModifier()
    ) -> Modifier<Library.BackgroundModifier<Color, S>> {
        .init(.init(style: color, shape: shape))
    }
    
    static func backgroundToken<S: Shape, VM: ViewModifier>(
        _ token: FoundationUI.Theme.Color.Token,
        in shape: S = .viewShape,
        modifier: VM = EmptyModifier()
    ) -> Modifier<Library.BackgroundModifier<FoundationUI.Theme.Color.Token, S>> {
        .init(.init(style: token, shape: shape))
    }
}

struct BackgroundModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Basic")
                .foundation(.padding(.regular))
                .foundation(.background(.primary.token(.fillEmphasized)))
            Text("Tinted")
                .foundation(.padding(.regular))
                .foundation(.backgroundToken(.fillEmphasized))
            Text("Shadow")
                .foundation(.padding(.regular))
                .foundation(.background(.primary.token(.background), in: .roundedRectangle(.regular)))
//                .foundation(.shadow(.regular, in: .roundedRectangle(.regular)))
            //
            ZStack {
                Text("Radius")
                    .foundation(.padding(.large))
                    .foundation(.backgroundToken(.fillEmphasized, in: .dynamicRoundedRectangle()))
                    .foundation(.padding(.small, adjustNestedCornerRadius: .sharp))
                    .foundation(.background(.primary, in: .dynamicRoundedRectangle()))
            }
            .foundation(.cornerRadius(.large))
            Text("Adj")
                .border(.blue.opacity(0.5))
                .foundation(.padding(.regular))
                .border(.green.opacity(0.5))
                .foundation(.backgroundToken(.fillEmphasized)
//                    .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
//                    .shadow(.regular)
//                    .cornerRadius(.regular)
                )
        }
        .foundation(.tint(.red))
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
