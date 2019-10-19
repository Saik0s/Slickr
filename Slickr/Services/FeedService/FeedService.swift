//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

protocol FeedService {
    @discardableResult
    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void) -> Cancelable?
}

final class DefaultFeedService: FeedService {
    private let photosPerPage: UInt = 40

    private let dataSource: FlickrDataSource
    private let imageURLBuilder: ImageURLBuilder

    init(dataSource: FlickrDataSource, imageURLBuilder: ImageURLBuilder) {
        self.dataSource = dataSource
        self.imageURLBuilder = imageURLBuilder
    }

    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void) -> Cancelable? {
        let requestCompletion: FlickrPhotosResponseHandler = { result in
            switch result {
            case let .success(response):
                let photoInfos = response.photos.photo.compactMap { photo -> PhotoInfo? in
                    guard let url = self.imageURLBuilder.url(for: photo) else { return nil }

                    return PhotoInfo(id: photo.id, title: photo.title, url: url)
                }

                let page = FeedPage(page: response.photos.page, totalPages: response.photos.pages, photos: photoInfos)

                completion(.success(page))

            case let .failure(error):
                completion(.failure(error))
            }
        }

        if query.isEmpty {
            return dataSource.recent(limit: photosPerPage, page: page, completion: requestCompletion)
        } else {
            return dataSource.search(with: query, limit: photosPerPage, page: page, completion: requestCompletion)
        }
    }
}
