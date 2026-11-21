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

    var body: some View {
        VStack(spacing: 0) {
            TextField("Search or enter URL", text: $urlText)
            .onSubmit {
                if let url = URLResolver.resolve(urlText){
                    currentURL = url
                    urlText = url.absoluteString
                }
            }
            WebView(url: currentURL)
        }
    }
}

#Preview {
    ContentView()
}
