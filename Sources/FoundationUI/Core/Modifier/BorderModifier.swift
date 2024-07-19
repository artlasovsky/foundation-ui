//
//  BorderModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationUI.ModifierLibrary {
    struct BorderModifier<Style: ShapeStyle, S: InsettableShape>: ViewModifier {
        @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
        let style: Style
        let shape: S
        let width: CGFloat
        let placement: BorderPlacement
        public func body(content: Content) -> some View {
            content
                .overlay {
                    ShapeBuilder.resolveInsettableShape(shape, inset: padding, dynamicCornerRadius: dynamicCornerRadius)
                        .stroke(lineWidth: width)
                        .foregroundStyle(style)
                }
        }
        
        private var padding: CGFloat {
            let offset: CGFloat = width / 2
            switch placement {
            case .inside: return offset
            case .outside: return -offset
            case .center: return 0
            }
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
        in shape: S = .dynamicRoundedRectangle()
    ) -> Modifier<Library.BorderModifier<FoundationUI.Theme.Color, S>> {
        .init(.init(style: color, shape: shape, width: width, placement: placement))
    }
    static func borderStyle<Style: ShapeStyle, S: Shape>(
        _ style: Style,
        width: CGFloat = 1,
        placement: Library.BorderPlacement = .inside,
        in shape: S = .dynamicRoundedRectangle()
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
                        .border(.red, width: 2, placement: .inside, in: .dynamicRoundedRectangle())
                    )
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("")
                    .foundation(.size(.regular))
                    .foundation(
                        .border(.blue, width: 2, placement: .outside, in: .dynamicRoundedRectangle())
                    )
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
                Text("Border")
                    .foundation(.size(.regular))
                    .foundation(.border(.primary, width: 2, placement: .center))
                    .foundation(.background(.red))
                    .foundation(.cornerRadius(.regular))
                    .opacity(0.5)
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
