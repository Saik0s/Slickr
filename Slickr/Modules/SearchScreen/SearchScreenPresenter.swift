//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import Foundation

protocol SearchScreenPresenter: AnyObject {
    func loadedNewPage(_ page: FeedPage)
}

final class DefaultSearchScreenPresenter: SearchScreenPresenter {
    weak var view: SearchScreenViewInput?

    init() {}

    func loadedNewPage(_ page: FeedPage) {
        DispatchQueue.main.async { [weak view] in
            if page.page == 1 {
                view?.new(items: page.photos)
            } else {
                view?.add(items: page.photos)
            }
        }
    }
}