import Foundation

struct Tab: Identifiable {
    let id: UUID = UUID()
    var url: URL
    var title: String
}
