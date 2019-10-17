//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultFlickrDataSourceTests: XCTestCase {
    var networkEngine: MockedNetworkEngine!
    var dataSource: DefaultFlickrDataSource!

    override func setUp() {
        super.setUp()

        networkEngine = MockedNetworkEngine()
        dataSource = DefaultFlickrDataSource(networkEngine: DefaultNetworkEngine())
    }

    func test_search_withCorrectQuery_shouldReturnItems() {
        let itemsExpectation = expectation(description: "Wait for response with items")

        dataSource.search(with: "test", limit: 10, page: 1) { result in
            switch result {
            case let .success(response):
                itemsExpectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [itemsExpectation], timeout: 5.0)
    }
}