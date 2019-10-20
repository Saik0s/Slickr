//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultImageServiceTests: XCTestCase {
    var networkEngine: MockedNetworkEngine!
    var imageService: DefaultImageService!

    override func setUp() {
        super.setUp()

        networkEngine = MockedNetworkEngine()
        imageService = DefaultImageService(networkEngine: networkEngine)
    }

    func test_loadImageFor_withSameURL_cachesImage() {
        guard let path = Bundle(for: DefaultFlickrDataSourceTests.self).path(forResource: "example-image", ofType: "jpg") else {
            XCTFail("Could not find example image")
            return
        }

        let imageData = try! Data(contentsOf: URL(fileURLWithPath: path))

        networkEngine.get = { info, handler in
            handler(.success(imageData))
            return nil
        }

        let photoInfo = PhotoInfo(id: "1", title: "test", url: URL(string: "https://example.com")!)

        var imageExpectation = expectation(description: "Wait for image loading")

        imageService.loadImage(for: photoInfo) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(imageData, data)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            imageExpectation.fulfill()
        }

        wait(for: [imageExpectation], timeout: 1.0)

        XCTAssertEqual(networkEngine.invokedGetCount, 1)

        imageExpectation = expectation(description: "Wait for image loading from cache")

        imageService.loadImage(for: photoInfo) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(imageData, data)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
            imageExpectation.fulfill()
        }

        wait(for: [imageExpectation], timeout: 1.0)

        XCTAssertEqual(networkEngine.invokedGetCount, 1)
    }
}
