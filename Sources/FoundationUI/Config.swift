import Foundation
import SwiftUI

// MARK: - Radius
public protocol FoundationUIRadius {
    static var none: FoundationUI.Config.Radius { get }
    static var xs: FoundationUI.Config.Radius { get }
    static var sm: FoundationUI.Config.Radius { get }
    static var base: FoundationUI.Config.Radius { get }
    static var lg: FoundationUI.Config.Radius { get }
    static var xl: FoundationUI.Config.Radius { get }
}
// MARK: Default implementation
extension FoundationUIRadius {
    public static var none: FoundationUI.Config.Radius { .init(0) }
    public static var xs:   FoundationUI.Config.Radius { .init(4) }
    public static var sm:   FoundationUI.Config.Radius { .init(8) }
    public static var base: FoundationUI.Config.Radius { .init(10) }
    public static var lg:   FoundationUI.Config.Radius { .init(14) }
    public static var xl:   FoundationUI.Config.Radius { .init(18) }
}

extension FoundationUI.Config {
    public struct Radius: FoundationUIRadius {
        public var value: CGFloat
        public init(_ value: CGFloat) {
            self.value = value
        }
    }
}

// MARK: - Spacing
public protocol FoundationUISpacing {
    static func custom(_ value: CGFloat) -> FoundationUI.Config.Spacing
    static var none: FoundationUI.Config.Spacing { get }
    static var xs: FoundationUI.Config.Spacing { get }
    static var sm: FoundationUI.Config.Spacing { get }
    static var base: FoundationUI.Config.Spacing { get }
    static var lg: FoundationUI.Config.Spacing { get }
    static var xl: FoundationUI.Config.Spacing { get }
}
// MARK: Default implementation
extension FoundationUISpacing {
    public static func custom(_ value: CGFloat) -> FoundationUI.Config.Spacing { .init(value) }
    public static var none: FoundationUI.Config.Spacing { .init(0) }
    public static var xs:   FoundationUI.Config.Spacing { .init(2) }
    public static var sm:   FoundationUI.Config.Spacing { .init(4) }
    public static var base: FoundationUI.Config.Spacing { .init(8) }
    public static var lg:   FoundationUI.Config.Spacing { .init(12) }
    public static var xl:   FoundationUI.Config.Spacing { .init(16) }
}

extension FoundationUI.Config {
    public struct Spacing: FoundationUISpacing {
        public var value: CGFloat
        public init(_ value: CGFloat) {
            self.value = value
        }
    }
}
extension CGFloat {
    public static func foundation(_ spacing: FoundationUI.Config.Spacing) -> Self {
        spacing.value
    }
}



// MARK: - Previews

#if DEBUG
struct SamplePreview: View {
    struct ColorSample: View {
        let label: String
        let color: FoundationUI.Config.Color
        init(color: FoundationUI.Config.Color, label: String = "T") {
            self.label = label
            self.color = color
        }
        var body: some View {
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 50)
                    .foundation(.foreground(color))
                Text(label)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(color.inverted().value)
            }
            .foundation(.nestedRadius)
            .foundation(.padding(.custom(1)))
            .foundation(.background(.primary.background(.faded)))
        }
    }
    struct ColorSamples: View {
        private let color: FoundationUI.Config.Color
        @Environment(\.colorScheme) private var systemColorScheme
        private let colorSchemeOverride: ColorScheme?
        private var colorScheme: ColorScheme {
            colorSchemeOverride ?? systemColorScheme
        }
        init(color: FoundationUI.Config.Color, colorScheme: ColorScheme? = nil) {
            self.color = color
            self.colorSchemeOverride = colorScheme
        }
        let bgColor: Color = .white
        let textColor: Color = .black
        var body: some View {
            HStack (spacing: .foundation(.sm)) {
                let color = color.colorScheme(colorScheme)
                VStack {
                    if colorScheme == .dark {
                        Text("Dark ").font(.system(.caption, design: .monospaced))
                    } else if colorScheme == .light {
                        Text("Light ").font(.system(.caption, design: .monospaced))
                    }
                }
                ColorSample(color: color.background(.faded))
                ColorSample(color: color.background)
                ColorSample(color: color.background(.emphasized))
                ColorSample(color: color.fill(.faded))
                ColorSample(color: color.fill)
                ColorSample(color: color.fill(.emphasized))
                ColorSample(color: color.foreground(.faded))
                ColorSample(color: color.foreground)
                ColorSample(color: color.foreground(.emphasized))
            }
        }
    }
    struct UISample: View {
        var body: some View {
            HStack (spacing: 0) {
                VStack {
                    //                    Text("Side")
                    Button(action: {}, label: { Text("Default Button") })
                    Button(action: {}, label: { Text("Custom Style") })
                        .buttonStyle(.plain)
                        .foundation(.padding(.base, .horizontal))
                        .foundation(.padding(.sm, .vertical))
                        .foundation(.foreground)
                        .foundation(.background(.accent.fill(.faded), rounded: .sm))
                }
                .frame(maxWidth: 150, maxHeight: .infinity)
                .foundation(.background(.primary.background(.faded)))
                Rectangle().frame(width: 1)
                    .foundation(.foreground(.primary.background(.emphasized)))
                VStack (spacing: 0) {
                    Text("Foreground").foundation(.foreground())
                    Text("Foreground Faded").foundation(.foreground(.primary.foreground(.faded)))
                    Text("Fill").foundation(.foreground(.primary.fill))
                    Text("Fill Faded").foundation(.foreground(.primary.fill(.faded)))
                    Text("Link").underline().foundation(.foreground(.accent.foreground))
                    Text("Link").underline().foundation(.foreground())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foundation(.background(.primary.background(.faded)))
            }.foundation(.foreground(.primary.foreground))
        }
    }
    var body: some View {
        VStack (spacing: .foundation(.none)) {
            VStack (alignment: .trailing, spacing: .foundation(.sm)) {
                ColorSamples(color: .primary, colorScheme: .dark)
                ColorSamples(color: .primary, colorScheme: .light)
                ColorSamples(color: .accent)
                ColorSamples(color: .twBlue)
                ColorSamples(color: .primary)
            }
            .frame(maxWidth: .infinity)
            .foundation(.padding(.custom(.foundation(.sm))))
            .foundation(.background(.primary.background))
            Rectangle().frame(height: 1)
                .foundation(.foreground(.primary.background(.emphasized)))
            UISample()
        }
        .frame(width: 400, height: 400)
        .colorSchemeObserver()
    }
}
#endif

struct ThemePreviews: PreviewProvider {
    static var previews: some View {
        SamplePreview()
    }
}
