import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    @Binding var url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.urlObservation = webView.observe(\.url) { webView, _ in
            if let newURL = webView.url { url = newURL }
        }
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        context.coordinator.parent = self
        if nsView.url != url {
            nsView.load(URLRequest(url: url))
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var urlObservation: NSKeyValueObservation?

        init(parent: WebView) {
            self.parent = parent
        }
    }
}
