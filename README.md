# FoundationUI


Accelerate the process of designing and developing user interfaces with SwiftUI.

# Compatibility


Compatible with macOS 12+ and iOS 15+

Tested with:


- [ ] macOS 12
- [ ] macOS 13
- [x] macOS 14
- [ ] macOS 15
- [ ] iOS 15
- [ ] iOS 16
- [ ] iOS 17
- [ ] iOS 18


> Support for visionOS, tvOS and watchOS coming later this year


# Getting Started


Add package as a dependendy

```other
https://github.com/artlasovsky/foundation-ui
```


Import `FoundationUI` package, and you’re all set!

```swift
import FoundationUI

struct Sample: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .foundation(.spacing(.xxSmall))) {
                Text("Title")
                    .foundation(.foreground(.dynamic(.text)))
                Text("Subtitle")
                    .foundation(.foreground(.dynamic(.textSubtle)))
                    .foundation(.font(.small))
            }
            Spacer()
            Circle()
                .foundation(.size(.small))
                .foundation(.foreground(.dynamic(.solidProminent)))
        }
        .foundation(.padding(.regular))
        .foundation(.size(width: .large, alignment: .leading))
        .foundation(.background(.primary.variant(.background)))
        .foundation(.shadow(.regular))
        .foundation(.border(.primary.variant(.border)))
        .foundation(.cornerRadius(.regular))
        .foundation(.tintColor(.accentColor))
    }
}

#Preview {
    Sample()
}
```


# Discoverability


## SwiftUI Modifiers


All available view modifiers can be accessed using the `.foundation()` view modifier. This approach helps you easily distinguish when you're working with FoundationUI and when you're not.

If you prefer a different name for the modifier, such as `.theme()`, you can easily achieve this by extending the View protocol and wrapping the `.foundation()` modifier:

```swift
extension View {
    func theme<M: ViewModifier>(_ modifier: FoundationModifier<M>) -> some View {
        foundation(modifier)
    }
}
```


You can conditionally bypass a modifier by utilizing the additional `bypass` property of the `.foundation()` modifier: 

```swift
Text("Bypass")
  .foundation(.padding(), bypass: true)
```


> ### [TODO: How modifiers work]


> - Example with `.background()`
> - Nested radii (background + border + padding + background + cornerRadius)

## Theme


All theme variables are explorable in `Theme.default`:

```swift
// Theme.default.variableName(tokenName)
let smallPadding = Theme.default.padding(.small)
```


For variables that result in native SwiftUI value types, there's a way to access them with a `.foundation()` shortcut:

```swift
// Set spacing for HStack (CGFloat)
HStack(spacing: .foundation(.spacing(.small))) {
  Text("Theme")
    // or use it in SwiftUI's `.foregroundStyle` view modifier (ShapeStyle)
    .foregroundStyle(.foundation(.dynamic(.solid)))
    // or use it when you need a SwiftUI.Color (Color)
    .shadow(color: .foundation(.primary, in: .light), radius: 2)
    // same with the `.font` modifier (Font)
    .font(.foundation(.large))
}
```

> Currently variables available for these types and protocols: `CGFloat`, `Color`, `ShapeStyle`, `Font`


# Variables


## Value Variable


`FoundationVariable` protocol

FoundationUI provides several predefined variables for:


- Theme.Padding → CGFloat
- Theme.Size → CGFloat
- Theme.Radius → CGFloat
- Theme.Spacing → CGFloat
- Theme.Font → SwiftUI.Font
- Theme.Shadow → FoundationUI.Theme.Shadow.Configuration

All these variables comes with in predefined sizes:

`xxSmall, xSmall, small, regular, large, xLarge, xxLarge`

Here is default values for variables:

|         | Padding | Spacing | Radius | Size |
| ------- | ------- | ------- | ------ | ---- |
| xxSmall | 1       | 1       | 2      | 8    |
| xSmall  | 2       | 2       | 4      | 16   |
| small   | 4       | 4       | 5      | 32   |
| regular | 8       | 8       | 8      | 64   |
| large   | 16      | 16      | 12     | 128  |
| xLarge  | 32      | 32      | 18     | 256  |
| xxLarge | 64      | 64      | 27     | 512  |

> ### [TODO: FoundationAdjustableVariable (CGFloat) & FoundationVariableStep]



### Extending variable tokens


To add new token to the variable, just extend it's struct:

```swift
extension Theme.Size {
  // create new token using `.value` method
  static let windowWidth = Self.value(275)
}
extension Theme.Radius {
  // create new token based on already existing
  static let buttonRadius = Self.small
}

extension Theme.Padding {
  // you could also declare a token as a method
  static func verticalPadding(isOpened: Bool) -> Self {
    isOpened ? .large : .regular
  }
}
```


### Overriding variable tokens


Overriding existing tokens works the same way as extending, just use the name of existing tokens:

```swift
extension Theme.Padding {
  static let regular = Self.value(10) // default value was 8
}
```

> You can control the scope of the variables by using [Access Control syntax](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/#Access-Control-Syntax) like `public`, `private`, `fileprivate`.


## Color Variable


`FoundationColorVariable` protocol


- Theme.Color → FoundationUI.DynamicColor

### DynamicColor

> - [ ] Modify color
> - [ ] Variants (Scale)
>     - [ ] Semantic meaning
>     - [ ] Adding colors for using with scale
> - [ ] Resolving color
>     - [ ] ShapeStyle conformance
>     - [ ] resolveColor

FoundationUI employs its own color system, DynamicColor, offering full compatibility with SwiftUI.Color, as well as NS/UIColor. It lets you specify color components for up to four color schemes: `light`, `dark`, `lightAccessible`, and `darkAccessible`. Additionally, you can declare universal color components that function across all schemes.

Here's an few examples:

```swift
extension Theme.Color {
    // All the ColorComponents are representing `SwiftUI.Color.red` from Apple's HIG.
    // So the `brandColor` will match the native `.red` color for each colorScheme.
    static let brandColor = Self(
        light: ColorComponents(red: 1, green: 0.23, blue: 0.19),
        dark: ColorComponents(red8bit: 255, green: 69, blue: 58),
        lightAccessible: ColorComponents(hex: "#d70015"),
        darkAccessible: ColorComponents(color: .red, colorScheme: .darkAccessible)
    )
    static let lightGray = Self(ColorComponents(grayscale: 0.7))
    // Extract values from system's accent color:
    static let accentColor = Self.from(color: .accentColor) 

    // Using different colors for light and dark modes:
    static let mix = Self(
        light: .init(nsColor: .red, colorScheme: .light),
        dark: .init(color: .orange, colorScheme: .dark),
        lightAccessible: nil, // will inherit `light` ColorComponents
        darkAccessible: nil // will inherit `dark` ColorComponents
    )
}
```


There are few predefined colors:


- `primary` (could be overriden)
- `clear`
- `black`
- `white`
- `gray`

### Color Scale (Variants)


It comes with semantic named tokens such as:

`background, border, fill, solid, text` with `*Subtle` and `*Prominent` variations.

All variable tokens could be overriden or extended.

### Usage

> - [ ] via `.foundation()` modifiers
> - [ ] via `Theme.Color`
>     - [ ] in SwiftUI
>     - [ ] outside SwiftUI
> - [ ] in SwiftUI views context
>     `.dynamic()` & `.foundation(.tint())`


### Modify Color


...

### Extending/Overriding DynamicColor

- [ ] Extensions and overrides (color, variation)

# SwiftUI extensions


## Dynamic Gradient


...

## Shapes


DynamicRoundedRectangle

### Link to demo repo


# Roadmap


...
