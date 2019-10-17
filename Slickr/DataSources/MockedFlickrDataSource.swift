//
// Created by Igor Tarasenko on 17/10/2019.
// Licensed under the MIT license
//

@testable import Slickr

final class MockedFlickrDataSource: FlickrDataSource {
    var invokedSearch = false
    var invokedSearchCount = 0
    var invokedSearchParameters: (query: String, limit: UInt, page: UInt)?
    var invokedSearchParametersList = [(query: String, limit: UInt, page: UInt)]()
    var stubbedSearchCompletionResult: (Result<FlickrPhotosResponse, FlickrError>, Void)?

    func search(with query: String, limit: UInt, page: UInt, completion: @escaping FlickrPhotosResponseHandler) {
        invokedSearch = true
        invokedSearchCount += 1
        invokedSearchParameters = (query, limit, page)
        invokedSearchParametersList.append((query, limit, page))
        if let result = stubbedSearchCompletionResult {
            completion(result.0)
        }
    }

    var invokedRecent = false
    var invokedRecentCount = 0
    var invokedRecentParameters: (limit: UInt, page: UInt)?
    var invokedRecentParametersList = [(limit: UInt, page: UInt)]()
    var stubbedRecentCompletionResult: (Result<FlickrPhotosResponse, FlickrError>, Void)?

    func recent(limit: UInt, page: UInt, completion: @escaping FlickrPhotosResponseHandler) {
        invokedRecent = true
        invokedRecentCount += 1
        invokedRecentParameters = (limit, page)
        invokedRecentParametersList.append((limit, page))
        if let result = stubbedRecentCompletionResult {
            completion(result.0)
        }
    }
}
