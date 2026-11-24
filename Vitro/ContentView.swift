//
//  ContentView.swift
//  Vitro
//
//  Created by Bernardo Lira on 19/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var urlText = ""
    @State private var currentURL = URL(string: "https://www.apple.com")!
    @State private var isSidebarVisible = false
    @State private var window: NSWindow?

    var body: some View {
        ZStack(alignment: .leading) {
            WebView(url: $currentURL)

            Color.clear
                .frame(width: 8)
                .frame(maxHeight: .infinity)
                .contentShape(Rectangle())
                .onHover { hovering in
                    if hovering {
                        isSidebarVisible = true
                    }
                }

            if isSidebarVisible {
                VStack {
                    Color.clear
                        .frame(height: 28)
                        .contentShape(Rectangle())
                        .gesture(WindowDragGesture())
                    TextField("Search or enter URL", text: $urlText)
                        .onSubmit {
                            if let url = URLResolver.resolve(urlText) {
                                currentURL = url
                            }
                        }
                    Spacer()
                }
                .padding()
                .frame(width: 260)
                .glassEffect(in: .rect(cornerRadius: 16))
                .onHover { hovering in
                    if !hovering {
                        isSidebarVisible = false
                    }
                }
                .transition(.move(edge: .leading))
            }
        }
        .ignoresSafeArea()
        .background(
            WindowAccessor { window in
                self.window = window
                setTrafficLightsHidden(!isSidebarVisible)
            }
        )
        .animation(.easeInOut(duration: 0.2), value: isSidebarVisible)
        .onChange(of: isSidebarVisible) {
            setTrafficLightsHidden(!isSidebarVisible)
        }
        .onChange(of: currentURL) {
            urlText = currentURL.absoluteString
        }
    }

    private func setTrafficLightsHidden(_ hidden: Bool) {
        let types: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
        let buttons = types.compactMap { window?.standardWindowButton($0) }

        // Unhide before fading in, so the fade is visible.
        if !hidden {
            buttons.forEach { $0.isHidden = false }
        }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            buttons.forEach { $0.animator().alphaValue = hidden ? 0 : 1 }
        } completionHandler: {
            // Transparent buttons are still clickable, so hide them for real
            // once faded out, unless the sidebar came back in the meantime.
            if hidden && !isSidebarVisible {
                buttons.forEach { $0.isHidden = true }
            }
        }
    }
}

#Preview {
    ContentView()
}
