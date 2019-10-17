//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

struct PhotoInfo {
    let id: String
    let title: String
}

struct FeedPage {
    let page: UInt
    let totalPages: UInt
    let photos: [PhotoInfo]
}

protocol FeedService {
    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void)
}

final class DefaultFeedService: FeedService {
    private let photosPerPage: UInt = 20

    private let dataSource: FlickrDataSource

    init(dataSource: FlickrDataSource) {
        self.dataSource = dataSource
    }

    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void) {
        let requestCompletion: FlickrPhotosResponseHandler = { result in

        }

        if query.isEmpty {
            dataSource.recent(limit: photosPerPage, page: page, completion: requestCompletion)
        } else {
            dataSource.search(with: query, limit: photosPerPage, page: page, completion: requestCompletion)
        }
    }
}
