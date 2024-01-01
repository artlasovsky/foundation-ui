//
//  Scalable.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

// MARK: - Scalable
public protocol Scalable<Value> {
    associatedtype Value
    typealias KeyPath = Swift.KeyPath<Self, Value>
    var xxSmall: Value { get }
    var xSmall: Value { get }
    var small: Value { get }
    var regular: Value { get }
    var large: Value { get }
    var xLarge: Value { get }
    var xxLarge: Value { get }
}

// MARK: - ScalableCGFloat
public protocol ScalableCGFloat: Scalable<CGFloat> {
    typealias Configuration = ScalableCGFloatConfiguration
    typealias Offset = ScalableCGFloatOffset
    
    var configuration: Configuration { get set }
}

public struct ScalableCGFloatConfiguration {
    public var base: CGFloat
    public var multiplier: CGFloat
    public var rounded: Bool
    public init(base: CGFloat, multiplier: CGFloat, rounded: Bool) {
        self.base = base
        self.multiplier = multiplier
        self.rounded = rounded
    }
}

public enum ScalableCGFloatOffset {
    case up(_ step: Step = .full)
    case down(_ step: Step = .full)
    
    public enum Step: CGFloat {
        case full = 1
        case half = 0.5
        case third = 0.33
        case quarter = 0.25
    }
}

public extension ScalableCGFloat {    
    internal var base: CGFloat { configuration.base }
    internal var multiplier: CGFloat { configuration.multiplier }
    internal var rounded: Bool { configuration.rounded }
    
    /// Fine tune the token value
    ///
    /// Not available in `KeyPath<>` selectors
    /// Use it with `CGFloat.theme.*`
    /// Or create an extension for variable (Padding, Size, etc.)
    func offset(_ offset: Offset) -> Self {
        switch offset {
        case .up(let step):
            let regular = base
            let large = base * multiplier
            var copy = self
            copy.configuration.base = regular + (large - regular) * step.rawValue
            return copy
        case .down(let step):
            let regular = base
            let small = base / multiplier
            var copy = self
            copy.configuration.base = regular - (regular - small) * step.rawValue
            return copy
        }
    }
    
    var xxSmall: Value { offset(.down()).xSmall }
    var xSmall: Value { offset(.down()).small }
    var small: Value { offset(.down()).regular }
    var regular: Value { base.rounded(rounded) }
    var large: Value { offset(.up()).regular }
    var xLarge: Value { offset(.up()).large }
    var xxLarge: Value { offset(.up()).xLarge }
}

internal extension CGFloat {
    func rounded(_ enabled: Bool) -> CGFloat {
        enabled ? self.rounded() : self
    }
}

#if(DEBUG)
// TODO: Expose to use as a preview and make prettier
struct SimpleExample: View {
    struct Sample<Scale: ScalableCGFloat>: View {
        let scale: Scale
        let token: KeyPath<Scale, CGFloat>
        var steps: [CGFloat] {
            [
                scale.offset(.down(.half))[keyPath: token],
                scale.offset(.down(.third))[keyPath: token],
                scale[keyPath: token],
                scale.offset(.up(.third))[keyPath: token],
                scale.offset(.up(.half))[keyPath: token]
            ]
        }
        var body: some View {
            HStack {
                if #available(macOS 13.3, *) {
                    Text(token.debugDescription)
                }
                Text(steps.map({ String(format: "%.2f", $0) }).joined(separator: " - "))
            }
        }
    }
    var body: some View {
        let scale = FoundationUI.Scale.size
        VStack(alignment: .leading) {
            Sample(scale: scale, token: \.xxSmall)
            Sample(scale: scale, token: \.xSmall)
            Sample(scale: scale, token: \.small)
            Sample(scale: scale, token: \.regular)
            Sample(scale: scale, token: \.large)
            Sample(scale: scale, token: \.xxLarge)
        }
        .theme().size(400)
    }
}
#endif

struct SimpleExample_Preview: PreviewProvider {
    static var previews: some View {
        SimpleExample()
    }
}
