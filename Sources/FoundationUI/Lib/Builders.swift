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
    static func resolveShape(_ shape: some Shape, dynamicCornerRadius: CGFloat?) -> some Shape {
        if let shape = shape as? DynamicRoundedRectangle {
            shape.setCornerRadius(dynamicCornerRadius)
        } else {
            shape
        }
    }
    
    @ShapeBuilder
    static func resolveInsettableShape(_ shape: some InsettableShape, inset: CGFloat, dynamicCornerRadius: CGFloat?) -> some Shape {
        if let shape = shape as? DynamicRoundedRectangle {
            shape.inset(by: inset).setCornerRadius(dynamicCornerRadius)
        } else {
            shape
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
    
    func _apply(to shape: inout _ShapeStyle_Shape) {
        switch self {
        case .first(let style):
            style._apply(to: &shape)
        case .second(let style):
            style._apply(to: &shape)
        }
    }
}
