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
    @Environment(\.FoundationUICornerRadius) private var environmentCornerRadius
    @Environment(\.dynamicColorTint) private var dynamicColorTint
    
    private var scale: FoundationUI.Theme.Color.Scale?
    private var fill: S?
    
    private var cornerRadius: CGFloat?
    private var padding: CGFloat = 0
    
    func cornerRadius(scale: FoundationUI.Theme.Radius.Scale?) -> Self {
        var copy = self
        var value: CGFloat?
        if let scale {
            value = .foundation.radius(scale)
        }
        copy.cornerRadius = value
        return copy
    }
    
    func padding(scale: FoundationUI.Theme.Padding.Scale) -> Self {
        var copy = self
        copy.padding = .foundation.padding(scale)
        return copy
    }
    
    var gradientMask: FoundationUI.Theme.LinearGradient.Scale?
    var shadow: FoundationUI.Theme.Shadow.Scale?
    
    var safeAreaRegions: SafeAreaRegions?
    var safeAreaEdges: Edge.Set?
    
    var stroke: Stroke?
    
    init() where S: ShapeStyle {}
    
    init(fill: S)  {
        self.fill = fill
    }
    
    init(scale: FoundationUI.Theme.Color.Scale) where S == FoundationUI.Theme.Color {
        self.scale = scale
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
        if let fill {
            shape.foregroundStyle(fill)
        } else if let scale {
            shape.foregroundStyle(dynamicColorTint.scale(scale))
        }
    }
    
    private var paddingValue: CGFloat {
        let strokePaddingAdjustment = stroke?.paddingAdjustment ?? 0
        return padding + strokePaddingAdjustment
    }
    
    private var radius: CGFloat {
        let radius: CGFloat = cornerRadius ?? environmentCornerRadius ?? 0
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
                .foundation(.background(.red.borderFaded)
                    .padding(.regular.negative())
                    .shadow(.small)
                    .cornerRadius(.small)
                    .gradientMask(.init(colors: [.black, .clear], startPoint: .top, endPoint: .bottom))
                )
                .foundation(.foreground(.red.textEmphasized))
//                ._colorScheme(.dark)
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}

public struct Stroke {
    public enum StrokePlacement {
        case inside
        case outside
        case center
    }
    
    var width: CGFloat
    var placement: StrokePlacement
    
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
