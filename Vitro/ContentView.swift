//
//  ContentView.swift
//  Vitro
//
//  Created by Bernardo Lira on 19/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var urlText = ""
    @State private var isSidebarVisible = false
    @State private var window: NSWindow?
    @State private var tabList = TabList()

    var body: some View {
        ZStack(alignment: .leading) {
            if let activeTab = tabList.activeTab {
                WebView(
                    url: Binding(
                        get: { activeTab.url },
                        set: { newURL in tabList.navigateActiveTab(to: newURL) }
                    ))
            }

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
                VStack(spacing: 12) {
                    Color.clear
                        .frame(height: 28)
                        .contentShape(Rectangle())
                        .gesture(WindowDragGesture())
                    TextField("Search or enter URL", text: $urlText)
                        .onSubmit {
                            if let url = URLResolver.resolve(urlText) {
                                tabList.navigateActiveTab(to: url)
                            }
                        }
                        .padding(.bottom, 12)
                    Divider()
                        .padding(.bottom, 8)
                    ForEach(tabList.tabs) { tab in
                        HStack {
                            Image(systemName: "globe")
                            Text(tab.title)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            tabList.activateTab(id: tab.id)
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
        .onChange(of: tabList.activeTab?.url) {
            if let activeTab = tabList.activeTab {
                urlText = activeTab.url.absoluteString
            }
        }
        .onAppear { tabList.openTab(url: URL(string: "https://youtube.com")!) }
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
