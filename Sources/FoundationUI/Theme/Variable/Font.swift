//
//  Font.swift
//
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

// MARK: - Font

extension Theme {
    @frozen
	public struct Font: FoundationVariableWithValue {
        public typealias Result = SwiftUI.Font
        
        public var value: SwiftUI.Font
		public var environmentAdjustment: EnvironmentAdjustment?
        
        public init() { self = .init(.body) }
        
        public init(value: SwiftUI.Font) {
            self.value = value
        }
    }
}

// MARK: - Font Family

#warning("TODO: Test on macOS / iOS")
#warning("Font Style: normal, italic, ...")

extension Theme.Font {
	/// - TODO: Add mini tutorial on how to add font family (Project / Package)
	public struct Family<Weight: FontWeight>: Sendable {
		public typealias Name = String
		public let name: Name
		
		public init(_ name: Name) {
			self.name = name
		}
		
		public func resolve(size: CGFloat, weight: Weight, scaling: FontFamilyScaling = .textStyle(.body)) -> SwiftUI.Font {
			if name == .system {
				return .system(size: size, weight: weight.resolve())
			}
			Self.register()
			switch scaling {
			case .fixed:
				return .custom(name, fixedSize: size).weight(weight.resolve())
			case .textStyle(let textStyle):
				return .custom(name, size: size, relativeTo: textStyle).weight(weight.resolve())
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
				print(message)
			}
			
		}
	}
}

#if os(macOS)
public extension Theme.Font.Family {
	func resolve(size: CGFloat, weight: Weight, scaling: FontFamilyScaling = .textStyle(.body)) -> NSFont {
		if name == .system {
			return .systemFont(ofSize: size, weight: weight.resolve())
		}
		Self.register()
		var font: NSFont = .systemFont(ofSize: size)
		switch scaling {
		case .fixed:
			font = .init(name: name, size: size) ?? font
		case .textStyle(let textStyle):
			let size = NSFont.preferredFont(forTextStyle: textStyle.nsTextStyle()).pointSize
			font = .init(name: name, size: size) ?? font
		}
		
		return font
	}
}
#endif

#if os(iOS)
public extension Theme.Font.Family {
	func resolve(size: CGFloat, weight: Weight, scaling: FontFamilyScaling = .textStyle(.body)) -> UIFont {
		if name == .system {
			return .systemFont(ofSize: size, weight: weight.resolve())
		}
		Self.register()
		var font: UIFont = .systemFont(ofSize: size)
		switch scaling {
		case .fixed:
			font = .init(name: name, size: size) ?? font
		case .textStyle(let textStyle):
			let size = UIFont.preferredFont(forTextStyle: textStyle.uiTextStyle()).pointSize
			font = .init(name: name, size: size) ?? font
		}
		
		return font
	}
}
#endif

// MARK: Font Weight

public protocol FontWeight: CaseIterable {
	var url: URL? { get }
	func resolve() -> Font.Weight
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

private extension Theme.Font.Family.Name {
	static let system = "San Francisco"
}

public extension Theme.Font.Family<FoundationUISystemFontWeight> {
	static let system = Self(.system)
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


// MARK: - Preview

struct Font_Preview: PreviewProvider {
    struct FontTest: View {
        let label: String
        let value: Theme.Font
        var body: some View {
            VStack(alignment: .leading, spacing: 1) {
                Text("\(label)")
                    .font(value.value)
            }
        }
    }
    static var previews: some View {
        VStack(alignment: .leading) {
            FontTest(label: "xxSmall", value: .xxSmall)
            FontTest(label: "xSmall", value: .xSmall)
            FontTest(label: "small", value: .small)
            FontTest(label: "regular", value: .regular)
            FontTest(label: "large", value: .large)
            FontTest(label: "xLarge", value: .xLarge)
            FontTest(label: "xxLarge", value: .xxLarge)
			Divider()
				.frame(maxWidth: 200)
				.padding(.bottom, 16)
			Text("Font Family")
				.foundation(.font(.init(.foundationFamily(.system, size: 12, weight: .bold))))
        }
        .padding()
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
