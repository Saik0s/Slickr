//
// Created by Igor Tarasenko on 21/10/2019.
// Licensed under the MIT license
//

import struct Foundation.Data
@testable import Slickr

final class MockedPhotoCellPresenter: PhotoCellPresenter {

    var invokedSetLoading = false
    var invokedSetLoadingCount = 0

    func setLoading() {
        invokedSetLoading = true
        invokedSetLoadingCount += 1
    }

    var invokedPresentImage = false
    var invokedPresentImageCount = 0
    var invokedPresentImageParameters: (data: Data, Void)?
    var invokedPresentImageParametersList = [(data: Data, Void)]()

    func presentImage(with data: Data) {
        invokedPresentImage = true
        invokedPresentImageCount += 1
        invokedPresentImageParameters = (data, ())
        invokedPresentImageParametersList.append((data, ()))
    }
}