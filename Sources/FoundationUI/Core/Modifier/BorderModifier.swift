//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

extension FoundationUI.ModifierLibrary {
    struct BorderModifier<Style: ShapeStyle, S: Shape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        let style: Style
        let shape: S
        let width: CGFloat
        func body(content: Content) -> some View {
            content
                .overlay {
                    ShapeBuilder.resolveShape(shape, dynamicCornerRadius: dynamicCornerRadius)
                        .stroke(lineWidth: width)
                        .foregroundStyle(style)
                }
        }
    }
}

extension FoundationUI.Modifier {
    static func border<S: Shape>(
        _ color: FoundationUI.Theme.Color,
        width: CGFloat = 1,
        in shape: S = .viewShape
    ) -> Modifier<Library.BorderModifier<FoundationUI.Theme.Color, S>> {
        .init(.init(style: color, shape: shape, width: width))
    }
    static func borderStyle<Style: ShapeStyle, S: Shape>(
        _ style: Style,
        width: CGFloat = 1,
        in shape: S = .viewShape
    ) -> Modifier<Library.BorderModifier<Style, S>> {
        .init(.init(style: style, shape: shape, width: width))
    }
    
    static func borderToken<S: Shape>(
        _ token: FoundationUI.Theme.Color.Token,
        width: CGFloat = 1,
        in shape: S = .viewShape
    ) -> Modifier<Library.BorderModifier<FoundationUI.Theme.Color.Token, S>> {
        .init(.init(style: token, shape: shape, width: width))
    }
    
    enum Placement {
        case inside
        case center
        case outside
        
        func getPaddingOffset(forWidth width: CGFloat) -> CGFloat {
            switch self {
            case .center: 0
            case .inside: width / 2
            case .outside: width / -2
            }
        }
    }
    
    static func roundedBorder<Style: ShapeStyle>(
        _ style: Style,
        width: CGFloat = 1,
        placement: Placement
    ) -> Modifier<Library.BorderModifier<Style, DynamicRoundedRectangle>> {
        .init(.init(
            style: style,
            shape: DynamicRoundedRectangle(
                padding: placement.getPaddingOffset(forWidth: width)
            ),
            width: width
        ))
    }
}

#if DEBUG
struct BorderModifier_Preview: PreviewProvider {
    struct Test: View {
        @Environment(\.self) private var env
        let tint: FoundationUI.DynamicColor? = nil
        
        var color: FoundationUI.DynamicColor {
            tint ?? env.dynamicColorTint
        }
        
        var body: some View {
            ZStack {
                Text("")
                    .foundation(.size(.regular))
                    .foundation(
                        .border(.primary, width: 2, in: .dynamicRoundedRectangle())
                    )
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("Border")
                    .foundation(.size(.regular))
                    .foundation(.border(.primary, width: 2))
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
//                Text("")
//                    .foundation(.size(.regular))
////                    .foundation(.backgroundTinted(.fillFaded))
//                    .foundation(
//                        .borderTinted(.fill)
//                        .width(2)
//                        .placement(.outside)
//                        .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
//                    )
//                    .foundation(.cornerRadius(.regular))
//                    .opacity(0.5)
            }
        }
    }
    static var previews: some View {
        ZStack {
            Test()
            Test().foundation(.tint(.red))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
#endif
