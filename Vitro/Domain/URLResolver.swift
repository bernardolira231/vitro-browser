import Foundation

enum URLResolver {
    static func resolve(_ input: String) -> URL? {
        if input.contains("://") {
            return URL(string: input)
        }
        if input.hasPrefix("localhost") {
            return URL(string: "http://" + input)
        }
        return URL(string: "https://" + input)
    }
}
