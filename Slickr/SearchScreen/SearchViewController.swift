//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import UIKit

protocol SearchViewInput: AnyObject {}

final class SearchViewController: UIViewController, SearchViewInput {
    let interactor: SearchInteractor

    init(interactor: SearchInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
