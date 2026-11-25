import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    @Binding var url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let coordinator = context.coordinator
        webView.navigationDelegate = coordinator
        coordinator.urlObservation = webView.observe(\.url) { webView, _ in
            if let newURL = webView.url { coordinator.parent.url = newURL }
        }
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        let coordinator = context.coordinator
        coordinator.parent = self
        // React only when SwiftUI hands us a different URL than last time.
        // Comparing against the web view's own URL instead causes reloads, because
        // it normalizes and redirects ("youtube.com" -> "https://www.youtube.com/").
        guard url != coordinator.lastRequestedURL else { return }
        coordinator.lastRequestedURL = url
        // The web view's own navigation flows back here too; don't reload it.
        if nsView.url != url {
            nsView.load(URLRequest(url: url))
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var lastRequestedURL: URL?
        var urlObservation: NSKeyValueObservation?

        init(parent: WebView) {
            self.parent = parent
        }
    }
}
