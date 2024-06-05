//
//  LinearGradientModifier.swift
//
//
//  Created by Art Lasovsky on 03/06/2024.
//

import Foundation
import SwiftUI

public extension ShapeStyle where Self == LinearGradient {
    static func linearGradient(colors: [TrussUI.DynamicColor], env: EnvironmentValues) -> Self {
        .linearGradient(colors: colors.map({ $0.resolveColor(in: env) }), startPoint: .top, endPoint: .bottom)
    }
}

public extension TrussUI.Variable {
    struct LinearGradient: View {
        @Environment(\.self) private var environment
        let colors: [TrussUI.DynamicColor]?
        let variations: [TrussUI.DynamicColor.VariationKeyPath]?
        let startPoint: UnitPoint
        let endPoint: UnitPoint
        
        init(_ colors: [TrussUI.DynamicColor], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) {
            self.colors = colors
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.variations = nil
        }
        
        init(variations: [TrussUI.DynamicColor.VariationKeyPath], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) {
            self.variations = variations
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.colors = nil
        }
        
        private var gradient: Gradient? {
            Gradient.from(colors: colors ?? [], in: environment)
            ?? Gradient.from(tint: nil, variation: variations ?? [], in: environment)
        }
        public var body: some View {
            if let gradient {
                gradient.linearGradient(startPoint: startPoint, endPoint: endPoint)
            } else {
                EmptyView()
            }
        }
    }
}

struct LinearGradient_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            TrussUI.Variable.LinearGradient(variations: [\.background, \.text], startPoint: .top, endPoint: .bottom)
                .truss(.tint(.red))
            TrussUI.Variable.LinearGradient(variations: [\.background, \.text], startPoint: .top, endPoint: .bottom)
            TrussUI.Variable.LinearGradient([.primary, .red], startPoint: .top, endPoint: .bottom)
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
