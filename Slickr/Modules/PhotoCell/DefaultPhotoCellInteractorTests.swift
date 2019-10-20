//
// Created by Igor Tarasenko on 20/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultPhotoCellInteractorTests: XCTestCase {
    var imageService: MockedImageService!
    var presenter: MockedPhotoCellPresenter!
    var interactor: DefaultPhotoCellInteractor!

    override func setUp() {
        super.setUp()

        imageService = MockedImageService()
        presenter = MockedPhotoCellPresenter()
        interactor = DefaultPhotoCellInteractor(imageService: imageService, presenter: presenter)
    }

    func test_configure_withAnotherPhotoInfo_shouldCancelPreviousRequest() {
        let cancelable = CancelableMock()
        imageService.stubbedLoadImageResult = cancelable

        let photoInfo = PhotoInfo(id: "1", title: "test", url: URL(string: "https://example.com")!)

        interactor.configure(with: photoInfo)
        XCTAssertEqual(imageService.invokedLoadImageCount, 1)

        interactor.configure(with: photoInfo)
        XCTAssertEqual(imageService.invokedLoadImageCount, 2)
        XCTAssert(cancelable.invokedCancel)
    }
}
