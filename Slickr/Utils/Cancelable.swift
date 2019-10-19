//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

import class Foundation.URLSessionTask

protocol Cancelable: AnyObject {
    func cancel()
}

extension URLSessionTask: Cancelable {}
