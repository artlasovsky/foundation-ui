//import Foundation
//import SwiftUI
//
//// MARK: - Radius
//public protocol FoundationUIRadius {
//    static func custom(_ value: CGFloat) -> Theme.Radius
//    static var none: Theme.Radius { get }
//    static var xs: Theme.Radius { get }
//    static var sm: Theme.Radius { get }
//    static var base: Theme.Radius { get }
//    static var lg: Theme.Radius { get }
//    static var xl: Theme.Radius { get }
//}
//// MARK: Default implementation
//extension FoundationUIRadius {
//    public static func custom(_ value: CGFloat) -> Theme.Radius { .init(value) }
//    public static var none: Theme.Radius { .init(0) }
//    public static var xs:   Theme.Radius { .init(4) }
//    public static var sm:   Theme.Radius { .init(8) }
//    public static var base: Theme.Radius { .init(10) }
//    public static var lg:   Theme.Radius { .init(14) }
//    public static var xl:   Theme.Radius { .init(18) }
//}
//
//extension Theme {
//    public struct Radius: FoundationUIRadius {
//        public var value: CGFloat
//        public init(_ value: CGFloat) {
//            self.value = value
//        }
//    }
//}
//
//// MARK: - Spacing
//public protocol FoundationUISpacing {
//    static func custom(_ value: CGFloat) -> Theme.Spacing
//    static var none: Theme.Spacing { get }
//    static var xs: Theme.Spacing { get }
//    static var sm: Theme.Spacing { get }
//    static var base: Theme.Spacing { get }
//    static var lg: Theme.Spacing { get }
//    static var xl: Theme.Spacing { get }
//}
//// MARK: Default implementation
//extension FoundationUISpacing {
//    public static func custom(_ value: CGFloat) -> Theme.Spacing { .init(value) }
//    public static var none: Theme.Spacing { .init(0) }
//    public static var xs:   Theme.Spacing { .init(2) }
//    public static var sm:   Theme.Spacing { .init(4) }
//    public static var base: Theme.Spacing { .init(6) }
//    public static var lg:   Theme.Spacing { .init(10) }
//    public static var xl:   Theme.Spacing { .init(14) }
//}
//
//extension Theme {
//    public struct Spacing: FoundationUISpacing {
//        public var value: CGFloat
//        public init(_ value: CGFloat) {
//            self.value = value
//        }
//    }
//}
//extension CGFloat {
//    public static func foundation(_ spacing: Theme.Spacing) -> Self {
//        spacing.value
//    }
//}
//
//// MARK: - Previews
//
//#if DEBUG
//// Temporary to test
//extension Theme.Color {
//    static var twBlue: Self {
//        .init(
//            universal: .init(
//                .init(hex: "#dbeafe"),
//                .init(hex: "#bfdbfe"),
//                .init(hex: "#93c5fd"),
//                .init(hex: "#60a5fa"),
//                .init(hex: "#3b82f6"),
//                .init(hex: "#2563eb"),
//                .init(hex: "#1d4ed8"),
//                .init(hex: "#1e40af"),
//                .init(hex: "#1e3a8a")
//            ),
//            dark: .init(
//                .init(hex: "#1e3a8a"),
//                .init(hex: "#1e40af"),
//                .init(hex: "#1d4ed8"),
//                .init(hex: "#2563eb"),
//                .init(hex: "#3b82f6"),
//                .init(hex: "#60a5fa"),
//                .init(hex: "#93c5fd"),
//                .init(hex: "#bfdbfe"),
//                .init(hex: "#dbeafe")
//            )
//        )
//    }
//}
//
//struct SamplePreview: View {
//    struct ColorSample: View {
//        let label: String
//        let color: Theme.Color
//        init(color: Theme.Color, label: String = "T") {
//            self.label = label
//            self.color = color
//        }
//        var body: some View {
//            ZStack {
//                Rectangle()
//                    .frame(width: 30, height: 50)
//                    .foundation(.foreground(color))
//                Text(label)
//                    .font(.system(.caption, design: .monospaced))
//                    .foregroundColor(color.inverted.value)
//            }
//            .foundation(.nestedRadius)
//            .foundation(.padding(.custom(1)))
//            .foundation(.background(.primary.background.faded))
//        }
//    }
//    
//    struct ColorSamples: View {
//        private let color: Theme.Color
//        @Environment(\.colorScheme) private var systemColorScheme
//        private let colorSchemeOverride: ColorScheme?
//        private var colorScheme: ColorScheme {
//            colorSchemeOverride ?? systemColorScheme
//        }
//        init(color: Theme.Color, colorScheme: ColorScheme? = nil) {
//            self.color = color
//            self.colorSchemeOverride = colorScheme
//        }
//        let bgColor: Color = .white
//        let textColor: Color = .black
//        var body: some View {
//            HStack (spacing: .foundation(.sm)) {
//                let color = color.colorScheme(colorScheme)
//                VStack {
//                    if colorScheme == .dark {
//                        Text("Dark ").font(.system(.caption, design: .monospaced))
//                    } else if colorScheme == .light {
//                        Text("Light ").font(.system(.caption, design: .monospaced))
//                    }
//                }
//                ColorSample(color: color.background.faded)
//                ColorSample(color: color.background)
//                ColorSample(color: color.background.emphasized)
//                ColorSample(color: color.fill.faded)
//                ColorSample(color: color.fill)
//                ColorSample(color: color.fill.emphasized)
//                ColorSample(color: color.foreground.faded)
//                ColorSample(color: color.foreground)
//                ColorSample(color: color.foreground.emphasized)
//            }
//        }
//    }
//    struct UISample: View {
//        var body: some View {
//            HStack (spacing: 0) {
//                VStack {
////                    Button(action: {}, label: { Text("Styled Button") })
////                        .buttonStyle(.plain)
////                        .foundation(.padding(.base, .horizontal))
////                        .foundation(.padding(.sm, .vertical))
////                        .foundation(.foreground)
////                        .foundation(.background(.accent, rounded: .sm))
//                    ZStack {
//                        Color.clear
////                            .foundation(.foreground(.primary))
//                            .foundation(.background())
//                            .foundation(.nestedRadius)
//                            .foundation(.padding(.sm))
//                    }
//                    .frame(width: 100, height: 40)
//                    .foundation(.background(.primary.foreground))
//                    .foundation(.nestedRadius)
//                    .foundation(.padding)
//                    .foundation(.background(.primary.foreground.faded))
//                    .foundation(.radius(.xl))
//                }
//                .frame(maxWidth: 150, maxHeight: .infinity)
//                .foundation(.background(.primary.background.faded))
//                Rectangle().frame(width: 1)
//                    .foundation(.foreground(.primary.background.emphasized))
//                VStack (spacing: 0) {
//                    Text("Foreground").foundation(.foreground())
//                    Text("Foreground Faded").foundation(.foreground(.primary.foreground.faded))
//                    Text("Fill").foundation(.foreground(.primary.fill))
//                    Text("Fill Faded").foundation(.foreground(.primary.faded))
//                    Text("Link").underline().foundation(.foreground(.accent.foreground))
//                    Text("Link").underline().foundation(.foreground())
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .foundation(.background(.primary.background.faded))
//            }.foundation(.foreground(.primary.foreground))
//        }
//    }
//    var body: some View {
//        VStack (spacing: .foundation(.none)) {
//            VStack (alignment: .trailing, spacing: .foundation(.sm)) {
//                ColorSamples(color: .primary, colorScheme: .dark)
//                ColorSamples(color: .primary, colorScheme: .light)
//                ColorSamples(color: .accent)
//                ColorSamples(color: .twBlue)
//                ColorSamples(color: .primary)
//            }
//            .frame(maxWidth: .infinity)
//            .foundation(.padding(.custom(.foundation(.sm))))
//            .foundation(.background(.primary.background))
//            Rectangle().frame(height: 1)
//                .foundation(.foreground(.primary.background.emphasized))
//            UISample()
//        }
//        .frame(width: 400, height: 400)
//        .colorSchemeObserver()
//    }
//}
//#endif
//
//struct ThemePreviews: PreviewProvider {
//    static var previews: some View {
//        SamplePreview()
//    }
//}
