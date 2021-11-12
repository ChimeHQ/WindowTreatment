[![Github CI](https://github.com/ChimeHQ/WindowTreatment/workflows/CI/badge.svg)](https://github.com/ChimeHQ/WindowTreatment/actions)

# WindowTreatment

WindowTreatment is a small set of classes and extensions to aid in working with `NSWindow` and its associated functions.

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

A simple container view that makes it much easier to correctly position content under the titlebar of a host `NSWindow`. This turns out to be a fairly esoteric thing to do, but can be essential when your `NSWindow` has a transparent titlebar.

```swift
let titlebarAwareView = WindowTitlebarAwareView()

// myView will always be correctly position below the containing window's
// titlebar region, and react accordingly if the titlebar size/state changes

titlebarAwareView.contentView = myView
// ...
```

**WindowTitlebarAwareViewController**

A wrapper controller useful in cases where you need to use `WindowTitlebarAwareView` with a system that only accepts `NSViewControllers`, like `NSSplitViewController`.

**WindowStateObserver**

Wrappers around observation of `NSWindow` states for `key`, `main`, and tabbing. Very useful for UI updates in response to these changes. Particularly for tab state, which is very challenging to observe correctly in all cases.

**WindowStateAwareView**

Super-simple class that uses `WindowStateObserver` and provides a nice base for `NSView` subclasses that need to change their appearance depending on host window main/key state.

**ApplicationWindowState**

A class that tracks changes in the application's windows, simplifying logic that depends on the state of all windows.

## NSWindow Extensions

Sizing conveniences:

```swift
// simple method to size a window to pleasing dimensions relative to its screen

window.makeReasonableSize()
```

Title bar transparency helpers:

```swift
// This method also handles the height adjustments needed when removing transparency
window.titlebarTransparentWithFullSizeContent = true

window.usesFullSizeContentView = true
```

## NSView Extensions

Window state:

```swift
self.windowIsMain
self.windowIsKey
self.windowIsOnActiveSpace
```

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
