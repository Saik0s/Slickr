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
        print(#function + " \(query)")
        currentQuery = query
        currentTask?.cancel()
        isLoadingNextPage = true
        currentPage = 0
        totalPages = 0
        currentTask = feedService.search(with: query, page: 1) { [weak self] result in
            self?.currentTask = nil
            self?.isLoadingNextPage = false
            switch result {
            case let .success(page):
                self?.currentPage = page.page
                self?.totalPages = page.totalPages
                self?.presenter.loadedNewPage(page)
            case let .failure(error):
                print(error)
                self?.presenter.loadedNewPage(FeedPage(page: 1, totalPages: 1, photos: []))
            }
        }
    }

    func reload() {
        print(#function)
        currentTask?.cancel()
        isLoadingNextPage = true
        currentPage = 0
        totalPages = 0
        currentTask = feedService.search(with: currentQuery, page: 1) { [weak self] result in
            self?.currentTask = nil
            self?.isLoadingNextPage = false
            switch result {
            case let .success(page):
                self?.currentPage = page.page
                self?.totalPages = page.totalPages
                self?.presenter.loadedNewPage(page)
            case let .failure(error):
                print(error)
                self?.presenter.loadedNewPage(FeedPage(page: 1, totalPages: 1, photos: []))
            }
        }
    }

    func loadNextPage() {
        print(#function)
        guard !isLoadingNextPage else { return }
        guard currentPage < totalPages else { return }
        isLoadingNextPage = true

        currentTask?.cancel()
        isLoadingNextPage = true
        let page = currentPage + 1
        let total = totalPages
        currentTask = feedService.search(with: currentQuery, page: page) { [weak self] result in
            self?.currentTask = nil
            self?.isLoadingNextPage = false
            switch result {
            case let .success(page):
                self?.currentPage = page.page
                self?.totalPages = page.totalPages
                self?.presenter.loadedNewPage(page)
            case let .failure(error):
                print(error)
                self?.presenter.loadedNewPage(FeedPage(page: page, totalPages: total, photos: []))
            }
        }
    }
}

