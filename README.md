[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
![](https://img.shields.io/badge/Swift-5.0-orange.svg)

# WindowTreatment

WindowTreatment is a small set of classes and extensions to aid in working with NSWindow and its associated functions.

## Integration

Carthage:

You can use [Carthage](https://github.com/Carthage/Carthage) to intall this as a static library. However, because the library relies on Objective-C categories to extend AppKit classes, you *must* include "-ObjC" in your OTHER_LDFLAGS setting.

```
github "ChimeHQ/WindowTreatment"
```

Swift Package Manager:

```swift
dependencies: [
        .package(url: "https://github.com/ChimeHQ/WindowTreatment.git")
]
```

## Classes

**WindowTitlebarAwareView**

A simple container view that makes it much easier to correctly position content under the titlebar of a host NSWindow. This turns out to be a fair esoteric thing to do, but can be essential when your NSWindow has a transparent titlebar.

```swift
let titlebarAwareView = WindowTitlebarAwareView()

// myView will always be correctly position below the containing window's
// titlebar region, and react accordingly if the titlebar size/state changes

titlebarAwareView.contentView = myView
// ...
```

**WindowTitlebarAwareViewController**

A wrapper controller useful in cases where you need to use WindowTitlebarAwareView with a system that only accepts NSViewControllers, like NSSplitViewController.

**WindowStateObserver**

Convenience wrappers around observation of NSWindow states like `key` and `main`. Very useful for UI changes in response to these changes.

**WindowStateAwareView**

Super-simple class that uses `WindowStateObserver` and provides a nice base for NSView subclasses that need to change their appearance depending on host window state.

## NSWindow Extensions

Sizing conveniences:

```swift
// simple method to size a window to pleasing dimensions relative to its screen

window.makeReasonableSize()
```

Title bar transparency helpers:

```swift
window.titlebarTransparentWithFullSizeContent = true

window.usesFullSizeContentView = true
```

## NSView Extensions

Window state:

```swift
self.windowIsMain
self.windowIsKey
```

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
