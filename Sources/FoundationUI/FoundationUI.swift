//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI
#if os(macOS)
import AppKit
#endif


public class FoundationUI: ObservableObject {
    @Published public var colorScheme: ColorScheme = .dark
    public static var shared = FoundationUI()
}

extension FoundationUI {
    public class Config {}
    public struct Padding: ViewModifier {
        private let padding: CGFloat
        private let edges: Edge.Set
        public init(_ padding: Config.Spacing, edges: Edge.Set) {
            self.padding = padding.value
            self.edges = edges
        }        
        public func body(content: Content) -> some View {
            content
                .padding(edges, padding)
                .environment(\.foundationPadding, padding)
        }
    }
    public struct NestedRadius: ViewModifier {
        @Environment(\.foundationPadding) private var foundationPadding
        @Environment(\.foundationRadius) private var foundationRadius
        public init() {}
        
        private var radius: CGFloat {
            foundationRadius - foundationPadding
        }
        
        public func body(content: Content) -> some View {
            content
                .environment(\.foundationRadius, radius)
        }
    }
    public struct Radius: ViewModifier {
        private let radius: CGFloat
        public init(_ radius: FoundationUI.Config.Radius = .base) {
            self.radius = radius.value
        }
        public func body(content: Content) -> some View {
            content
                .environment(\.foundationRadius, radius)
        }
    }
    static func getRoundedShape(_ foundationRadius: CGFloat) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: foundationRadius, style: .continuous)
    }
    public struct Background: ViewModifier {
        @ObservedObject var ui = FoundationUI.shared
        private let color: FoundationUI.Config.Color
        private let rounded: FoundationUI.Config.Radius
        public init(_ color: FoundationUI.Config.Color, rounded: FoundationUI.Config.Radius = .none) {
            self.color = color
            self.rounded = rounded
        }
        public func body(content: Content) -> some View {
            content
                .background(color.value.foundation(.radius(rounded)))
        }
    }
    public struct ForegroundColor: ViewModifier {
        @ObservedObject var ui = FoundationUI.shared
        private let color: FoundationUI.Config.Color
        public init(_ color: FoundationUI.Config.Color) {
            self.color = color
        }
        public func body(content: Content) -> some View {
            content
                .foregroundColor(color.value)
        }
    }
    public struct ClipContent: ViewModifier {
        @Environment(\.foundationRadius) private var foundationRadius
        private let bypass: Bool
        public init(_ bypass: Bool = false) {
            self.bypass = bypass
        }
        public func body(content: Content) -> some View {
            if bypass {
                content
            } else {
                content
                    .clipShape(FoundationUI.getRoundedShape(foundationRadius))
            }
        }
    }
    // MARK: - TODO
    // Stroke
    // - outside nestedRadius
    // - inside overlay + stroke
    // - center mixed
    // Font
    // - size
    // - other settings
    // Shadow
    // Animation
}

extension FoundationUI {
    public func updateColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    public struct ColorSchemeObserver: ViewModifier {
        @Environment(\.colorScheme) private var colorScheme
        public init() {}
//        @ObservedObject var ui = FoundationUI.shared
        public func body(content: Content) -> some View {
            content
                .onAppear {
                    FoundationUI.shared.updateColorScheme(colorScheme)
                }
                .onChange(of: colorScheme, perform: { colorScheme in
                    print(colorScheme)
                    FoundationUI.shared.updateColorScheme(colorScheme)
                })
        }
    }
}

// TODO: Preview Layout Template (look for inspiration on Figma and Sketch design system templates)


// MARK: View.foundation() extension
public enum FoundationParam {
    /// Padding
    case padding(_ value: FoundationUI.Config.Spacing = .base, _ edges: Edge.Set = .all)
    static public var padding: FoundationParam {
        .padding()
    }
    case radius(_ radius: FoundationUI.Config.Radius = .base, clipContent: Bool = true)
    case nestedRadius
    case background(_ color: FoundationUI.Config.Color = .primary.background, rounded: FoundationUI.Config.Radius = .none)
    case foreground(_ color: FoundationUI.Config.Color = .primary.foreground)
    case clipContent
    
    
    static public var bg: FoundationParam {
        .background()
    }
    static public func bg(_ value: CGFloat) -> FoundationParam {
        .background()
    }
}

public struct FoundationModifier<V: View> {
    private let view: V
    public init(_ view: V) {
        self.view = view
    }
    @ViewBuilder
    public func padding(_ value: FoundationUI.Config.Spacing = .base) -> some View {
        view.modifier(FoundationUI.Padding(value, edges: .all))
    }
    @ViewBuilder
    public var padding: some View {
        padding()
    }
}

extension View {
    @ViewBuilder
    public func foundation(_ param: FoundationParam?) -> some View {
        switch param {
        case .padding(let padding, let edges):
            self.modifier(FoundationUI.Padding(padding, edges: edges))
        case .nestedRadius:
            self.modifier(FoundationUI.ClipContent())
                .modifier(FoundationUI.NestedRadius())
        case .radius(let radius, let clipContent):
            self.modifier(FoundationUI.ClipContent(!clipContent))
                .modifier(FoundationUI.Radius(radius))
        case .background(let color, let rounded):
            self.modifier(FoundationUI.Background(color, rounded: rounded))
        case .foreground(let color):
            self.modifier(FoundationUI.ForegroundColor(color))
        case .clipContent:
            self.modifier(FoundationUI.ClipContent())
        case .none:
            self
        }
    }
}

// MARK: - Environment Values
private struct FoundationRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

private struct FoundationPaddingKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    public var foundationRadius: CGFloat {
        get { self[FoundationRadiusKey.self] }
        set { self[FoundationRadiusKey.self] = newValue }
    }
    public var foundationPadding: CGFloat {
        get { self[FoundationPaddingKey.self] }
        set { self[FoundationPaddingKey.self] = newValue }
    }
}
