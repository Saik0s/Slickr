//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import Foundation
@testable import Slickr

final class MockedNetworkEngine: NetworkEngine {
    var get: ((RequestInfo, @escaping ResponseHandler) -> Cancelable?)?
    var post: ((RequestInfo, @escaping ResponseHandler) -> Cancelable?)?

    func get(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable? {
        get?(info, completion)
    }

    func post(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable? {
        post?(info, completion)
    }
}
