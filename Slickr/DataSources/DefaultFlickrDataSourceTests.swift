//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import Foundation
import XCTest
@testable import Slickr

final class DefaultFlickrDataSourceTests: XCTestCase {
    var networkEngine: MockedNetworkEngine!
    var dataSource: DefaultFlickrDataSource!

    override func setUp() {
        super.setUp()

        networkEngine = MockedNetworkEngine()
        dataSource = DefaultFlickrDataSource(networkEngine: networkEngine)
    }

    func test_search_withCorrectQuery_shouldReturnItems() {
        networkEngine.get = { _, completion in
            DefaultFlickrDataSourceTests.jsonDataFromFile("search", completion: completion)
            return nil
        }

        let itemsExpectation = expectation(description: "Wait for response with items")

        dataSource.search(with: "flower", limit: 10, page: 1) { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(response.photos.photo.count, 10)
            case let .failure(error):
                XCTFail("\(error)")
            }

            itemsExpectation.fulfill()
        }

        wait(for: [itemsExpectation], timeout: 5.0)
    }

    func test_recent_shouldReturnItems() {
        networkEngine.get = { _, completion in
            DefaultFlickrDataSourceTests.jsonDataFromFile("recent", completion: completion)
            return nil
        }

        let itemsExpectation = expectation(description: "Wait for response with items")

        dataSource.recent(limit: 10, page: 1) { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(response.photos.photo.count, 10)
            case let .failure(error):
                XCTFail("\(error)")
            }

            itemsExpectation.fulfill()
        }

        wait(for: [itemsExpectation], timeout: 5.0)
    }

    // MARK: - Private helpers

    private enum Error: Swift.Error {
        case noJsonFile(String)
    }

    private static func jsonDataFromFile(_ name: String, completion: (Result<Data?, Swift.Error>) -> Void) {
        guard let path = Bundle(for: DefaultFlickrDataSourceTests.self).path(forResource: name, ofType: "json") else {
            completion(.failure(Error.noJsonFile(name)))
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}