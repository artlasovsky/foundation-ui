//
//  SizeModifier.swift
//  
//
//  Created by Art Lasovsky on 04/06/2024.
//

import Foundation
import SwiftUI

public extension FoundationModifierLibrary {
    struct SizeModifier: ViewModifier {
		@Environment(\.self) private var environment
		let size: Size
        private let alignment: Alignment
		
		enum Size {
			case dynamic(
				minWidth: Theme.Length?,
				idealWidth: Theme.Length?,
				maxWidth: Theme.Length?,
				minHeight: Theme.Length?,
				idealHeight: Theme.Length?,
				maxHeight: Theme.Length?,
			)
			case regular(width: Theme.Length?, height: Theme.Length?)
			
			static func from(themeSize: Theme.Size) -> Self {
				var width: Theme.Length = themeSize.value.width
				width.environmentAdjustment = { variable, environment in
					let size = themeSize.resolve(in: environment)
					return .init(size.width)
				}
				var height: Theme.Length = themeSize.value.height
				height.environmentAdjustment = { variable, environment in
					let size = themeSize.resolve(in: environment)
					return .init(size.height)
				}
				
				return .regular(width: width, height: height)
			}
		}
        
		init(size: Size, alignment: Alignment) {
			self.size = size
            self.alignment = alignment
        }
        
        public func body(content: Content) -> some View {
			switch size {
			case .dynamic(let minWidth, let idealWidth, let maxWidth, let minHeight, let idealHeight, let maxHeight):
				content.frame(
					minWidth: minWidth?.resolve(in: environment),
					idealWidth: idealWidth?.resolve(in: environment),
					maxWidth: maxWidth?.resolve(in: environment),
					minHeight: minHeight?.resolve(in: environment),
					idealHeight: idealHeight?.resolve(in: environment),
					maxHeight: maxHeight?.resolve(in: environment),
					alignment: alignment
				)
			case .regular(let width, let height):
				content.frame(
					width: width?.resolve(in: environment),
					height: height?.resolve(in: environment),
					alignment: alignment
				)
			}
        }
    }
}

public extension FoundationModifier {
    static func size(
		width: Theme.Length? = nil,
		height: Theme.Length? = nil,
        alignment: Alignment = .center
    ) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
		.init(.init(size: .regular(width: width, height: height), alignment: alignment))
    }
	
	static func size(
		minWidth: Theme.Length? = nil,
		idealWidth: Theme.Length? = nil,
		maxWidth: Theme.Length? = nil,
		minHeight: Theme.Length? = nil,
		idealHeight: Theme.Length? = nil,
		maxHeight: Theme.Length? = nil,
		alignment: Alignment = .center
	) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
		.init(
			.init(
				size: .dynamic(
					minWidth: minWidth,
					idealWidth: idealWidth,
					maxWidth: maxWidth,
					minHeight: minHeight,
					idealHeight: idealHeight,
					maxHeight: maxHeight
				),
				alignment: alignment
			)
		)
	}
    
    static func size(
		square: Theme.Length,
        alignment: Alignment = .center
    ) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
		.init(.init(size: .regular(width: square, height: square), alignment: alignment))
    }
	
	static func size(
		_ size: Theme.Size,
		alignment: Alignment = .center
	) -> FoundationModifier<FoundationModifierLibrary.SizeModifier> {
		.init(.init(size: .from(themeSize: size), alignment: alignment))
	}
}

private extension Theme.Size {
	static let cgFloat = Theme.Size(width: 40, height: 60)
	static let test = Theme.Size(width: .large, height: .regular)
}

struct SizeModifierPreview: PreviewProvider {
    static var previews: some View {
        VStack {
			Rectangle().foundation(.size(square: .xSmall))
			Rectangle().foundation(.size(square: .small))
			Rectangle().foundation(.size(square: .regular))
			Rectangle().foundation(.size(square: .large))
			Rectangle().foundation(.size(.cgFloat))
			Rectangle().foundation(.size(.test))
			Text("With Env Override")
				.foundation(.size(.envOverrideTest))
				.border(.red)
        }
        .padding()
    }
}

@MainActor
private extension Theme.Size {
	static var envOverrideTest: Theme.Size {
		.init(.init(width: 0, height: 0))
		.withEnvironmentAdjustment { variable, environment in
			let width = environment.displayScale * 40
			let height = environment.displayScale * 20
			
			return .init(width: .init(width), height: .init(height))
		}
	}
}
