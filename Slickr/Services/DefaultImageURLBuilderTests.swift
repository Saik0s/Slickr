//
// Created by Igor Tarasenko on 17/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultImageURLBuilderTest: XCTestCase {
    func test_urlFor_withCorrectPhotoInfo_shouldCreateURL() {
        let photoInfo = FlickrPhotoInfo(id: "48915726857", owner: "184957977@N05", secret: "a6455cc411", server: "65535", farm: 66, title: "")
        let urlBuilder = DefaultImageURLBuilder()

        let url = urlBuilder.url(for: photoInfo)
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://farm66.staticflickr.com/65535/48915726857_a6455cc411.jpg")
    }
}
