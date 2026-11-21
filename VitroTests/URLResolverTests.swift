import Foundation
import Testing
@testable import Vitro

struct URLResolverTests {
    @Test func addsHTTPSWhenSchemeIsMissing() {
        let url = URLResolver.resolve("apple.com")

        #expect(url == URL(string: "https://apple.com"))
    }

    @Test func keepsExistingScheme() {
        let url = URLResolver.resolve("https://github.com")

        #expect(url == URL(string: "https://github.com"))
    }

    @Test func keepsHTTPScheme() {
        let url = URLResolver.resolve("http://localhost:3000")

        #expect(url == URL(string: "http://localhost:3000"))
    }
    
    @Test func usesHTTPForLocalhost() {
        let url = URLResolver.resolve("localhost:3000")

        #expect(url == URL(string: "http://localhost:3000"))
    }
    
    @Test func addsHTTPSToDomainStartingWithHTTP() {
        let url = URLResolver.resolve("httpbin.org")

        #expect(url == URL(string: "https://httpbin.org"))
    }
}
