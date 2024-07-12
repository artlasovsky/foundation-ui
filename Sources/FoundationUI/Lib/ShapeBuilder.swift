//
//  ShapeBuilder.swift
//  
//
//  Created by Art Lasovsky on 12/07/2024.
//

import Foundation
import SwiftUI

@resultBuilder
struct ShapeBuilder {
    static func buildBlock<S: Shape>(_ component: S) -> some Shape {
        component
    }
    
    static func buildEither<TrueShape: Shape, FalseShape: Shape>(first: TrueShape) -> Either<TrueShape, FalseShape> {
        .first(first)
    }
    
    static func buildEither<TrueShape: Shape, FalseShape: Shape>(second: FalseShape) -> Either<TrueShape, FalseShape> {
        .second(second)
    }
}

extension ShapeBuilder {
    @ShapeBuilder
    static func resolveShape(_ shape: some Shape, dynamicCornerRadius: CGFloat?) -> some Shape {
        if let shape = shape as? DynamicRoundedRectangle {
            shape.setCornerRadius(dynamicCornerRadius)
        } else if shape is ViewShape {
            Rectangle()
        } else {
            shape
        }
    }
}


struct EmptyShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path()
    }
}

enum Either<First: Shape, Second: Shape>: Shape {
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
