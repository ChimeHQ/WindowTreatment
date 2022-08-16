[![Build Status][build status badge]][build status]
[![License][license badge]][license]
[![Platforms][platforms badge]][platforms]

# WindowTreatment

WindowTreatment is a small set of classes and extensions to aid in working with `NSWindow` and its associated functions.

## Integration

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/WindowTreatment")
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

## SwiftUI View Modifiers

```swift
windowStateEnvironment() // makes WindowStateKey available in the environment
```

### Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[build status]: https://github.com/ChimeHQ/WindowTreatment/actions
[build status badge]: https://github.com/ChimeHQ/WindowTreatment/workflows/CI/badge.svg
[license]: https://opensource.org/licenses/BSD-3-Clause
[license badge]: https://img.shields.io/github/license/ChimeHQ/WindowTreatment
[platforms]: https://swiftpackageindex.com/ChimeHQ/WindowTreatment
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FWindowTreatment%2Fbadge%3Ftype%3Dplatforms
