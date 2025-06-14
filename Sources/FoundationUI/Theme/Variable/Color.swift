//
//  Color.swift
//  
//
//  Created by Art Lasovsky on 29/06/2024.
//

import Foundation
import SwiftUI

extension Theme {
    @frozen
    public struct Color: FoundationColorVariable {
        public var color: DynamicColor
        private var variant: Variant?
        private var colorScheme: FoundationColorScheme?
		
		public var environmentAdjustment: EnvironmentAdjustment?
        
        public init(color: DynamicColor) {
            self.color = color
        }
        
        public static func from(color: SwiftUI.Color) -> Self {
            self.init(color: .from(color: color))
        }
        
        #if os(macOS)
        public static func from(nsColor: NSColor) -> Self {
            self.init(color: .from(nsColor: nsColor))
        }
        #elseif os(iOS)
        public static func from(uiColor: UIColor) -> Self {
            self.init(color: .from(uiColor: uiColor))
        }
        #endif
    }
}

extension Theme.Color: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(color)
		hasher.combine(variant)
		hasher.combine(colorScheme)
	}
}

// MARK: Initializers
public extension Theme.Color {
    init(_ universal: ColorComponents) {
        color = .init(universal)
    }
    
    init(light: ColorComponents, dark: ColorComponents, lightAccessible: ColorComponents? = nil, darkAccessible: ColorComponents? = nil) {
        color = .init(
            light: light,
            dark: dark,
            lightAccessible: lightAccessible,
            darkAccessible: darkAccessible
        )
    }
}

// MARK: Adjust Components
public extension Theme.Color {
    private func updateValue(_ value: DynamicColor) -> Self {
        var copy = self
        copy.color = value
        return copy
    }
    
    func hue(_ value: CGFloat) -> Self {
        updateValue(color.hue(value))
    }
    
    func brightness(_ value: CGFloat) -> Self {
        updateValue(color.brightness(value))
    }
    
    func saturation(_ value: CGFloat) -> Self {
        updateValue(color.saturation(value))
    }
    
    func opacity(_ value: CGFloat) -> Self {
        updateValue(color.opacity(value))
    }
    
    func colorScheme(_ colorScheme: FoundationColorScheme) -> Self {
        var copy = updateValue(color.colorScheme(colorScheme))
        copy.colorScheme = colorScheme
        return copy
    }
    
    func blendMode(_ mode: BlendMode) -> Self {
        updateValue(color.blendMode(mode))
    }
    
    func blendMode(_ mode: DynamicColor.ExtendedBlendMode) -> Self {
        updateValue(color.blendMode(mode))
    }
}

// MARK: Conform to ShapeStyle
extension Theme.Color {
    public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
		resolveColorValue(in: environment)
    }
    
    public func resolveColor(in environment: EnvironmentValues) -> SwiftUI.Color {
		resolveColorValue(in: environment).resolveColor(in: environment)
    }
    
	private func resolveColorValue(in environment: EnvironmentValues) -> Variant.ColorValue {
		let themed = resolveWithAdjustedEnviroment(in: environment)
		let variant = themed.variant
		let color = themed.color
        if let variant {
            let tint = environment.dynamicTint.color
            var adjusted = variant.adjust(tint)
            let components = color.resolveComponents(in: .init(environment))
            if components.hue != 1 {
                adjusted = adjusted.hue(components.hue)
            }
            if components.saturation != 1 {
                adjusted = adjusted.saturation(components.saturation)
            }
            if components.brightness != 1 {
                adjusted = adjusted.brightness(components.brightness)
            }
            if components.opacity != 1 {
                adjusted = adjusted.opacity(components.opacity)
            }
            if let colorScheme {
                adjusted = adjusted.colorScheme(colorScheme)
            }
            return adjusted.copyBlendMode(from: color)
        } else {
            return color
        }
    }
	
	private func resolveWithAdjustedEnviroment(in environment: EnvironmentValues) -> Self {
		environmentAdjustment?(self, environment) ?? self
	}
}

// MARK: Modifiers
extension Theme.Color {
    public static func modified(_ universal: Variant.Modifier) -> Self {
        .dynamic(.modified(universal))
    }
    
    public static func modified(
        light: Variant.Modifier,
        dark: Variant.Modifier,
        lightAccessible: Variant.Modifier? = nil,
        darkAccessible: Variant.Modifier? = nil
    ) -> Self {
        .dynamic(
            .modified(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
    
    public static func modifiedColor(_ universal: Theme.Color) -> Self {
        .dynamic(.modifiedColor(universal))
    }
    
    public static func modifiedColor(
        light: Theme.Color,
        dark: Theme.Color,
        lightAccessible: Theme.Color? = nil,
        darkAccessible: Theme.Color? = nil
    ) -> Self {
        .dynamic(
            .modifiedColor(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
    
    public static func modifiedSource(_ universal: @escaping Variant.ComponentAdjust) -> Self {
        .dynamic(.modifiedSource(universal))
    }
    
    public static func modifiedSource(
        light: @escaping Variant.ComponentAdjust,
        dark: @escaping Variant.ComponentAdjust,
        lightAccessible: Variant.ComponentAdjust? = nil,
        darkAccessible: Variant.ComponentAdjust? = nil
    ) -> Self {
        .dynamic(
            .modifiedSource(
                light: light,
                dark: dark,
                lightAccessible: lightAccessible,
                darkAccessible: darkAccessible
            )
        )
    }
}

// MARK: Equatable
extension Theme.Color: Equatable {
    public static func == (lhs: Theme.Color, rhs: Theme.Color) -> Bool {
        if let lhsVariant = lhs.variant, let rhsVariant = rhs.variant {
            lhsVariant.adjust(lhs.color) == rhsVariant.adjust(rhs.color)
        } else {
            lhs.color == rhs.color
        }
    }
}

// MARK: - Variant

public extension Theme.Color {
    struct Variant: Sendable {
        public typealias ColorValue = DynamicColor
        public typealias ComponentAdjust = @Sendable (ColorValue.Components) -> ColorValue.Components
        
        var adjust: @Sendable (ColorValue) -> ColorValue
        
        public init(adjust: @escaping @Sendable (ColorValue) -> ColorValue) {
            self.adjust = adjust
        }
        
        private init(
            light: @escaping ComponentAdjust,
            dark: @escaping ComponentAdjust,
            lightAccessible: ComponentAdjust? = nil,
            darkAccessible: ComponentAdjust? = nil
        ) {
            self.init { source in
                .init(
                    light: light(source.light),
                    dark: dark(source.dark),
                    lightAccessible: (lightAccessible ?? light)(source.lightAccessible),
                    darkAccessible: (darkAccessible ?? dark)(source.darkAccessible)
                )
            }
        }
    }
    func variant(_ variant: Variant) -> Self {
        .init(color: variant.adjust(color).copyBlendMode(from: color))
    }
    
    static func dynamic(_ variant: Variant) -> Self {
        /// the color itself will be replaces with by the enviroment tint (`.dynamicTint`)
        /// adjustment applied to this color will be applied to the environment tint
        var color: Self = .init(.init(hue: 1, saturation: 1, brightness: 1))
        color.variant = variant
        return color
    }
}

extension Theme.Color.Variant: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(adjust(.from(color: .accentColor)))
        hasher.combine(adjust(.from(color: .gray)))
    }
}

extension Theme.Color.Variant {
    public typealias Variant = Theme.Color.Variant
	public enum Modifier: Sendable {
        case source(ComponentAdjust)
        case color(Theme.Color)
        
        func resolve(_ source: ColorComponents, in colorScheme: FoundationColorScheme) -> ColorComponents {
            switch self {
            case .source(let adjust):
                return adjust(source)
            case .color(let color):
                var environment: EnvironmentValues = .init(colorScheme: colorScheme.colorScheme, colorSchemeContrast: colorScheme.colorSchemeContrast)
                environment.dynamicTint = .init(source)
                let components = color.resolveColorValue(in: environment).resolveComponents(in: colorScheme)
                return source.changes.apply(to: components)
            }
        }
    }
    
    public static func modified(
        light: Modifier,
        dark: Modifier,
        lightAccessible: Modifier? = nil,
        darkAccessible: Modifier? = nil
    ) -> Theme.Color.Variant {
        self.init(
            light: { light.resolve($0, in: .light) },
            dark: { dark.resolve($0, in: .dark) },
            lightAccessible: { (lightAccessible ?? light).resolve($0, in: .lightAccessible) },
            darkAccessible: { (darkAccessible ?? dark).resolve($0, in: .darkAccessible) }
        )
    }
    
    public static func modified(_ modifier: Modifier) -> Variant {
        .modified(
            light: modifier,
            dark: modifier
        )
    }
    
    public static func modifiedColor(_ color: Theme.Color) -> Variant {
        .modified(.color(color))
    }
    
    public static func modifiedColor(
        light: Theme.Color,
        dark: Theme.Color,
        lightAccessible: Theme.Color? = nil,
        darkAccessible: Theme.Color? = nil
    ) -> Variant {
        .modified(
            light: .color(light),
            dark: .color(dark),
            lightAccessible: .color(lightAccessible ?? light),
            darkAccessible: .color(darkAccessible ?? dark)
        )
    }
    
    public static func modifiedSource(_ adjust: @escaping Variant.ComponentAdjust) -> Variant {
        .modified(.source(adjust))
    }
    
    public static func modifiedSource(
        light: @escaping Variant.ComponentAdjust,
        dark: @escaping Variant.ComponentAdjust,
        lightAccessible: Variant.ComponentAdjust? = nil,
        darkAccessible: Variant.ComponentAdjust? = nil
    ) -> Variant {
        .modified(
            light: .source(light),
            dark: .source(dark),
            lightAccessible: .source(lightAccessible ?? light),
            darkAccessible: .source(darkAccessible ?? dark)
        )
    }
}

// MARK: - Swatch

public extension Theme.Color {
    static func swatch() -> some View {
        Scale()
    }
}

// MARK: - Previews


struct Scale: View {
    @Environment(\.dynamicTint) private var tint
    struct ScaleSwatch: View {
        @Environment(\.dynamicTint) private var tint
        let variant: Theme.Color.Variant
        var mark: Bool = false
        
        init(_ variant: Theme.Color.Variant, mark: Bool = false) {
            self.variant = variant
            self.mark = mark
        }

        
        var body: some View {
            Rectangle()
                .foundation(.foreground(.dynamic(variant)))
				.foundation(.size(square: .small))
                .overlay(alignment: .topTrailing) {
                    if mark {
                        Circle()
							.foundation(.size(square: .xxSmall))
                            .foundation(.padding(.small))
                            .foundation(.foreground(tint.blendMode(.vibrant).opacity(0.2)))
                    }
                }
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            TextSample()
            Divider()
                .foundation(.size(width: .small))
                .foundation(.foreground(.dynamic(.borderSubtle)))
            ScaleSwatch(.backgroundSubtle)
            ScaleSwatch(.background, mark: true)
            ScaleSwatch(.backgroundProminent)
            ScaleSwatch(.borderSubtle)
            ScaleSwatch(.border, mark: true)
            ScaleSwatch(.borderProminent)
            ScaleSwatch(.fillSubtle)
            ScaleSwatch(.fill, mark: true)
            ScaleSwatch(.fillProminent)
            ScaleSwatch(.solidSubtle)
            ScaleSwatch(.solid, mark: true)
            ScaleSwatch(.solidProminent)
            ScaleSwatch(.textSubtle)
            ScaleSwatch(.text, mark: true)
            ScaleSwatch(.textProminent)
            
        }
        .foundation(.padding(.regular))
        .foundation(.background(.dynamic(.backgroundSubtle)))
    }
    
    struct TextSample: View {
        var body: some View {
            Text("Text")
                .foundation(.padding(.regular))
                .foundation(.foreground(.dynamic(.text)))
                .foundation(.font(.small))
                .fixedSize()
        }
    }
}

struct ColorScalePreview: PreviewProvider {
    struct ScaleSet: View {
        var body: some View {
            HStack(spacing: 0) {
                Theme.Color.swatch().foundation(.tintColor(.accentColor))
                Theme.Color.swatch().foundation(.tint(.primary))
            }
        }
    }
    
    static var previews: some View {
        Theme.Color.swatch()
        ScaleSet()
            .foundation(.clip(.rect(cornerRadius: 8)))
            .scenePadding()
            ._colorScheme(.light)
            .previewDisplayName("Scale Light")
        ScaleSet()
            .foundation(.clip(.rect(cornerRadius: 8)))
            ._colorScheme(.dark)
            .scenePadding()
            .previewDisplayName("Scale Dark")
    }
}

// MARK: UI Mock Preview

struct Sample_Preview: PreviewProvider {
    struct PushButton: View {
        enum Variant {
            case primary
            case secondary
            case tinted
        }
        
        var variant: Variant = .secondary
        
        var body: some View {
            Text("Label")
                .foundation(.padding(.regular, .horizontal))
                .foundation(.padding(.small, .vertical))
                .foundation(.foreground(foreground))
                .foundation(.background(background))
                .foundation(.backgroundShadow(.init(color: .black.opacity(0.2), radius: 0.8, spread: -0.2, y: 0.8)))
                .foundation(.border(border, width: 0.75, placement: .outside))
                .foundation(.cornerRadius(.small))
        }
        
        private var border: Theme.Color {
            switch variant {
            case .primary:
                .clear
            case .secondary, .tinted:
                .primary.variant(.border)
            }
        }
        
        private var foreground: Theme.Color {
            switch variant {
            case .primary: .primary.variant(.text).colorScheme(.dark)
            case .secondary: .primary.variant(.text)
            case .tinted: .modifiedColor(
                light: .dynamic(.solid),
                dark: .dynamic(.solid).saturation(0.8)
            )
            }
        }
        
        private var background: Theme.Color {
            switch variant {
            case .primary: .dynamic(.solid)
            case .secondary, .tinted: .modifiedColor(
                light: .primary.variant(.background),
                dark: .primary.variant(.fillSubtle)
            )
            }
        }
    }
    
    struct PopUpButton: View {
        var body: some View {
//            VStack(alignment: .leading, spacing: .foundation(.spacing(.small))) {
            VStack {
                PushButton()
                VStack(alignment: .leading, spacing: 0) {
                    ListItem(label: "Item One")
                    ListItem(label: "Item Two")
                    ListItem(label: "Item Three", isSelected: true)
                }
                .foundation(.size(width: .regular.up(.half), alignment: .leading))
                .foundation(.padding(.small.up(.half), concentricShapeStyle: .soft))
                .foundation(.background(.primary.variant(.background)))
                .foundation(.border(.primary.variant(.border), width: 0.75, placement: .outside))
                .foundation(.backgroundShadow(.xLarge))
                .foundation(.cornerRadius(.regular.up(.half)))
            }
        }
        
        struct ListItem: View {
            let label: String
            var isSelected: Bool = false
            var body: some View {
                Text(label)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foundation(.padding(.small, .vertical))
                    .foundation(.padding(.regular, .horizontal))
                    .foundation(.background(background))
                    .foundation(.foreground(foreground))
            }
            
            private var background: Theme.Color {
                if isSelected {
                    return .dynamic(.solid)
                } else {
                    return .clear
                }
            }
            
            private var foreground: Theme.Color {
                if isSelected {
                    return .primary.variant(.text).colorScheme(.dark)
                } else {
                    return .primary.variant(.text)
                }
            }
        }
    }
    
    struct TextField: View {
        var body: some View {
            Text("Placeholder")
                .foundation(.background(.dynamic(.fill), in: .rect))
                .foundation(.size(width: .large, alignment: .leading))
                .foundation(.padding(.regular, .horizontal))
                .foundation(.padding(.small, .vertical))
                .foundation(.background(.primary.variant(.background)))
                .foundation(.border(.primary.variant(.borderProminent), width: 1))
                .foundation(.backgroundShadow(.init(color: .black.opacity(0.2), radius: 0.8, spread: -0.2, y: 0.8)))
                .foundation(.border(.dynamic(.fillProminent), width: 3, placement: .outside, level: .below))
                .foundation(.cornerRadius(.regular))
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foundation(.padding(.small, .trailing))
                        .foundation(.foreground(.primary.variant(.fill)))
                }
        }
    }
    
    
    struct Grouped: View {
        var body: some View {
//            HStack(spacing: .foundation(.spacing(.large))) {
            HStack {
                VStack {
                    VStack {
                        Text("Title").foundation(.foreground(.dynamic(.textProminent)))
                        Text("Subtitle").foundation(.foreground(.dynamic(.text)))
                        Text("Heading").foundation(.foreground(.dynamic(.textSubtle)))
                    }
                    .foundation(.tint(.primary))
                    PushButton(variant: .primary)
                    PushButton(variant: .secondary)
                    PushButton(variant: .tinted)
                    TextField()
                    // Push Button
                    // Pop-Up Button
                    // Text Field
                    // Segmented Control
                }
                VStack {
                    Text("Title").foundation(.foreground(.dynamic(.textProminent)))
                    Text("Subtitle").foundation(.foreground(.dynamic(.text)))
                    Text("Heading").foundation(.foreground(.dynamic(.textSubtle)))
                    Divider()
                        .frame(width: 100)
                    Rectangle()
                        .frame(width: 100, height: 1)
                        .foundation(.foreground(.primary.variant(.border)))
                    Rectangle()
                        .frame(width: 100, height: 1)
                        .foundation(.foreground(.dynamic(.border)))
                    PopUpButton()
                }
            }
            .foundation(.tintColor(.accentColor))
            .foundation(.padding(.regular))
            .foundation(.backgroundStyle(.background))
        }
    }
    
    static var previews: some View {
        HStack(spacing: 0) {
            Grouped()._colorScheme(.light)
            Grouped()._colorScheme(.dark)
        }
        .previewDisplayName(String(describing: Self.self).components(separatedBy: "_")[0])
    }
}
