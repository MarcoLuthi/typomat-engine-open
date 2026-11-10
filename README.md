# TypomatEngine for Apple platforms

Makes fonts from a recipe, on the device. iOS 17, macOS 14 and Mac Catalyst 17 or later. It's a binary Swift package with no network use and no dependencies.

## Install

In Xcode, add the package at `https://github.com/MarcoLuthi/typomat-engine-open`, or in `Package.swift`:

```swift
.package(url: "https://github.com/MarcoLuthi/typomat-engine-open", from: "1.8.5")
```

It needs no account or token. Your licence key, in your code, decides what the engine does.

A licence that has ended goes on covering the versions that came out while it ran. `Package.resolved` pins one for good, so those builds go on working.

## Use

```swift
import SwiftUI
import TypomatEngine

let engine = TypomatEngine(licenseKey: "TM2...")

var recipe = Recipe(name: "Acme Sans", parameters: ["weight": 118, "contrast": 0.3])
recipe.metadata.designer = "Acme"

// Compiling happens off the main thread.
let data = try await engine.compile(recipe)
try data.write(to: fileURL)

// Or use it in this app straight away.
let font = try await TypomatEngine.registerFont(data)
Text("Hello").font(.custom(font.postScriptName, size: 32))
```

A recipe is `Codable`. Store it instead of the font: it's about a kilobyte and compiles to the same bytes every time.

```swift
let stored = try JSONEncoder().encode(recipe)
let again = try JSONDecoder().decode(Recipe.self, from: stored)
```

## Smaller fonts and other formats

```swift
try await engine.compile(recipe, format: .woff2)
try await engine.compile(recipe, characters: "0123456789")
try await engine.compile(recipe, characters: .sets("lowercase", "digits"))
try await engine.compile(recipe, characters: .ranges(0x41...0x5A))
try engine.coverage("Hello!", recipe: recipe)          // what a font would hold
```

## Drawing without compiling

```swift
let path = try engine.outline("a", recipe: recipe).path    // a CGPath, y up
let run = try engine.glyphs("Hello", recipe: recipe)       // a CGPath per glyph, y down, with advances and kerning
```

These are synchronous and safe on any thread. A dial can call them on every change.

## What else it has

`engine.catalog()` lists every parameter with its range, and every character. `engine.presets()` gives the named styles, each with a `.recipe`. `engine.metrics(recipe)` and `engine.family(recipe)` do what they say. Everything that can fail throws a `TypomatError`, with a `code` to branch on and a `message` for your logs.

## Without a licence

`TypomatEngine()` works in evaluation mode, under the evaluation terms in the [Engine License](https://engine.typomat.app/license#evaluation). It draws and compiles A to Z and a to z only: any other character comes back with `isMissing` and `isWithheld` set, and compiled fonts say what they are in their names and terms. `engine.license` tells you which mode you're in and why. The licence key is checked offline, and nothing leaves the device.

Most plans work only in the apps your key names. Add your app's bundle ID in [your account](https://engine.typomat.app/account), and copy the new key it gives you. In any other app, `engine.license.reason` is `.app`, and the engine runs in evaluation mode.

## Things to know

- It's a dynamic framework, which an app embeds by itself. A command-line tool has nowhere to embed it, so ship the framework beside the tool and link with `-rpath @loader_path`.
- `registerFont` lasts until the app quits or you call `unregister()`.
- Registering a font under a name you've already registered replaces it. A SwiftUI view may keep showing the earlier one until it asks for the font again, so give each look its own recipe `name` if a view must change at once.
- If your app has its own type called `Recipe`, reach this one as `TypomatEngine::Recipe`. That takes Swift 6.3 or later.
