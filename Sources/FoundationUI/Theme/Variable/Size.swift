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
	struct Length: FoundationVariableWithValue {
		public var value: CGFloat
		init() {
			self.value = 0
		}
		public init(value: CGFloat) {
			self.value = value
		}
		public func callAsFunction(_ token: Self) -> CGFloat {
			token.value
		}
	}
	
	
    @frozen
	struct Size: FoundationVariableWithValue {
		public var value: Configuration
        
		init() {
			self.value = .zero
        }
		
		public init(width: Length, height: Length) {
			self.value = .init(width: width, height: height)
		}
		
		public init(width: CGFloat, height: CGFloat) {
			self.value = .init(width: .init(width), height: .init(height))
        }
		
		public func callAsFunction(_ token: Self) -> Configuration {
            token.value
        }
		
		public init(value: Configuration) {
			self.value = value
		}
		
		public struct Configuration: Equatable, Hashable, Sendable {
			let width: Length
			let height: Length
			
			static let zero = Self(width: .init(0), height: .init(0))
		}
    }
}
