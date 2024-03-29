//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import Foundation

protocol SearchScreenInteractor: AnyObject {
    func search(for query: String)
    func reload()
    func loadNextPage()
}

final class DefaultSearchScreenInteractor: SearchScreenInteractor {
    private var currentQuery = ""
    private var currentPage: UInt = 0
    private var totalPages: UInt = 0
    private var isLoadingNextPage = false
    private var currentTask: Cancelable?

    private let feedService: FeedService
    private let presenter: SearchScreenPresenter

    init(feedService: FeedService, presenter: SearchScreenPresenter) {
        self.feedService = feedService
        self.presenter = presenter
    }

    func search(for query: String) {
        currentQuery = query

        reload()
    }

    func reload() {
        currentPage = 0
        totalPages = 0

        performSearch()
    }

    func loadNextPage() {
        guard !isLoadingNextPage else { return }
        guard currentPage < totalPages else { return }

        performSearch()
    }

    private func performSearch() {
        isLoadingNextPage = true
        currentTask?.cancel()
        let page = currentPage + 1
        let total = totalPages
        currentTask = feedService.search(with: currentQuery, page: page) { [weak self] result in
            DispatchQueue.main.async {
                self?.currentTask = nil
                self?.isLoadingNextPage = false
                switch result {
                case let .success(page):
                    self?.currentPage = page.page
                    self?.totalPages = page.totalPages
                    self?.presenter.loadedNewPage(page)
                case let .failure(error):
                    print("\(#function) Error: \(error)")
                    self?.presenter.loadedNewPage(FeedPage(page: page, totalPages: total, photos: []))
                }
            }
        }
    }
}

