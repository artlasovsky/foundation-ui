//
//  Builders.swift
//
//
//  Created by Art Lasovsky on 12/07/2024.
//

import Foundation
import SwiftUI

// MARK: - ShapeBuilder

@resultBuilder
struct ShapeBuilder {
    static func buildBlock<S: Shape>(_ component: S) -> some Shape {
        component
    }
    
    static func buildEither<TrueShape: Shape, FalseShape: Shape>(first: TrueShape) -> EitherShape<TrueShape, FalseShape> {
        .first(first)
    }
    
    static func buildEither<TrueShape: Shape, FalseShape: Shape>(second: FalseShape) -> EitherShape<TrueShape, FalseShape> {
        .second(second)
    }
}

struct EmptyShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path()
    }
}

enum EitherShape<First: Shape, Second: Shape>: Shape {
    case first(First)
    case second(Second)
    
    func path(in rect: CGRect) -> Path {
        switch self {
        case .first(let shape):
            return shape.path(in: rect)
        case .second(let shape):
            return shape.path(in: rect)
        }
    }
}

extension ShapeBuilder {
    @ShapeBuilder
    static func resolveShape(_ shape: some Shape, dynamicCornerRadius: CGFloat?, dynamicCornerRadiusStyle: RoundedCornerStyle) -> some Shape {
        if let shape = shape as? ConcentricRoundedRectangle {
            shape.setCornerRadius(dynamicCornerRadius, style: dynamicCornerRadiusStyle)
        } else {
            shape
        }
    }
    
    @ViewBuilder
    static func resolveInsettableShape(
        _ shape: some InsettableShape,
        inset: CGFloat,
        strokeWidth: CGFloat?,
        dynamicCornerRadius: CGFloat?,
        dynamicCornerRadiusStyle: RoundedCornerStyle
    ) -> some View {
        if let shape = shape as? ConcentricRoundedRectangle {
            shape
                .setCornerRadius(dynamicCornerRadius, style: dynamicCornerRadiusStyle)
                .adjusted(inset: inset, strokeWidth: strokeWidth)
        } else {
            shape.adjusted(inset: inset, strokeWidth: strokeWidth)
        }
    }
}

extension InsettableShape {
    @ViewBuilder
    func adjusted(inset: CGFloat, strokeWidth: CGFloat?) -> some View {
        if let strokeWidth {
            if strokeWidth - inset == strokeWidth / 2 {
                self.inset(by: inset)
                    .strokeBorder(style: .init(lineWidth: strokeWidth), antialiased: true)
            } else {
                self.inset(by: inset)
                    .stroke(lineWidth: strokeWidth)
            }
        } else {
            self.inset(by: inset)
        }
    }
}


// MARK: - ShapeStyleBuilder

@resultBuilder
struct ShapeStyleBuilder {
    static func buildBlock<S: ShapeStyle>(_ component: S) -> some ShapeStyle {
        component
    }
    
    static func buildEither<TrueStyle: ShapeStyle, FalseStyle: ShapeStyle>(first: TrueStyle) -> EitherShapeStyle<TrueStyle, FalseStyle> {
        .first(first)
    }
    
    static func buildEither<TrueStyle: ShapeStyle, FalseStyle: ShapeStyle>(second: FalseStyle) -> EitherShapeStyle<TrueStyle, FalseStyle> {
        .second(second)
    }
}

enum EitherShapeStyle<First: ShapeStyle, Second: ShapeStyle>: ShapeStyle {
    case first(First)
    case second(Second)
    
	func resolve(in environment: EnvironmentValues) -> AnyShapeStyle {
		switch self {
		case .first(let first):
			AnyShapeStyle(first)
		case .second(let second):
			AnyShapeStyle(second)
		}
	}
}
