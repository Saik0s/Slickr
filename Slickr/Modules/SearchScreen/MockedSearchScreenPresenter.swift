//
// Created by Igor Tarasenko on 19/10/2019.
// Licensed under the MIT license
//

@testable import Slickr

final class MockedSearchScreenPresenter: SearchScreenPresenter {
    var invokedLoadedNewPage = false
    var invokedLoadedNewPageCount = 0
    var invokedLoadedNewPageParameters: (page: FeedPage, Void)?
    var invokedLoadedNewPageParametersList = [(page: FeedPage, Void)]()
    var loadedNewPage: ((FeedPage) -> Void)?

    func loadedNewPage(_ page: FeedPage) {
        invokedLoadedNewPage = true
        invokedLoadedNewPageCount += 1
        invokedLoadedNewPageParameters = (page, ())
        invokedLoadedNewPageParametersList.append((page, ()))
        loadedNewPage?(page)
    }
}
