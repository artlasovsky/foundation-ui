//
//  AdjustableByEnvironment.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 18/12/2024.
//

import SwiftUI

public protocol AdjustableByEnvironment {
	typealias EnvironmentAdjustment = @Sendable (_ variable: Self, _ environment: EnvironmentValues) -> Self?
	var environmentAdjustment: (EnvironmentAdjustment)? { get set }
	
	func themeable(_ adjustment: @escaping @Sendable (_ theme: Theme?) -> Self?) -> Self
	func withEnvironmentAdjustment(_ adjustment: @escaping EnvironmentAdjustment) -> Self
}

public extension AdjustableByEnvironment {
	func withEnvironmentAdjustment(_ adjustment: @escaping EnvironmentAdjustment) -> Self {
		var copy = self
		copy.environmentAdjustment = adjustment
		return copy
	}
	
	func themeable(_ adjustment: @escaping @Sendable (_ theme: Theme?) -> Self?) -> Self {
		withEnvironmentAdjustment { _, environment in
			adjustment(environment.foundationTheme)
		}
	}
}
