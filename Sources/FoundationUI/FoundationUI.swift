import SwiftUI

public class FoundationUIConfig {
    public static let shared = FoundationUIConfig()
    private init() {}
    
    public private (set) var tint: Variant<TintVariant, Color> = ([
        .primary: Color.init(nsColor: .labelColor),
        .secondary: Color.init(nsColor: .secondaryLabelColor),
        .tertiary: Color.init(nsColor: .tertiaryLabelColor),
        .quaternary: Color.init(nsColor: .quaternaryLabelColor),
        .accent: .accentColor,
        .destructive: .red,
        .warning: .yellow
    ])
    public private (set) var space: ValueWithVariant<SizeVariant, CGFloat> = (8, [.small: 4, .medium: 12, .large: 18])
    public private (set) var radius: ValueWithVariant<RadiusVariant, CGFloat> = (8, [.small: 4, .medium: 12, .large: 18, .full: 999])
}

public struct Background: ViewModifier {
    @Environment(\.foundationRadius) var foundationRadius
//    @Environment(\.backgroundTint) private var _backgroundTint
    @Environment(\.colorScheme) var colorScheme
    // TODO: Change env values to Color type
    private var tint: Color? {
        getTint(backgroundTint)
    }
    private let backgroundTint: TintVariant?
    private var rectangle: RoundedRectangle {
        getRoundedRectangle(foundationRadius)
    }
    public init(tint: TintVariant? = nil) {
        self.backgroundTint = tint
    }
    public init(color: Color? = nil) {
        if let color {
            self.backgroundTint = .custom(color)
        } else {
            self.backgroundTint = nil
        }
    }
    public func body(content: Content) -> some View {
        if let tint {
            content
                .background(tint.opacity(0.2).blendMode(getBlendMode(colorScheme)), in: rectangle)
        } else {
            content
                .background(in: rectangle)
//                .backgroundStyle(.background)
        }
    }
}



public struct Stroke: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.foundationRadius) private var foundationRadius
//    @Environment(\.strokeTint) private var strokeTint
    
    private let lineWidth: CGFloat
    private let strokeTint: TintVariant?
    private var tint: Color? {
        getTint(strokeTint)
    }
    public init(tint: TintVariant? = nil, width: CGFloat = 1) {
        self.lineWidth = width
        self.strokeTint = tint
    }
    private var rectangle: some Shape {
        getRoundedRectangle(foundationRadius)
    }
    public func body(content: Content) -> some View {
        content
            .overlay {
//                if let tint {
//                    rectangle.stroke(color, lineWidth: lineWidth)
//                }
                if let tint {
                    rectangle
                        .stroke(tint, lineWidth: lineWidth)
                        .opacity(0.8)
                        .blendMode(getBlendMode(colorScheme))
                }
            }
    }
}

public struct FontTint: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.fontTint) private var _fontTint
//    @Environment(\.strokeTint) private var _strokeTint
//    @Environment(\.backgroundTint) private var _backgroundTint
    
    private let fontTint: TintVariant?
    private var tint: Color? {
        getTint(fontTint)
    }
//    private let strokeTintVariant: TintVariant?
//    private var strokeTint: Color? {
//        getTint(strokeTintVariant)
//    }
//    private let backgroundTintVariant: TintVariant?
//    private var backgroundTint: Color? {
//        getTint(backgroundTintVariant)
//    }
//    public enum ApplyTo {
//        case all
//        case font
//        case background
//        case stroke
//    }

    public init(_ tint: TintVariant = .primary) {
        self.fontTint = tint
//        if applyTo.contains([.all]) {
//            self.fontTintVariant = tint
//            self.backgroundTintVariant = tint
//            self.strokeTintVariant = tint
//        } else {
//            self.fontTintVariant = applyTo.contains([.font]) ? tint : nil
//            self.backgroundTintVariant = applyTo.contains([.background]) ? tint : nil
//            self.strokeTintVariant = applyTo.contains([.stroke]) ? tint : nil
//        }
    }
    public func body(content: Content) -> some View {
        if let tint {
            content
            .tint(tint)
            .foregroundColor(tint)
            .foregroundStyle(.tint.blendMode(getBlendMode(colorScheme)))
        } else {
            content
        }
//                .environment(\.fontTint, fontTint ?? _fontTint)
//                .environment(\.strokeTint, strokeTint ?? _strokeTint)
//                .environment(\.backgroundTint, backgroundTint ?? _backgroundTint)
    }
}

extension View {
    public func rounded(_ radius: RadiusVariant? = nil) -> some View {
        self.modifier(Rounded(radius))
    }
}

public struct Rounded: ViewModifier {
    private let radius: RadiusVariant?
    public init(_ radius: RadiusVariant? = nil) {
        self.radius = radius
    }
    private var radiusValue: CGFloat {
        getVariantValue(FoundationUIConfig.shared.radius, key: radius)
    }
    public func body(content: Content) -> some View {
        content
            .environment(\.foundationRadius, radiusValue)
    }
}
public struct Padding: ViewModifier {
    public enum Style {
        case wide
        case narrow
    }
    private let size: SizeVariant?
    private let edge: Edge.Set
    private let style: Style?
    private var padding: CGFloat {
        return getVariantValue(FoundationUIConfig.shared.space, key: size)
    }
    private var verticalPadding: CGFloat {
        guard [Edge.Set.all, .vertical, .top, .bottom].contains(edge) else { return 0 }
        return padding
    }
    private var horizontalPadding: CGFloat {
        guard [Edge.Set.all, .horizontal, .leading, .trailing].contains(edge) else { return 0 }
        switch style {
        case .wide:
            return padding * 1.4
        case .narrow:
            return padding * 0.6
        default:
            return padding
        }
    }
    private var verticalEdge: Edge.Set {
        guard [.vertical, .top, .bottom].contains(edge) else { return .vertical }
        return edge
    }
    private var horizontalEdge: Edge.Set {
        guard [.horizontal, .leading, .trailing].contains(edge) else { return .horizontal }
        return edge
    }
    public init(_ size: SizeVariant? = nil, edge: Edge.Set = .all, style: Style? = nil) {
        self.size = size
        self.edge = edge
        self.style = style
    }
    public func body(content: Content) -> some View {
        content
            .padding(verticalEdge, verticalPadding)
            .padding(horizontalEdge, horizontalPadding)
    }
}

public struct HoverEffect<V: ViewModifier>: ViewModifier {
    @State private var isHovered: Bool = false
    private func onHover(state: Bool) {
        withAnimation (.interactiveSpring()) {
            isHovered = state
        }
    }
    private var hoverContent: (_ hovered: Bool) -> V
    public init(_ content: @escaping (_ hovered: Bool) -> V) {
        self.hoverContent = content
    }
    public func body(content: Content) -> some View {
        content
            .modifier(hoverContent(isHovered))
            .onHover(perform: onHover)
    }
}


public struct FoundationUIPreview: View {
    public init() {}
    public var body: some View {
        VStack {
            Text("Foundation UI")
                .modifier(Padding(style: .wide))
                .modifier(HoverEffect({ isHovered in
                    FontTint(isHovered ? .primary : .secondary)
                        .concat(Background(tint: isHovered ? .tertiary : .quaternary))
                        .concat(Stroke(tint: isHovered ? .accent : nil))
                }))
                .modifier(Rounded(.medium))
        }
        .frame(width: 300, height: 300)
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        FoundationUIPreview()
    }
}
