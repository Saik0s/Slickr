//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

protocol SearchScreenFactory {
    func createSearchScreen() -> Presentable
}

final class DefaultSearchScreenFactory: SearchScreenFactory {
    private let feedService: FeedService
    private let photoCellFactory: PhotoCellFactory

    init(feedService: FeedService, photoCellFactory: PhotoCellFactory) {
        self.feedService = feedService
        self.photoCellFactory = photoCellFactory
    }

    func createSearchScreen() -> Presentable {
        let presenter = DefaultSearchScreenPresenter()
        let interactor = DefaultSearchScreenInteractor(feedService: feedService, presenter: presenter)
        let dataSource = DefaultSearchScreenDataSource(photoCellFactory: photoCellFactory)
        let viewController = SearchScreenViewController(interactor: interactor, dataSource: dataSource)
        presenter.view = viewController

        return viewController
    }
}
