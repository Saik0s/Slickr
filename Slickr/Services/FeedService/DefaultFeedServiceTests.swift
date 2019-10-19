//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultFeedServiceTests: XCTestCase {
    var dataSource: MockedFlickrDataSource!
    var feedService: FeedService!

    override func setUp() {
        super.setUp()

        dataSource = MockedFlickrDataSource()
        feedService = DefaultFeedService(dataSource: dataSource, imageURLBuilder: DefaultImageURLBuilder())
    }

    func test_search_withEmptyQuery_shouldCallRecent() {
        feedService.search(with: "", page: 1) { _ in  }
        XCTAssert(dataSource.invokedRecent)
        XCTAssertFalse(dataSource.invokedSearch)
    }

    func test_search_withCorrectQuery_shouldCallSearch() {
        feedService.search(with: "flower", page: 1) { _ in  }
        XCTAssert(dataSource.invokedSearch)
        XCTAssertFalse(dataSource.invokedRecent)
    }
}
