//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

protocol SearchScreenFactory {
    func createSearchScreen() -> Presentable
}

final class DefaultSearchScreenFactory: SearchScreenFactory {
    func createSearchScreen() -> Presentable {
        let presenter = DefaultSearchPresenter()
        let interactor = DefaultSearchInteractor(presenter: presenter)
        let view = SearchViewController(interactor: interactor)
        presenter.view = view

        return view
    }
}
