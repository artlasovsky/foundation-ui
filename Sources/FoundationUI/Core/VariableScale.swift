//
//  VariableScale.swift
//
//  Created by Art Lasovsky on 10/2/23.
//

import Foundation
import SwiftUI

// MARK: - Variable Scales

public protocol GenericVariableScale<Value> {
    associatedtype Value
    var xxSmall: Value { get }
    var xSmall: Value { get }
    var small: Value { get }
    var regular: Value { get }
    var large: Value { get }
    var xLarge: Value { get }
    var xxLarge: Value { get }
}


public protocol CGFloatVariableScale: GenericVariableScale<CGFloat> {
    var multiplier: Value { get set }
    var base: Value { get set }
    var rounded: Bool { get set }
}

public extension CGFloatVariableScale {
    func stepUp(_ step: CGFloat = 1) -> Self {
        let regular = base
        let large = base * multiplier
        var copy = self
        copy.base = regular + (large - regular) * step
        return copy
    }
    func stepDown(_ step: CGFloat = 1) -> Self {
        let regular = base
        let small = base / multiplier
        var copy = self
        copy.base = regular - (regular - small) * step
        return copy
    }
    var xxSmall: Value { stepDown().xSmall }
    var xSmall: Value { stepDown().small }
    var small: Value { stepDown().regular }
    var regular: Value { base.rounded(rounded) }
    var large: Value { stepUp().regular }
    var xLarge: Value { stepUp().large }
    var xxLarge: Value { stepUp().xLarge }
}

internal extension CGFloat {
    func rounded(_ enabled: Bool) -> CGFloat {
        enabled ? self.rounded() : self
    }
}

public extension CGFloatVariableScale {
    var halfStepUp: Self {
        stepUp(0.5)
    }
    var halfStepDown: Self {
        stepDown(0.5)
    }
    var thirdStepUp: Self {
        stepUp(1/3)
    }
    var thirdStepDown: Self {
        stepDown(1/4)
    }
    var quarterStepUp: Self {
        stepUp(1/4)
    }
    var quarterStepDown: Self {
        stepDown(1/4)
    }
}

// MARK: Example: Scale Extension
internal extension CGFloatVariableScale {
    var xxxLarge: Value { stepUp(1).xxLarge }
}

struct SimpleExample: View {
    struct Sample: View {
        let scale = FoundationUI.Variable.size
        let variable: KeyPath<FoundationUI.Variable.Size, CGFloat>
        var steps: [CGFloat] {
            [
                scale.halfStepDown[keyPath: variable],
                scale.thirdStepDown[keyPath: variable],
                scale[keyPath: variable],
                scale.thirdStepUp[keyPath: variable],
                scale.halfStepUp[keyPath: variable]
            ]
        }
        var body: some View {
            HStack {
                if #available(macOS 13.3, *) {
                    Text(variable.debugDescription)
                }
                Text(steps.map({ String(format: "%.2f", $0) }).joined(separator: " - "))
            }
        }
    }
    var body: some View {
        let scale = FoundationUI.Variable.size
        VStack(alignment: .leading) {
            Sample(variable: \.xxSmall)
            Sample(variable: \.xSmall)
            Sample(variable: \.small)
            Sample(variable: \.regular)
            Sample(variable: \.large)
            Sample(variable: \.xxLarge)
            Sample(variable: \.xxxLarge).opacity(0.5)
        }
        .theme().size(400)
    }
}

struct SimpleExample_Preview: PreviewProvider {
    static var previews: some View {
        SimpleExample()
    }
}
