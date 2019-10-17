//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultNetworkEngineTests: XCTestCase {
    var networkEngine: NetworkEngine!

    override func setUp() {
        super.setUp()

        networkEngine = DefaultNetworkEngine()
    }

    func test_get_withCorrectURL_shouldSucceed() {
        let responseExpectation = expectation(description: "Wait for response")

        let url = URL(string: "https://www.google.com")!
        let info = RequestInfo(url: url, parameters: [:])
        networkEngine.get(with: info) { result in
            switch result {
            case .success:
                responseExpectation.fulfill()
            case let .failure(error):
                XCTFail("Error while performing request: \(error)")
            }
        }

        wait(for: [responseExpectation], timeout: 5.0)
    }
}
