//
//  WindowAccessor.swift
//  Vitro
//

import SwiftUI

/// Invisible bridge that hands the hosting `NSWindow` to SwiftUI.
struct WindowAccessor: NSViewRepresentable {
    let onWindow: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        // The view is not attached to a window yet; wait one run-loop turn.
        DispatchQueue.main.async {
            if let window = view.window {
                onWindow(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
