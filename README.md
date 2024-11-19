<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Matrix][matrix badge]][matrix]

</div>

# WindowTreatment

WindowTreatment is a small set of classes and extensions to aid in working with `NSWindow` and its associated functions.

## Integration

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/WindowTreatment")
]
```

## SwiftUI View Modifiers

```swift
observeCurrentWindow() // puts the current window object into the environment
observeWindowState()   // makes WindowStateKey available in the environment
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

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. Both a [Matrix space][matrix] and [Discord][discord] are available for live help, but I have a strong bias towards answering in the form of documentation. You can also find me [here](https://www.massicotte.org/about).

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/WindowTreatment/actions
[build status badge]: https://github.com/ChimeHQ/WindowTreatment/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/WindowTreatment
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FWindowTreatment%2Fbadge%3Ftype%3Dplatforms
[matrix]: https://matrix.to/#/%23chimehq%3Amatrix.org
[matrix badge]: https://img.shields.io/matrix/chimehq%3Amatrix.org?label=Matrix
[discord]: https://discord.gg/esFpX6sErJ
