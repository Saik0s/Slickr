//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import Foundation
@testable import Slickr

final class MockedNetworkEngine: NetworkEngine {
    var get: ((RequestInfo, @escaping ResponseHandler) -> Void)?
    var post: ((RequestInfo, @escaping ResponseHandler) -> Void)?

    func get(with info: RequestInfo, completion: @escaping ResponseHandler) {
        get?(info, completion)
    }

    func post(with info: RequestInfo, completion: @escaping ResponseHandler) {
        post?(info, completion)
    }
}
