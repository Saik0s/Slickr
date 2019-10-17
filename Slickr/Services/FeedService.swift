//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

protocol FeedService {
    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void)
}

final class DefaultFeedService: FeedService {
    private let photosPerPage: UInt = 20

    private let dataSource: FlickrDataSource
    private let imageURLBuilder: ImageURLBuilder

    init(dataSource: FlickrDataSource, imageURLBuilder: ImageURLBuilder = DefaultImageURLBuilder()) {
        self.dataSource = dataSource
        self.imageURLBuilder = imageURLBuilder
    }

    func search(with query: String, page: UInt, completion: @escaping (Result<FeedPage, Error>) -> Void) {
        let requestCompletion: FlickrPhotosResponseHandler = { result in
            switch result {
            case let .success(response):
                let photoInfos = response.photos.photo.compactMap { photo -> PhotoInfo? in
                    guard let url = self.imageURLBuilder.url(for: photo) else { return nil }

                    return PhotoInfo(id: photo.id, title: photo.title, url: url)
                }

                let page = FeedPage(page: response.photos.page, totalPages: response.photos.total, photos: photoInfos)

                completion(.success(page))

            case let .failure(error):
                completion(.failure(error))
            }
        }

        if query.isEmpty {
            dataSource.recent(limit: photosPerPage, page: page, completion: requestCompletion)
        } else {
            dataSource.search(with: query, limit: photosPerPage, page: page, completion: requestCompletion)
        }
    }
}
