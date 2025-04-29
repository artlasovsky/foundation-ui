//
//  BlendModeModifier.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 29/04/2025.
//

import SwiftUI

public extension FoundationModifierLibrary {
	struct BlendModeModifier: ViewModifier {
		@Environment(\.self) private var env
		var blendMode: BlendMode?
		var extendedBlendMode: DynamicColor.ExtendedBlendMode?
		
		var resolvedBlendMode: BlendMode {
			extendedBlendMode?.resolve(in: .init(env)) ?? blendMode ?? .normal
		}
		
		public func body(content: Content) -> some View {
			content
				.blendMode(resolvedBlendMode)
		}
	}
}

public extension FoundationModifier {
	static func blendMode(_ blendMode: BlendMode) -> FoundationModifier<FoundationModifierLibrary.BlendModeModifier> {
		.init(.init(blendMode: blendMode))
	}
	
	static func blendMode(_ extendedBlendMode: DynamicColor.ExtendedBlendMode) -> FoundationModifier<FoundationModifierLibrary.BlendModeModifier> {
		.init(.init(extendedBlendMode: extendedBlendMode))
	}
	
	// TODO: Optinally pass it to all or selected (.foreground / .background / etc.) color modifiers
	// static func blendMode(_ blendMode:, scope:) {}
}

struct BlendModePreview: PreviewProvider {
	static var previews: some View {
		VStack(alignment: .leading) {
			HStack(spacing: 0) {
				Text("Vibrant with mask (broken)")
					.frame(width: 175)
				Rectangle()
					.frame(height: 20)
				Rectangle()
					.frame(height: 20)
					.mask {
						Color.black
							.overlay {
								Color.black
							}
					}
			}
			.foundation(.foreground(.blue.opacity(0.5).blendMode(.vibrant)))
			HStack(spacing: 0) {
				Text("Vibrant with mask (fixed)")
					.frame(width: 175)
				Rectangle()
					.frame(height: 20)
				Rectangle()
					.frame(height: 20)
					.mask {
						Color.black
							.overlay {
								Color.black
							}
					}
					.foundation(.blendMode(.vibrant))
			}
			.foundation(.foreground(.blue.opacity(0.5).blendMode(.vibrant)))
			HStack(spacing: 0) {
				Text("Vibrant with mask (fixed)")
					.frame(width: 175)
				Rectangle()
					.frame(height: 20)
				Rectangle()
					.frame(height: 20)
					.foundation(.foreground(.blue.opacity(0.5).blendMode(.normal)))
					.mask {
						Color.black
							.overlay {
								Color.black
							}
					}
					.foundation(.blendMode(.vibrant))
			}
			.foundation(.foreground(.blue.opacity(0.5).blendMode(.vibrant)))
		}
		.frame(width: 300, height: 200)
		.foundation(.font(.small))
		.background(.gray)
	}
}
