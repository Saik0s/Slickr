//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import Foundation

enum FlickrError: Error {
    case emptySearchQuery
    case requestError(Error)
    case parseError(Error)
    case nilData
}

typealias FlickrPhotosResponseHandler = (Result<FlickrPhotosResponse, FlickrError>) -> Void

protocol FlickrDataSource: AnyObject {
    func search(with query: String, limit: UInt, page: UInt, completion: @escaping FlickrPhotosResponseHandler)
    func recent(limit: UInt, page: UInt, completion: @escaping FlickrPhotosResponseHandler)
}

final class DefaultFlickrDataSource: FlickrDataSource {
    enum Methods {
        static let search = "flickr.photos.search"
        static let recent = "flickr.photos.getRecent"
    }

    private let networkEngine: NetworkEngine

    init(networkEngine: NetworkEngine) {
        self.networkEngine = networkEngine
    }

    func search(with query: String, limit: UInt, page: UInt, completion: @escaping FlickrPhotosResponseHandler) {
        guard !query.isEmpty else {
            completion(.failure(FlickrError.emptySearchQuery))
            return
        }

        var parameters = baseParameters(method: Methods.search, limit: limit, page: page)
        parameters["text"] = query

        getPhotos(parameters: parameters, completion: completion)
    }

    func recent(limit: UInt, page: UInt, completion: @escaping FlickrPhotosResponseHandler) {
        let parameters = baseParameters(method: Methods.recent, limit: limit, page: page)

        getPhotos(parameters: parameters, completion: completion)
    }

    // MARK: - Private Helpers

    private var baseParameters: [String: Any] {
        return [
            "api_key": Constants.Flickr.APIKey,
            "format": "json",
            "media": "photos",
            "nojsoncallback": 1
        ]
    }

    private func baseParameters(method: String, limit: UInt, page: UInt) -> [String: Any] {
        var parameters: [String: Any] = baseParameters
        parameters["method"] = Methods.search
        parameters["per_page"] = limit
        parameters["page"] = page

        return parameters
    }

    private func getPhotos(parameters: [String: Any], completion: @escaping FlickrPhotosResponseHandler) {
        let requestInfo = RequestInfo(url: Constants.Flickr.baseURL, parameters: parameters)

        networkEngine.get(with: requestInfo) { result in
            DefaultFlickrDataSource.handlePhotosResponse(result: result, completion: completion)
        }
    }

    private static func handlePhotosResponse(result: Result<Data?, Error>, completion: @escaping FlickrPhotosResponseHandler) {
        switch result {
        case let .success(data):
            guard let data = data else {
                completion(.failure(FlickrError.nilData))
                return
            }

            do {
                let flickrPhotosResponse = try JSONDecoder().decode(FlickrPhotosResponse.self, from: data)
                completion(.success(flickrPhotosResponse))
            } catch {
                completion(.failure(FlickrError.parseError(error)))
            }
        case let .failure(error):
            completion(.failure(FlickrError.requestError(error)))
        }
    }
}
