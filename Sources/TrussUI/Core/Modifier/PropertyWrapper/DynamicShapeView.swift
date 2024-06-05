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
    @Environment(\.TrussUICornerRadius) private var environmentCornerRadius
    
    @DynamicColorTint private var tint: TrussUI.DynamicColor
    private var fill: S?
    
    var cornerRadius: TrussUI.Variable.Radius?
    var padding: TrussUI.Variable.Padding = .init(value: 0)
    
    var gradientMask: TrussUI.Variable.LinearGradient?
    var shadow: TrussUI.Variable.Shadow?
    
    var safeAreaRegions: SafeAreaRegions?
    var safeAreaEdges: Edge.Set?
    
    var stroke: Stroke?
    
    @ViewBuilder
    var wrappedValue: some View {
        let base = shapeView
            .truss(.shadow(shadow))
            .truss(.padding(.init(value: strokeWidth)))
            .truss(.gradientMask(gradientMask))
            .truss(.padding(.init(value: -strokeWidth)))
            .truss(.padding(.init(value: paddingValue)))
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
        } else {
            shape.foregroundStyle(tint)
        }
    }
    
    private var paddingValue: CGFloat {
        let strokePaddingAdjustment = stroke?.paddingAdjustment ?? 0
        return padding.value + strokePaddingAdjustment
    }
    
    private var radius: CGFloat {
        let radius: CGFloat = cornerRadius?.value ?? environmentCornerRadius ?? 0
        guard radius > 0 else { return 0 }
        let strokeAdjustment = stroke?.cornerRadiusAdjustment ?? 0
        let paddingAdjustment = max(0, padding.value)
        return radius + strokeAdjustment + paddingAdjustment
    }
    
    private var strokeWidth: CGFloat {
        stroke?.width ?? 0
    }
    
    @ViewBuilder
    private var shape: some View {
        let shape: some Shape = TrussUI.Shape.roundedRectangle(radius: radius)
        if let stroke {
            shape
                .stroke(lineWidth: stroke.width)
        }
        else {
            shape
        }
    }
    
    init() where S == TrussUI.DynamicColor {
        self.fill = nil
        self.cornerRadius = nil
    }
    
    init() {
        self.fill = nil
        self.cornerRadius = nil
    }
    
    init(fill: S)  {
        self.fill = fill
    }
    
    init(tint: TrussUI.DynamicColor?, keyPath: TrussUI.DynamicColor.VariationKeyPath?) where S == TrussUI.DynamicColor {
        _tint = .init(tint, keyPath: keyPath)
        fill = nil
    }
}

struct DynamicShapeView_Preview: PreviewProvider {
    struct TestView: View {
        @DynamicShapeView private var shapeView
        
        init(tint: TrussUI.DynamicColor, cornerRadius: TrussUI.Variable.Radius? = nil) {
            self._shapeView = .init(tint: tint, keyPath: nil)
        }
        
        var body: some View {
            VStack {
                shapeView
                    .frame(width: 100, height: 100)
            }
        }
        
        func cornerRadius(_ radius: TrussUI.Variable.Radius) -> Self {
            var copy = self
            copy._shapeView.cornerRadius = radius
            return copy
        }
        
        func padding(_ padding: TrussUI.Variable.Padding) -> Self {
            var copy = self
            copy._shapeView.padding = padding
            return copy
        }
    }
    static var previews: some View {
        VStack {
            Text("Hello!")
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 2)
                        .padding(1)
                        .mask {
                            LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
//                                .padding(-2)
                        }
                        .padding(-1)
                        .border(.white)
                }
            Text("Background")
                .truss(.background(.red.borderFaded)
                    .padding(.regular.negative())
                    .shadow(.small)
                    .cornerRadius(.small)
                    .gradientMask(.init([.black, .clear]))
                )
                .truss(.foreground(.red.textEmphasized))
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
