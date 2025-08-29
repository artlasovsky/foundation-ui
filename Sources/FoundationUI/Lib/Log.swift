//
//  Log.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 27/08/2025.
//

import OSLog

extension Logger {
	enum Category: String {
		case font
	}
	static func foundationUI(category: Category) -> Logger {
		Logger(subsystem: "FoundationUI", category: category.rawValue)
	}
}
