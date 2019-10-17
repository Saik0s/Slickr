//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

protocol SearchPresenter: AnyObject {}

final class DefaultSearchPresenter: SearchPresenter {
    weak var view: SearchViewInput?

    init() {}
}