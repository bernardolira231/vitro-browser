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

    @Test func closingLastActiveTabActivatesLeftNeighbor() throws {
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

    @Test func activateTabMakesItActive() throws {
        var tabList = TabList()
        let urlA = URL(string: "https://apple.com")!
        let urlB = URL(string: "https://github.com")!

        tabList.openTab(url: urlA)
        tabList.openTab(url: urlB)

        let tabA = try #require(tabList.tabs.first)

        tabList.activateTab(id: tabA.id)

        #expect(tabList.activeTabID == tabA.id)
    }

    @Test func activatingMissingTabKeepsCurrentActive() throws {
        var tabList = TabList()
        let urlA = URL(string: "https://apple.com")!
        let urlB = URL(string: "https://github.com")!
        let urlC = URL(string: "https://youtube.com")!

        tabList.openTab(url: urlA)
        tabList.openTab(url: urlB)
        tabList.openTab(url: urlC)

        let tabA = try #require(tabList.tabs.first)
        let tabC = try #require(tabList.tabs.last)

        tabList.closeTab(id: tabA.id)
        tabList.activateTab(id: tabA.id)

        #expect(tabList.activeTabID == tabC.id)
    }

    @Test func closingActiveTabActivatesRightNeighbor() throws {
        var tabList = TabList()
        let urlA = URL(string: "https://apple.com")!
        let urlB = URL(string: "https://github.com")!
        let urlC = URL(string: "https://youtube.com")!

        tabList.openTab(url: urlA)
        tabList.openTab(url: urlB)
        tabList.openTab(url: urlC)

        let tabB = try #require(tabList.tabs.first(where: { tab in tab.url == urlB }))
        let tabC = try #require(tabList.tabs.last)

        tabList.activateTab(id: tabB.id)
        tabList.closeTab(id: tabB.id)

        #expect(tabList.activeTabID == tabC.id)
    }

    @Test func activeTabReturnsTheActiveOne() throws {
        var tabList = TabList()
        let urlA = URL(string: "https://apple.com")!
        let urlB = URL(string: "https://github.com")!

        tabList.openTab(url: urlA)
        tabList.openTab(url: urlB)

        let tabA = try #require(tabList.tabs.first)

        tabList.activateTab(id: tabA.id)

        #expect(tabList.activeTab?.id == tabA.id)
    }

    @Test func navigatingChangesOnlyTheActiveTabURL() throws {
        var tabList = TabList()
        let urlA = URL(string: "https://apple.com")!
        let urlB = URL(string: "https://github.com")!

        tabList.openTab(url: urlA)
        tabList.openTab(url: urlB)

        let newURL = URL(string: "https://youtube.com")!

        tabList.navigateActiveTab(to: newURL)

        #expect(tabList.activeTab?.url == newURL)

        let tabA = try #require(tabList.tabs.first)

        #expect(tabA.url == urlA)
    }
}
