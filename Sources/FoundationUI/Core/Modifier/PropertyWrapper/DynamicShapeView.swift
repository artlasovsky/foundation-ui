//
//  File.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

@propertyWrapper
struct DynamicShapeView<S: ShapeStyle>: DynamicProperty {
    @Environment(\.dynamicCornerRadius) private var dynamicCornerRadius
    @Environment(\.dynamicColorTint) private var dynamicColorTint
    
    private var style: S?
    private var token: FoundationUI.Theme.Color.Token?
    
    private var cornerRadius: CGFloat?
    private var padding: CGFloat = 0
    
    func cornerRadius(token: FoundationUI.Theme.Radius.Token?) -> Self {
        var copy = self
        var value: CGFloat?
        if let token {
            value = .foundation.radius(token)
        }
        copy.cornerRadius = value
        return copy
    }
    
    func padding(token: FoundationUI.Theme.Padding.Token) -> Self {
        var copy = self
        copy.padding = .foundation.padding(token)
        return copy
    }
    
    var gradientMask: FoundationUI.Theme.LinearGradient.Token?
    var shadow: FoundationUI.Theme.Shadow.Token?
    
    var safeAreaRegions: SafeAreaRegions?
    var safeAreaEdges: Edge.Set?
    
    var stroke: Stroke?
    
    init() where S: ShapeStyle {}
    
    init(style: S)  {
        self.style = style
    }
    
    init(token: FoundationUI.Theme.Color.Token) where S == FoundationUI.Theme.Color {
        self.token = token
    }
    
    @ViewBuilder
    var wrappedValue: some View {
        let base = shapeView
            .foundation(.shadow(shadow))
            .foundation(.padding(.init(value: strokeWidth)))
            .foundation(.gradientMask(gradientMask))
            .foundation(.padding(.init(value: -strokeWidth)))
            .foundation(.padding(.init(value: paddingValue)))
        if let safeAreaRegions, let safeAreaEdges {
            base.ignoresSafeArea(safeAreaRegions, edges: safeAreaEdges)
        } else {
            base
        }
    }
    
    @ViewBuilder
    private var shapeView: some View {
        if let style {
            shape.foregroundStyle(style)
        } else if let token {
            shape.foregroundStyle(dynamicColorTint.scale(token))
        }
    }
    
    private var paddingValue: CGFloat {
        let strokePaddingAdjustment = stroke?.paddingAdjustment ?? 0
        return padding + strokePaddingAdjustment
    }
    
    private var radius: CGFloat {
        let radius: CGFloat = cornerRadius ?? dynamicCornerRadius ?? 0
        guard radius > 0 else { return 0 }
        let strokeAdjustment = stroke?.cornerRadiusAdjustment ?? 0
        let paddingAdjustment = max(0, padding)
        return radius + strokeAdjustment + paddingAdjustment
    }
    
    private var strokeWidth: CGFloat {
        stroke?.width ?? 0
    }
    
    @ViewBuilder
    private var shape: some View {
        let shape: some Shape = FoundationUI.Shape.roundedRectangle(radius: radius)
        if let stroke {
            shape
                .stroke(lineWidth: stroke.width)
        }
        else {
            shape
        }
    }
}

struct DynamicShapeView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Background")
                .border(.blue) // .foundation(.background()) should exceed the blue border
                .foundation(.background(.red.scale(.borderFaded))
                    .padding(.regular.negative())
                    .shadow(.small)
                    .cornerRadius(.small)
                    .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                )
                .foundation(.foreground(.red.scale(.textEmphasized)))
//                ._colorScheme(.dark)
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

public struct Stroke: Sendable {
    public enum Placement: Sendable {
        case inside
        case outside
        case center
    }
    
    var width: CGFloat
    var placement: Placement
    
    var paddingAdjustment: CGFloat {
        switch placement {
        case .inside:
            return width / 2
        case .outside:
            return -(width / 2)
        case .center:
            return 0
        }
    }
    
    var cornerRadiusAdjustment: CGFloat {
        paddingAdjustment * -1
    }
}
