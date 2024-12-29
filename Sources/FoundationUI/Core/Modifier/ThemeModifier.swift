//
//  ThemeModifier.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 18/12/2024.
//

import SwiftUI

public extension FoundationModifierLibrary {
	struct ThemeModifier: ViewModifier {
		let theme: Theme?
		public func body(content: Content) -> some View {
			content
				.environment(\.foundationTheme, theme)
		}
	}
}

public extension FoundationModifier {
	static func theme(_ theme: Theme?) -> FoundationModifier<FoundationModifierLibrary.ThemeModifier> {
		.init(.init(theme: theme))
	}
}
