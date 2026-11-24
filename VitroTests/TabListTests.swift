import Foundation
import Testing

@testable import Vitro

struct TabListTests {
    @Test func openTabAddsItAndMakesItActive() throws {
        var tabList = TabList()
        let url = URL(string: "https://apple.com")!

        tabList.openTab(url: url)

        let tab = try #require(tabList.tabs.first)
        #expect(tabList.tabs.count == 1)
        #expect(tab.id == tabList.activeTabID)
    }

    @Test func closeTabRemovesIt() throws {
        var tabList = TabList()
        let url = URL(string: "https://apple.com")!

        tabList.openTab(url: url)

        let tab = try #require(tabList.tabs.first)

        tabList.closeTab(id: tab.id)

        #expect(tabList.tabs.isEmpty)
    }

    @Test func closingLastTabLeavesNoActiveTab() throws {
        var tabList = TabList()
        let url = URL(string: "https://apple.com")!

        tabList.openTab(url: url)

        let tab = try #require(tabList.tabs.first)

        tabList.closeTab(id: tab.id)

        #expect(tabList.tabs.isEmpty)
        #expect(tabList.activeTabID == nil)
    }

    @Test func closingActiveTabActivatesNeighbor() throws {
        var tabList = TabList()
        let urlA = URL(string: "https://apple.com")!
        let urlB = URL(string: "https://github.com")!

        tabList.openTab(url: urlA)
        tabList.openTab(url: urlB)

        let tabA = try #require(tabList.tabs.first)
        let tabB = try #require(tabList.tabs.last)

        tabList.closeTab(id: tabB.id)

        #expect(tabList.activeTabID == tabA.id)
    }
}
