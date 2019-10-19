//
// Created by Igor Tarasenko on 19/10/2019.
// Licensed under the MIT license
//

@testable import Slickr

final class MockedFeedService: FeedService {
    var invokedSearch = false
    var invokedSearchCount = 0
    var invokedSearchParameters: (query: String, page: UInt)?
    var invokedSearchParametersList = [(query: String, page: UInt)]()
    var stubbedSearchCompletionResult: (Result<FeedPage, Error>, Void)?
    var stubbedSearchResult: Cancelable!

    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void) -> Cancelable? {
        invokedSearch = true
        invokedSearchCount += 1
        invokedSearchParameters = (query, page)
        invokedSearchParametersList.append((query, page))
        if let result = stubbedSearchCompletionResult {
            completion(result.0)
        }
        return stubbedSearchResult
    }
}
