//
// Created by Igor Tarasenko on 19/10/2019.
// Licensed under the MIT license
//

import XCTest
@testable import Slickr

final class DefaultSearchScreenInteractorTests: XCTestCase {
    var feedService: MockedFeedService!
    var cancelable: CancelableMock!
    var presenter: MockedSearchScreenPresenter!
    var interactor: DefaultSearchScreenInteractor!

    override func setUp() {
        super.setUp()

        feedService = MockedFeedService()
        cancelable = CancelableMock()
        presenter = MockedSearchScreenPresenter()
        interactor = DefaultSearchScreenInteractor(feedService: feedService, presenter: presenter)
    }


    func test_loadNextPage_twice_shouldPerformOneRequest() {
        let presenterExpectation = expectation(description: "Wait for search results")
        presenter.loadedNewPage = { _ in presenterExpectation.fulfill() }

        feedService.stubbedSearchCompletionResult = (Result<FeedPage, Error>.success(FeedPage(page: 1, totalPages: 10, photos: [])), ())
        interactor.search(for: "test")
        wait(for: [presenterExpectation], timeout: 1.0)
        XCTAssertEqual(feedService.invokedSearchCount, 1)

        feedService.stubbedSearchCompletionResult = nil
        presenter.loadedNewPage = nil

        interactor.loadNextPage()
        interactor.loadNextPage()
        XCTAssertEqual(feedService.invokedSearchCount, 2)
    }

    func test_search_withNewSearch_shouldCancelPreviousSearch() {
        feedService.stubbedSearchResult = cancelable
        interactor.search(for: "test")
        XCTAssertFalse(cancelable.invokedCancel)
        interactor.search(for: "test1")
        XCTAssertTrue(cancelable.invokedCancel)
    }
}
