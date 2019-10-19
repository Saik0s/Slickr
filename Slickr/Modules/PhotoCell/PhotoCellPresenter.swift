//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

import Foundation
import UIKit

protocol PhotoCellPresenter: AnyObject {
    func setLoading()
    func presentImage(with data: Data)
}

final class DefaultPhotoCellPresenter: PhotoCellPresenter {
    weak var view: PhotoCellInput?

    init() {}

    func setLoading() {
        view?.set(state: .loading)
    }

    func presentImage(with data: Data) {
        DispatchQueue.global().async { [weak view] in
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak view] in
                view?.set(state: .image(image))
            }
        }
    }
}
