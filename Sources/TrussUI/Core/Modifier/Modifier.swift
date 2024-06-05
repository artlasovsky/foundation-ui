//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension TrussUI {
    public enum Modifier {}
}

public protocol TrussUIModifier: ViewModifier {}

// MARK: - View extension
public extension View {
    func truss(_ modifier: some TrussUIModifier) -> some View {
        self.modifier(modifier)
    }
}

// MARK: - Preview

//struct ModifierPreview: PreviewProvider {
//    struct Preview: View {
//        @State private var isHovered: Bool = false
//        var body: some View {
//            VStack {
//                Text("Button")
//                    .truss(.padding(.regular).edges(.horizontal))
//                    .truss(.padding(.small).edges(.vertical))
//                    .truss(.font(.regular))
////                    .truss(.size(width: .regular, height: .small))
//                    .truss(
//                        .background(.fill.opacity(isHovered ? 1 : 0.2))
//                        .cornerRadius(.regular)
//                        .padding(.regular.negative())
//                    )
//                    .truss(.border(.border).cornerRadius(.regular))
////                    .truss(.cornerRadius(.large))
//            }
//            .truss(.size(.large))
//            .truss(.padding(.regular))
//            .truss(.background())
//            .onHover { isHovered = $0 }
//        }
//    }
//    static var previews: some View {
//        Preview()
//    }
//}
