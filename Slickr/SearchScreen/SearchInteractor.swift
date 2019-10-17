//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

protocol SearchInteractor: AnyObject {
    func search(for query: String)
}

final class DefaultSearchInteractor: SearchInteractor {
    let presenter: SearchPresenter

    init(presenter: SearchPresenter) {
        self.presenter = presenter
    }

    func search(for query: String) {
    }
}

