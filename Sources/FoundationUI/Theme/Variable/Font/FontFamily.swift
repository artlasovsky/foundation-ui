//
//  FontFamily.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 16/06/2025.
//

import SwiftUI
import FontFamily

extension Theme.Font {
	public static func family<Weight: FontFamily>(_ name: FontFamily.Font<Weight>, size: CGFloat, weight: Weight = .default, scaling: FontFamilyScaling = .textStyle(.body)) -> Self {
		.init(value: .fontFamily(name, size: size, weight: weight, scaling: scaling))
	}
}
