//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import Foundation
@testable import Slickr

final class MockedNetworkEngine: NetworkEngine {
    var invokedGet = false
    var invokedGetCount = 0
    var invokedGetParameters: (info: RequestInfo, Void)?
    var invokedGetParametersList = [(info: RequestInfo, Void)]()
    var get: ((RequestInfo, @escaping ResponseHandler) -> Cancelable?)?

    func get(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable? {
        invokedGet = true
        invokedGetCount += 1
        invokedGetParameters = (info, ())
        invokedGetParametersList.append((info, ()))
        return get?(info, completion)
    }

    var invokedPost = false
    var invokedPostCount = 0
    var invokedPostParameters: (info: RequestInfo, Void)?
    var invokedPostParametersList = [(info: RequestInfo, Void)]()
    var post: ((RequestInfo, @escaping ResponseHandler) -> Cancelable?)?

    func post(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable? {
        invokedPost = true
        invokedPostCount += 1
        invokedPostParameters = (info, ())
        invokedPostParametersList.append((info, ()))
        return post?(info, completion)
    }
}
