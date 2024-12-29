//
//  AdjustableByEnvironment.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 18/12/2024.
//

import SwiftUI

public protocol AdjustableByEnvironment {
	var environmentAdjustment: (@Sendable (_ environment: EnvironmentValues) -> Self?)? { get set }
	
	func themeable(_ adjustment: @escaping @Sendable (_ theme: Theme?) -> Self?) -> Self
	func withEnvironmentAdjustment(_ adjustment: @escaping @Sendable (_ environment: EnvironmentValues) -> Self?) -> Self
}

public extension AdjustableByEnvironment {
	func withEnvironmentAdjustment(_ adjustment: @escaping @Sendable (_ environment: EnvironmentValues) -> Self?) -> Self {
		var copy = self
		copy.environmentAdjustment = adjustment
		return copy
	}
	
	func themeable(_ adjustment: @escaping @Sendable (_ theme: Theme?) -> Self?) -> Self {
		var copy = self
		copy.environmentAdjustment = { env in
			adjustment(env.foundationTheme)
		}
		return copy
	}
}
