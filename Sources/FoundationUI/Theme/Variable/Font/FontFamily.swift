//
//  FontFamily.swift
//  FoundationUI
//
//  Created by Art Lasovsky on 16/06/2025.
//

import SwiftUI
import OSLog

// TODO: Font Style: normal, italic, ...

extension Theme.Font {
	/// Add font files and set correct "Target Membership" for them
	///
	/// Declare custom font:
	/// ``` swift
	/// public enum CustomFontWeight: FontWeight {
	///		case light
	///		case regular
	///		case bold
	///
	///		public static var defaultWeight: CustomFontWeight = .regular
	///		public static var fileExtension: FontFileExtension = .otf
	///
	///		// Should reflect file name – "CustonFont-Regular.otf"
	///		public var name: String {
	///			switch self {
	///				case .light: "CustomFont-Light"
	///				case .regular: "CustomFont-Regular"
	///				case .bold: "CustomFont-Bold"
	///			}
	///		}
	///
	///		// Map to system's weight
	///		public func resolve() -> Font.Weight {
	///			switch self {
	///				case .thin: .thin
	///				case .regular: .regular
	///				case .bold: .bold
	///			}
	///		}
	/// }
	///
	/// public extension Theme.Font.Family<CustomFontWeight> {
	///		static let customFont = Self()
	/// }
	/// ```
	///
	/// Use:
	/// ``` swift
	/// // Using SwiftUI's `.font` modifier:
	/// Text("Hello World!")
	///		.font(.foundationFamily(.customFont, size: 14, weight: .light))
	///
	///	// or using FoundationUI's modifier:
	///
	///	extension Theme.Font {
	///		static let customBody = Theme.Font.family(.customFont, size: 14, weight: .light)
	/// }
	///
	///	Text("Hello World!").foundation(.font(.customBody))
	/// ```
	public struct Family<Weight: FontWeight>: Sendable {
		public init() {}
		
		public func callAsFunction(size: CGFloat, weight: Weight = .defaultWeight, scaling: FontFamilyScaling = .textStyle(.body)) -> SwiftUI.Font {
			resolve(size: size, weight: weight, scaling: scaling)
		}
		
		public func resolve(size: CGFloat, weight: Weight = .defaultWeight, scaling: FontFamilyScaling = .textStyle(.body)) -> SwiftUI.Font {
			if Weight.self is FoundationUISystemFontWeight.Type {
				return .system(size: size, weight: weight.resolve())
			}
			
			Self.register()
			
			switch scaling {
			case .fixed:
				return .custom(Weight.defaultWeight.name, fixedSize: size).weight(weight.resolve())
			case .textStyle(let textStyle):
				return .custom(Weight.defaultWeight.name, size: size, relativeTo: textStyle).weight(weight.resolve())
			}
		}
		
		static func register() {
			Weight.allCases.forEach {
				guard let url = $0.url else {
					assertionFailure("URL is `nil` – \($0)")
					return
				}
				registerFont(url)
			}
		}
		
		private static func registerFont(_ fontUrl: URL) {
			if isFontRegistered(at: fontUrl) { return }
			
			var error: Unmanaged<CFError>?
			let success = CTFontManagerRegisterFontsForURL(fontUrl as CFURL, .none, &error)
			
			if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
				return
			}
			if !success {
				let errorDescription = (error?.takeRetainedValue() as? NSError)?.localizedDescription
				let message = ["Failed to register font.", errorDescription]
					.compactMap({ $0 })
					.joined(separator: "\n")
				
				Logger.foundationUI(category: .font).error("\(message)")
			}
		}
		
		private static func isFontRegistered(at fontUrl: URL) -> Bool {
			guard let fontDataProvider = CGDataProvider(url: fontUrl as CFURL),
				  let font = CGFont(fontDataProvider),
				  let fontName = font.postScriptName as String?
			else {
				return false
			}
			
			let names = CTFontManagerCopyAvailablePostScriptNames()
			
			if let names = names as? [String], names.contains(fontName) {
				return true
			}
			
			return false
		}
	}
}

#if os(macOS)
public extension Theme.Font.Family {
	func resolve(size: CGFloat, weight: Weight = .defaultWeight, scaling: FontFamilyScaling = .textStyle(.body)) -> NSFont {
		if weight is FoundationUISystemFontWeight {
			return .systemFont(ofSize: size, weight: weight.resolve())
		}
		Self.register()
		var font: NSFont = .systemFont(ofSize: size)
		switch scaling {
		case .fixed:
			font = .init(name: Weight.defaultWeight.name, size: size) ?? font
		case .textStyle(let textStyle):
			let size = NSFont.preferredFont(forTextStyle: textStyle.nsTextStyle()).pointSize
			font = .init(name: Weight.defaultWeight.name, size: size) ?? font
		}
		
		return font
	}
}
#endif

#if os(iOS)
public extension Theme.Font.Family {
	func resolve(size: CGFloat, weight: Weight = .defaultWeight, scaling: FontFamilyScaling = .textStyle(.body)) -> UIFont {
		if weight is FoundationUISystemFontWeight {
			return .systemFont(ofSize: size, weight: weight.resolve())
		}
		Self.register()
		var font: UIFont = .systemFont(ofSize: size)
		switch scaling {
		case .fixed:
			font = .init(name: Weight.defaultWeight.name, size: size) ?? font
		case .textStyle(let textStyle):
			let size = UIFont.preferredFont(forTextStyle: textStyle.uiTextStyle()).pointSize
			font = .init(name: Weight.defaultWeight.name, size: size) ?? font
		}
		
		return font
	}
}
#endif

// MARK: Font Weight

public protocol FontWeight: CaseIterable, Sendable {
	var name: String { get }
	var url: URL? { get }
	func resolve() -> Font.Weight
	
	
	static var bundle: Bundle { get }
	static var defaultWeight: Self { get }
	static var fileExtension: FontFileExtension { get }
}

public enum FontFileExtension: String, Sendable {
	case otf = "otf"
	case ttf = "ttf"
}

public extension FontWeight {
	static var fileExtension: FontFileExtension { .otf }
	var url: URL? {
		return Self.bundle.url(forResource: name, withExtension: Self.fileExtension.rawValue)
	}
}

public enum FoundationUISystemFontWeight: String, FontWeight {
	case thin
	case ultraLight
	case light
	case regular
	case medium
	case semibold
	case bold
	case heavy
	case black
	
	public static let defaultWeight = Self.regular
	
	public var name: String {
		"San Francisco"
	}
	
	public static var bundle: Bundle { .main }
	
	public var url: URL? { nil }
	
	public func resolve() -> Font.Weight {
		switch self {
		case .thin: .thin
		case .ultraLight: .ultraLight
		case .light: .light
		case .regular: .regular
		case .medium: .medium
		case .semibold: .semibold
		case .bold: .bold
		case .heavy: .heavy
		case .black: .black
		}
	}
}

#if os(macOS)
public extension FontWeight {
	func resolve() -> NSFont.Weight {
		resolve().nsFontWeight()
	}
}

public extension Font.Weight {
	func nsFontWeight() -> NSFont.Weight {
		switch self {
		case .ultraLight: .ultraLight
		case .light: .light
		case .thin: .thin
		case .regular: .regular
		case .medium: .medium
		case .semibold: .semibold
		case .bold: .bold
		case .heavy: .heavy
		case .black: .black
		default: .regular
		}
	}
}

public extension Font.TextStyle {
	func nsTextStyle() -> NSFont.TextStyle {
		switch self {
		case .body: .body
		case .callout: .callout
		case .caption: .caption1
		case .caption2: .caption2
		case .footnote: .footnote
		case .headline: .headline
		case .largeTitle: .largeTitle
		case .subheadline: .subheadline
		case .title: .title1
		case .title2: .title2
		case .title3: .title3
		default: .body
		}
	}
}
#endif

#if os(iOS)
extension FontWeight {
	func resolve() -> UIFont.Weight {
		resolve().uiFontWeight()
	}
}

extension Font.Weight {
	func uiFontWeight() -> UIFont.Weight {
		switch self {
		case .ultraLight: .ultraLight
		case .light: .light
		case .thin: .thin
		case .regular: .regular
		case .medium: .medium
		case .semibold: .semibold
		case .bold: .bold
		case .heavy: .heavy
		case .black: .black
		default: .regular
		}
	}
}

extension Font.TextStyle {
	func uiTextStyle() -> UIFont.TextStyle {
		switch self {
		case .body: .body
		case .callout: .callout
		case .caption: .caption1
		case .caption2: .caption2
		case .footnote: .footnote
		case .headline: .headline
		case .largeTitle: .largeTitle
		case .subheadline: .subheadline
		case .title: .title1
		case .title2: .title2
		case .title3: .title3
		default: .body
		}
	}
}
#endif

// MARK: - System Font Family
public extension Theme.Font.Family<FoundationUISystemFontWeight> {
	static let system = Self()
}

// MARK: - SwiftUI.Font Extension

public enum FontFamilyScaling {
	case fixed
	case textStyle(Font.TextStyle)
}

extension Font {
	public static func foundationFamily<Weight: FontWeight>(_ name: Theme.Font.Family<Weight>, size: CGFloat, weight: Weight, scaling: FontFamilyScaling = .textStyle(.body)) -> Self {
		name.resolve(size: size, weight: weight, scaling: scaling)
	}
}

#if os(macOS)
extension NSFont {
	public static func foundationFamily<Weight: FontWeight>(_ name: Theme.Font.Family<Weight>, size: CGFloat, weight: Weight, scaling: FontFamilyScaling = .textStyle(.body)) -> NSFont {
		name.resolve(size: size, weight: weight, scaling: scaling)
	}
}
#endif

#if os(iOS)
extension UIFont {
	public static func foundationFamily<Weight: FontWeight>(_ name: Theme.Font.Family<Weight>, size: CGFloat, weight: Weight, scaling: FontFamilyScaling = .textStyle(.body)) -> UIFont {
		name.resolve(size: size, weight: weight, scaling: scaling)
	}
}
#endif
