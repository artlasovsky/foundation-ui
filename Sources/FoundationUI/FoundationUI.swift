//
//  File.swift
//  
//
//  Created by Art Lasovsky on 22/4/2023.
//

import Foundation
import SwiftUI
import AppKit

public class FoundationUI:ObservableObject {
    @Published public var colorScheme: ColorScheme = .dark
    public private (set) var config = FoundationUIConfig()
    public func setConfig(_ config: FoundationUIConfig) {
        self.config = config
    }
    public var accent: Color {
        colorScheme == .dark ? .yellow : .accentColor
    }
    public static var shared = FoundationUI()
    private var appearanceObserver: NSKeyValueObservation?
    private func observeAppearanceChange() {
        appearanceObserver = NSApplication.shared.observe(\.effectiveAppearance, options: [.new, .old, .initial, .prior]) { app, change in
            if let appearanceName = change.newValue?.name {
                if appearanceName == .darkAqua {
                    self.colorScheme = .dark
                }
                if appearanceName == .aqua {
                    self.colorScheme = .light
                }
            }
        }
    }
    private init() {
        observeAppearanceChange()
    }
    deinit {
        appearanceObserver?.invalidate()
    }
    
    
}

extension FoundationUI {
    public struct Padding: ViewModifier {
        private let token: Token<CGFloat>
        private let edges: Edge.Set
        public init(_ token: Token<CGFloat>, edges: Edge.Set) {
            self.token = token
            self.edges = edges
        }
        // Keep view update on change of @Published variables (colorScheme)
        @ObservedObject var ui = FoundationUI.shared
        
        private var padding: CGFloat {
            return FoundationUI.shared.config.padding.get(token)
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
        private let token: Token<CGFloat>?
        public init(_ token: Token<CGFloat>? = .base) {
            self.token = token
        }
        private var radius: CGFloat {
            guard let token else { return 0 }
            return FoundationUI.shared.config.radius.get(token)
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
        private let color: Color
        private let rounded: Token<CGFloat>
        public init(_ color: Color, rounded: Token<CGFloat> = .none) {
            self.color = color
            self.rounded = rounded
        }
        public func body(content: Content) -> some View {
            content
                .background(color.foundation(.radius(rounded)))
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
}

extension FoundationUI {
    public func updateColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    public struct PreviewColorSchemeObserver: ViewModifier {
        @Environment(\.colorScheme) private var colorScheme
        public init() {}
        public func body(content: Content) -> some View {
            content
                .onChange(of: colorScheme, perform: { colorScheme in
                    FoundationUI.shared.updateColorScheme(colorScheme)
                })
        }
    }
}
// TODO: Modifiers:
// - Padding
// - Rounded
// - Offset
// - Text...
// - Background
// - Foreground
// - Stroke
// - Shadow
// - Animation

// TODO: Preview Layout Template (look for inspiration on Figma and Sketch design system templates)


// MARK: View.foundation() extension
public enum FoundationParam {
    case padding(_ token: Token<CGFloat> = .base, _ edges: Edge.Set = .all)
    case radius(_ token: Token<CGFloat> = .base, clipContent: Bool = true)
    case nestedRadius
    case background(_ color: Color, rounded: Token<CGFloat> = .none)
    case clipContent
}

extension View {
    @ViewBuilder
    public func foundation(_ param: FoundationParam?) -> some View {
        switch param {
        case .padding(let token, let edges):
            self.modifier(FoundationUI.Padding(token, edges: edges))
        case .nestedRadius:
            self.modifier(FoundationUI.ClipContent())
                .modifier(FoundationUI.NestedRadius())
        case .radius(let token, let clipContent):
            self.modifier(FoundationUI.ClipContent(!clipContent))
                .modifier(FoundationUI.Radius(token))
        case .background(let color, let rounded):
            self.modifier(FoundationUI.Background(color, rounded: rounded))
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
