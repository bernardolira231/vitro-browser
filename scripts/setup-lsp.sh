#!/usr/bin/env bash
# Generate the files sourcekit-lsp needs to understand the Xcode project
# (buildServer.json and .compile). Both are machine-specific and gitignored.
#
# Run it once after cloning, and again after adding or removing Swift files.
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v xcode-build-server >/dev/null 2>&1; then
  echo "error: xcode-build-server not found. Install it with: brew install xcode-build-server" >&2
  exit 1
fi

xcode-build-server config -project Vitro.xcodeproj -scheme Vitro

# build-for-testing also compiles the test targets, so the LSP resolves
# `import Testing` and `@testable import Vitro` in VitroTests.
xcodebuild -scheme Vitro -configuration Debug clean build-for-testing \
  | xcode-build-server parse -a >/dev/null

echo "LSP setup done. Restart your language server (e.g. :LspRestart in Neovim)."
