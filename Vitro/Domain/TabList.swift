import Foundation

struct TabList {
    var tabs: [Tab] = []
    var activeTabID: UUID?

    mutating func openTab(url: URL) {
        let newTab = Tab(url: url, title: "Loading...")
        tabs.append(newTab)
        activeTabID = newTab.id
    }

    mutating func closeTab(id: UUID) {
        tabs.removeAll(where: { tab in tab.id == id })
        if activeTabID == id {
            activeTabID = tabs.first?.id
        }
    }
}
