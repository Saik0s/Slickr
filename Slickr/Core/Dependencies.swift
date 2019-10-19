//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

import Foundation

final class Dependencies {
    let feedService: FeedService
    let imageService: ImageService

    private init(feedService: FeedService, imageService: ImageService) {
        self.feedService = feedService
        self.imageService = imageService
    }

    static func resolve() -> Dependencies {
        let networkEngine = DefaultNetworkEngine()
        let flickrDataSource = DefaultFlickrDataSource(networkEngine: networkEngine)
        let imageURLBuilder = DefaultImageURLBuilder()
        let feedService = DefaultFeedService(dataSource: flickrDataSource, imageURLBuilder: imageURLBuilder)
        let imageService = DefaultImageService(networkEngine: networkEngine)

        return Dependencies(feedService: feedService, imageService: imageService)
    }
}
