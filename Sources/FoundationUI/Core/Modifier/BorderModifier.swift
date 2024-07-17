//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct BorderModifier<Style: ShapeStyle, S: Shape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        let style: Style
        let shape: S
        let width: CGFloat
        let placement: BorderPlacement
        public func body(content: Content) -> some View {
            content
                .overlay {
                    ShapeBuilder.resolveShape(shape, dynamicCornerRadius: cornerRadius)
                        .stroke(lineWidth: width)
                        .foregroundStyle(style)
                        .padding(padding)
                }
        }
        
        private var padding: CGFloat {
            var offset: CGFloat = width / 2
            if offset < 0.5 {
                offset = 0
            }
            switch placement {
            case .inside: return offset
            case .outside: return -offset
            case .center: return 0
            }
        }
        
        private var cornerRadius: CGFloat? {
            guard let dynamicCornerRadius else { return nil }
            return dynamicCornerRadius - padding
        }
        
    }
    enum BorderPlacement {
        case inside
        case outside
        case center
    }
}

public extension FoundationUI.Modifier {
    static func border<S: Shape>(
        _ color: FoundationUI.Theme.Color,
        width: CGFloat = 1,
        placement: Library.BorderPlacement = .inside,
        in shape: S = .viewShape
    ) -> Modifier<Library.BorderModifier<FoundationUI.Theme.Color, S>> {
        .init(.init(style: color, shape: shape, width: width, placement: placement))
    }
    static func borderStyle<Style: ShapeStyle, S: Shape>(
        _ style: Style,
        width: CGFloat = 1,
        placement: Library.BorderPlacement = .inside,
        in shape: S = .viewShape
    ) -> Modifier<Library.BorderModifier<Style, S>> {
        .init(.init(style: style, shape: shape, width: width, placement: placement))
    }
}

#if DEBUG
struct BorderModifier_Preview: PreviewProvider {
    struct Test: View {
        @Environment(\.self) private var env
        let tint: FoundationUI.DynamicColor? = nil
        
        var color: FoundationUI.DynamicColor {
            tint ?? env.dynamicTint.color
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
