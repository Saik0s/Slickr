//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import UIKit

protocol Presentable: AnyObject {
    var asViewController: UIViewController { get }
}

extension UIViewController: Presentable {
    var asViewController: UIViewController { self }
}
