# FoundationUI

Scalable Design System Framework for Apple Developers

> The project is in early stage of development and not yet ready for production usage.
>
> NOTE: This readme is in progress...

## Compatibility

macOS 12+, iOS 15+

> Support for visionOS, tvOS, watchOS will be added soon

## Roadmap

### Documentation

- [ ] Readme
- [ ] DocC documentation
- [ ] Demo Projects for each supported platform
- [ ] Changelog

### Compatibility

- [x] macOS
- [x] iOS
- [ ] watchOS
- [ ] visionOS
- [ ] tvOS

## Getting Started

### Add as a dependency

```
https://github.com/artlasovsky/foundation-ui
```

### Import and you're ready to start

```swift
import FoundationUI
```

### Tokens

FoundationUI has predefined token scales for `Color`, `ShapeStyle`, `CGFloat`, `Font`, `Animation`.

Default token scale contains 7 sizes: `xxSmall`, `xSmall`, `small`, `regular`, `large`, `xLarge`, `xxLarge`

`CGFloat` value tokens are available in 4 scales: `Padding`, `Spacing`, `Radius`, `Size`

Let's try to build a simple button using FoundationUI:

```swift
import FoundationUI

struct FoundationUIButton: View {
    var body: some View {
        Text("Hello FoundationUI!")
            .padding(.vertical, FoundationUI.Variable.Theme.padding(.regular))
            .padding(.horizontal, .foundation.padding(.large))
            .background(
              // `Color` Token
              .foundation.primary.fill,
              // Radius: 8
              in: .rect(cornerRadius: .foundation.radius(.regular))
            )
    }
}
```

After importing `FoundationUI` we can access tokens via `FoundationUI.Variable.Theme` struct:

```swift
View.padding(.vertical, FoundationUI.Variable.Theme.padding(.regular)) // 8
```

or with a shortcut using a dot notation:

```swift
View.padding(.horizontal, .foundation.padding(.large)) // 16
```

Set `.fill` token as a background color together with `.foundation.radius` token

```swift
View.background(
    .foundation.primary.fill, // UI element background color token
    in: .rect(cornerRadius: .foundation.radius(.regular)) // 8
)
```

## Extension and Override

[WIP]

## Color

[WIP]
