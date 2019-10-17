//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

import Foundation
@testable import Slickr

final class MockedNetworkEngine: NetworkEngine {
    func get(url: URL, parameters: [String: Any], completion: @escaping ResponseHandler) {

    }

    func post(url: URL, parameters: [String: Any], completion: @escaping ResponseHandler) {

    }
}
