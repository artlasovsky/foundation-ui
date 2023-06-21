# FoundationUI

Accelerate the process of designing and developing user interfaces with SwiftUI

> NOTE: Readme is not finished yet...

> The project is in early stage of development and not yet ready for production usage.

## Requirements

TODO: Platforms (macOS, iOS, tvOS?, watchOS?) / Swift versions


## Getting Started

### Add as a dependency
```
https://github.com/artlasovsky/foundation-ui
```

### Import package and use it
#### Color Scheme Observer
TODO: Little intro to explain

Add `.colorSchemeObserver()` once the top level of your app:
```swift
import SwiftUI
import FoundationUI

@main
struct FoundationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .colorSchemeObserver()
        }
    }
}
```
and in each SwiftUI's PreviewProvider:
```swift
struct Previews: PreviewProvider {
    struct Preview: View {
        static var previews: some View {
            VStack {
                ...
            }
        }.colorSchemeObserver()
    }
}
```

When we're ready to use it:
```swift
import SwiftUI
import FoundationUI

struct SampleView: View {
    var body: some View {
        VStack {
            Button(action: {}, label: { Text("Custom Style") })
                .buttonStyle(.plain)
                .foundation(.padding(.base, .horizontal))
                .foundation(.padding(.sm, .vertical))
                .foundation(.foreground)
                .foundation(.background(.accent.background.faded, rounded: .sm))        
        }
    }
}
```
- With `.buttonStyle()` we're resetting the default styling of SwiftUI button
- When we setting the paddings with `.foundation(.padding())`
- After that we're setting the foreground color with `.foundation(.foreground)`
- And at the end we're using `.foundation(.background())` to set background color with rounded corners


### Core Concepts

#### Built-in design system
The core FoundationUI idea is to have a customizable built-in design system. 
Which will allow to select a predefined value with a token, and if it will be required change it later in one place.

#### Modifiers
Modifiers available as a ViewModifiers (`FoundationUI.*`) or by using `*.foundation(_)` method on any SwiftUI View.
    TODO: How to use modifiers

#### Available tokens
There are three tokens available right now:

- `FoundationUIRadius`

    Which holds values in `.none`, `.xs`, `.sm`, `.base`, `.lg`, `.xl`
    
- `FoundationUISpacing`

    Which holds values in `.none`, `.xs`, `.sm`, `.base`, `.lg`, `.xl`
    
- `FoundationUIColor`

    Which holds values in `.primary`, `.accent`
    
All token values can be overriden or extended.


### Override or extend token values

    TODO: Show how to override and extend tokens

Add a new color to the theme by extending `FoundationUIColor`:
```swift
import FoundationUI

public extension Theme.Color {
    static var customColor: FoundationUI.Config.Color { .init(hue: 0.5, saturation: 1, brightness: 0.5) }
}
```

To override the default theme color just declare the new computed property with the same color name in `FoundationUIColor` extension:
```swift
import FoundationUI
public extension Theme.Color {
    static var accent: FoundationUI.Config.Color { .init(hue: 0.32, saturation: 0.5, brightness: 1) }
}
``` 
