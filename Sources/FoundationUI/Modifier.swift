//
//  Modifier.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI

extension FoundationUI {
    private struct Border: ViewModifier {
        @Environment(\.foundationRadius) private var env
        let color: SwiftUI.Color
        let width: CGFloat
        func body(content: Content) -> some View {
            content.overlay {
                RoundedRectangle(cornerRadius: env.radius, style: env.style)
                    .stroke(lineWidth: width)
                    .padding(width / 2) // TODO: Inside / Outside / Center
                    .opacity(0.3) // TODO: Opacity
                    .blendMode(.plusLighter) // TODO: BlendMode
            }
        }
    }
    struct Modifier<Content: View> {
        private var view: Content
        internal init(_ view: Content) {
            self.view = view
        }
        func background(_ style: some ShapeStyle, cornerRadius: CGFloat = 0, cornerRadiusStyle: RoundedCornerStyle = .continuous) -> some View {
            view
                .environment(\.foundationRadius, (cornerRadius, cornerRadiusStyle))
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: cornerRadiusStyle)
                        .foregroundStyle(style)
                }
        }
        // TODO: Theme should have a set of predefined styles
        func border(color: SwiftUI.Color, width: CGFloat) -> some View {
            view
                .modifier(FoundationUI.Border(color: color, width: width))
        }
    }
}


extension View {
    var theme: FoundationUI.Modifier<Self> { FoundationUI.Modifier(self) }
}

#Preview("Name"){
    VStack {
        Text("Hello!")
            .padding()
            .theme.border(color: .white, width: 1)
            .theme.background(.blue, cornerRadius: 12)
    }
    .padding()
}

//extension FoundationUI {
//    public class Config {}
//    static func getRoundedShape(_ foundationRadius: CGFloat) -> RoundedRectangle {
//        RoundedRectangle(cornerRadius: foundationRadius, style: .continuous)
//    }
//    public struct Background: ViewModifier {
//        @ObservedObject var ui = FoundationUI.shared
//        private let color: Theme.Color
//        private let rounded: Theme.Radius
//        public init(_ color: Theme.Color, rounded: Theme.Radius = .none) {
//            self.color = color
//            self.rounded = rounded
//        }
//        public func body(content: Content) -> some View {
//            content
//                .background(color.value.foundation(.radius(rounded)))
//                .environment(\.foundationBackgroundColor, color)
//        }
//    }
//    public struct ForegroundColor: ViewModifier {
//        @Environment(\.foundationBackgroundColor) private var backgroundColor
//        @ObservedObject var ui = FoundationUI.shared
//        private let color: Theme.Color?
//        private var colorValue: Color {
//            if let color {
//                return color.value
//            }
//            return backgroundColor.inverted().value
//        }
//        public init(_ color: Theme.Color?) {
//            self.color = color
//        }
//        public func body(content: Content) -> some View {
//            content
//                .foregroundColor(colorValue)
//        }
//    }
//    public struct ClipContent: ViewModifier {
//        @Environment(\.foundationRadius) private var foundationRadius
//        private let bypass: Bool
//        public init(_ bypass: Bool = false) {
//            self.bypass = bypass
//        }
//        public func body(content: Content) -> some View {
//            if bypass {
//                content
//            } else {
//                content
//                    .clipShape(FoundationUI.getRoundedShape(foundationRadius))
//            }
//        }
//    }
//    // MARK: - TODO
//    // Stroke
//    // - outside nestedRadius
//    // - inside overlay + stroke
//    // - center mixed
//    // Font
//    // - size
//    // - other settings
//    // Shadow
//    // Animation
//}
//
//// TODO: Preview Layout Template (look for inspiration on Figma and Sketch design system templates)
//
//
//// MARK: View.foundation() extension
//public enum FoundationModifier {
//    /// Padding
//    case padding(_ value: Theme.Spacing = .base, _ edges: Edge.Set = .all)
//    static public var padding: FoundationModifier {
//        .padding()
//    }
//    case radius(_ radius: Theme.Radius = .base, clipContent: Bool = true)
//    case nestedRadius
//    case background(_ color: Theme.Color = .primary.background, rounded: Theme.Radius = .none)
//    case foreground(_ color: Theme.Color? = .primary.foreground)
//    case clipContent
//    
//    static public var foreground: FoundationModifier {
//        .foreground(nil) // auto
//    }
//    
//    // Short
//    static public var bg: FoundationModifier {
//        .background()
//    }
//    static public func bg(_ value: CGFloat) -> FoundationModifier {
//        .background()
//    }
//}
//
//extension View {
//    @ViewBuilder
//    public func foundation(_ modifier: FoundationModifier?) -> some View {
//        let view = self.colorSchemeObserver()
//        switch modifier {
//        case .padding(let padding, let edges):
//            view.modifier(FoundationUI.Padding(padding, edges: edges))
//        case .nestedRadius:
//            view.modifier(FoundationUI.ClipContent())
//                .modifier(FoundationUI.NestedRadius())
//        case .radius(let radius, let clipContent):
//            view.modifier(FoundationUI.ClipContent(!clipContent))
//                .modifier(FoundationUI.Radius(radius))
//        case .background(let color, let rounded):
//            view.modifier(FoundationUI.Background(color, rounded: rounded))
//        case .foreground(let color):
//            view.modifier(FoundationUI.ForegroundColor(color))
//        case .clipContent:
//            view.modifier(FoundationUI.ClipContent())
//        case .none:
//            view
//        }
//    }
//    
//    /// Special modifier for tracking the changes in app's color scheme and update ``FoundationUI``'s color scheme dependable values
//    ///
//    /// Should be applied once to the root content view:
//    /**
//    ```swift
//    @main
//    struct FoundationUI_PlaygroundApp: App {
//        var body: some Scene {
//            WindowGroup {
//                ContentView()
//                    .colorSchemeObserver()
//            }
//        }
//    }
//    ```
//    */
//    /// And to every preview:
//    /**
//    ```swift
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            VStack {
//                ContentView()
//            }
//            .colorSchemeObserver()
//        }
//    }
//    ```
//    */
//    @ViewBuilder
//    public func colorSchemeObserver() -> some View {
//        self.modifier(FoundationUI.ColorSchemeObserver())
//    }
//}
//
// MARK: - Environment Values
private struct FoundationRadiusKey: EnvironmentKey {
    static let defaultValue: (radius: CGFloat, style: RoundedCornerStyle) = (0, .continuous)
}

private struct FoundationPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}
//
//private struct FoundationBackgroundColorKey: EnvironmentKey {
//    static let defaultValue: Theme.Color = .primary.background
//}
//
extension EnvironmentValues {
    public var foundationRadius: (radius: CGFloat, style: RoundedCornerStyle) {
        get { self[FoundationRadiusKey.self] }
        set { self[FoundationRadiusKey.self] = newValue }
    }
    public var foundationPadding: CGFloat {
        get { self[FoundationPaddingKey.self] }
        set { self[FoundationPaddingKey.self] = newValue }
    }
//    public var foundationBackgroundColor: Theme.Color {
//        get { self[FoundationBackgroundColorKey.self] }
//        set { self[FoundationBackgroundColorKey.self] = newValue }
//    }
}
