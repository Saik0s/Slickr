//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass = isRunningTests ? nil : NSStringFromClass(AppDelegate.self)
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)