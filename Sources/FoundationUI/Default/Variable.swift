//
//  Variable.swift
//  
//
//  Created by Art Lasovsky on 10/15/23.
//

import Foundation
import SwiftUI

extension FoundationUI {
    public struct Scale: FoundationUIScalableDefaults {
        public static let padding = Padding()
        public static let spacing = Spacing()
        public static let radius = Radius()
        public static let size = Size()
        
        public static let shadow = Shadow()
        public static let animation = Animation()
        public static let font = Font()
    }
}



// MARK: - Extensions

// Set of different value sets
//public enum ThemeCGFloatProperties: FoundationUICGFloatVariableDefaults {}

public extension CGFloat {
    typealias theme = FoundationUI.Scale
}

public extension Font {
    static let theme = FoundationUI.Scale.font
}

public extension Animation {
    static let theme = FoundationUI.Scale.animation
}

// MARK: - Variables
public extension FoundationUI.Scale {
    internal enum ScaleDefaults {
        static var multiplier: CGFloat { 2 }
        static var base: CGFloat { 8 }
    }
    struct Padding: ScalableCGFloat {
        public var configuration = Configuration(
            base: ScaleDefaults.base,
            multiplier: ScaleDefaults.multiplier,
            rounded: false
        )
    }
    struct Spacing: ScalableCGFloat {
        public var configuration = Configuration(
            base: ScaleDefaults.base * 0.5,
            multiplier: ScaleDefaults.multiplier,
            rounded: false
        )
    }
    
    struct Size: ScalableCGFloat {
        public var configuration = Configuration(
            base: 64,
            multiplier: 2,
            rounded: true
        )
    }
    
    struct Radius: ScalableCGFloat {
        public var configuration = Configuration(
            base: ScaleDefaults.base,
            multiplier: ScaleDefaults.multiplier,
            rounded: false
        )
    }
    
    struct Font: Scalable {
        typealias Font = SwiftUI.Font
        public let xxSmall = Font.caption
        public let xSmall = Font.callout
        public let small = Font.callout
        public let regular = Font.body
        public let large = Font.title3
        public let xLarge = Font.title2
        public let xxLarge = Font.title
    }
    
    struct Animation {
        let `default`: SwiftUI.Animation = .interactiveSpring(duration: 0.2)
    }
    
    struct Shadow: Scalable {
        public typealias Shadow = FoundationUI.Modifier.Shadow.Configuration
        static let scale: FoundationUI.ColorScale = .backgroundFaded.colorScheme(.dark)
        public var xxSmall = Shadow(radius: 0.5, scale: scale.opacity(0.1), x: 0, y: 0.5)
        public var xSmall = Shadow(radius: 1, scale: scale.opacity(0.15), x: 0, y: 1)
        public var small = Shadow(radius: 1.5, scale: scale.opacity(0.2), x: 0, y: 1)
        public var regular = Shadow(radius: 2.5, scale: Self.scale.opacity(0.25), x: 0, y: 1)
        public var large = Shadow(radius: 3.5, scale: scale.opacity(0.3), x: 0, y: 1)
        public var xLarge = Shadow(radius: 4, scale: scale.opacity(0.4), x: 0, y: 1)
        public var xxLarge = Shadow(radius: 12, scale: scale.opacity(0.6), x: 0, y: 1)
    }
}

// MARK: - OS Specific
#if os(macOS)
public extension FoundationUI.Scale.Radius {
    /// Default macOS window radius
    var window: CGFloat { 10 }
}
#endif


// MARK: Previews
struct ShadowPreview: PreviewProvider {
    static var previews: some View {
        let style: some ShapeStyle = .scale.textEmphasized
        let rect: some View = Color.clear
            .theme().size(\.small)
            .theme().background(style, cornerRadius: \.small)
        VStack(spacing: 20) {
            rect.theme().shadow(\.xxSmall)
            rect.theme().shadow(\.xSmall)
            rect.theme().shadow(\.small)
            rect.theme().shadow(\.regular)
            rect.theme().shadow(\.large)
            rect.theme().shadow(\.xLarge)
            rect.theme().shadow(\.xxLarge)
        }
        .foregroundStyle(style)
        .padding()
        .theme().background(style)
    }
}
