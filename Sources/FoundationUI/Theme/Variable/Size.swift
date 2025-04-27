//
//  Size.swift
//
//
//  Created by Art Lasovsky on 27/06/2024.
//

import Foundation
import SwiftUI

public extension Theme {
	@frozen
	struct Length: FoundationVariableWithCGFloatValue {
		public var value: CGFloat
		public var environmentAdjustment: (@Sendable (EnvironmentValues) -> Theme.Length?)?
		
		init() {
			self.value = 0
		}
		public init(value: CGFloat) {
			self.value = value
		}
	}
	
	
    @frozen
	struct Size: FoundationVariableWithValue {
		public var value: Configuration
		public var environmentAdjustment: (@Sendable (EnvironmentValues) -> Theme.Size?)?
        
		init() {
			self.value = .zero
        }
		
		public init(width: Length, height: Length) {
			self.value = .init(width: width, height: height)
		}
		
		public init(value: Configuration) {
			self.value = value
		}
		
		public var cgSize: CGSize {
			value.cgSize
		}
		
		public struct Configuration: Equatable, Hashable, Sendable {
			public let width: Length
			public let height: Length
			
			public var cgSize: CGSize {
				.init(width: width.value, height: height.value)
			}
			
			public static let zero = Self(width: .init(0), height: .init(0))
		}
    }
}
