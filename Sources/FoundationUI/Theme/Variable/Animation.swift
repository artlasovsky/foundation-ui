//
//  Animation.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 30/05/2025.
//

import SwiftUI

extension Theme {
	@available(macOS 14.0, iOS 17.0, *)
	@frozen
	public struct Animation: FoundationVariableWithValue {
		public typealias Result = SwiftUI.Animation
		
		public var value: Result
		public var environmentAdjustment: EnvironmentAdjustment?
		
		public init() { self = .init(.default) }
		
		public init(value: Result) {
			self.value = value
		}
	}
}
