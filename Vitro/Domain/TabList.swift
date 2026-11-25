import Foundation

struct TabList {
    var tabs: [Tab] = []
    var activeTabID: UUID?
    var activeTab: Tab? { tabs.first(where: { tab in tab.id == activeTabID }) }

    mutating func openTab(url: URL) {
        let newTab = Tab(url: url, title: "Loading...")
        tabs.append(newTab)
        activeTabID = newTab.id
    }

    mutating func closeTab(id: UUID) {
        guard let tabIndex = tabs.firstIndex(where: { $0.id == id }) else { return }
        tabs.removeAll(where: { tab in tab.id == id })
        if activeTabID == id {
            if tabs.isEmpty {
                activeTabID = nil
            } else if tabIndex < tabs.count {
                activeTabID = tabs[tabIndex].id
            } else {
                activeTabID = tabs[tabIndex - 1].id
            }
        }
    }

    mutating func activateTab(id: UUID) {
        guard tabs.contains(where: { $0.id == id }) else { return }
        activeTabID = id
    }

    mutating func navigateActiveTab(to url: URL) {
        guard let tabIndex = tabs.firstIndex(where: { $0.id == activeTabID }) else { return }

        tabs[tabIndex].url = url
    }
}
