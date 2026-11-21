# Vitro

A light, fast and customizable web browser for macOS, built with SwiftUI and WebKit.

> **Status:** work in progress — v0.1 under active development.

## Goals

- **Content first** — hidden title bar, full-bleed web content.
- **Vertical tabs** — a glass sidebar that appears on hover, with the URL field and tabs.
- **Workspaces** — group tabs by context and switch between them instantly.
- **Persistence** — tabs and workspaces restored on launch.
- **Keyboard driven** — `⌘T` new tab, `⌘W` close tab, `⌘L` focus URL.

## Roadmap (v0.1)

- [ ] M1 — Window, web view and URL navigation
- [ ] M2 — Hover-revealed glass sidebar
- [ ] M3 — Vertical tabs
- [ ] M4 — Workspaces and persistence
- [ ] M5 — Keyboard shortcuts and polish

## Tech stack

- Swift + SwiftUI (Liquid Glass)
- WebKit (`WKWebView`)
- Swift Testing
- Pragmatic hexagonal architecture: domain and application logic stay independent of WebKit and storage adapters.

## Requirements

- macOS 27 or later
- Xcode 27 or later

## Build

```sh
git clone git@github.com:bernardolira231/vitro-browser.git
cd vitro-browser
open Vitro.xcodeproj
```

Or from the command line:

```sh
xcodebuild -scheme Vitro -configuration Debug build
```

## Development

Run the tests:

```sh
xcodebuild test -scheme Vitro -only-testing:VitroTests
```

### Editors other than Xcode

Any editor that uses [sourcekit-lsp](https://github.com/swiftlang/sourcekit-lsp) (Neovim, VS Code, Zed, Helix…) needs build settings from the Xcode project. Generate them with:

```sh
brew install xcode-build-server
./scripts/setup-lsp.sh
```

Run the script again after adding or removing Swift files, then restart the language server.

## License

[MIT](LICENSE)
