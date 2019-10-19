//
// Created by Igor Tarasenko on 19/10/2019.
// Licensed under the MIT license
//

@testable import Slickr

final class CancelableMock: Cancelable {
    var invokedCancel = false
    var invokedCancelCount = 0

    func cancel() {
        invokedCancel = true
        invokedCancelCount += 1
    }
}
