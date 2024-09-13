//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation

/**
 Use https://swiftregex.com/ for testing
 */
let textFields = #"Text\("([^"]*)"\)"#
let textFieldsAndModifiers = #"Text\("([^"]*)"\)((?:\s*\.[a-zA-Z]+\([^)]*\))(?:\s*//.*)?\s*)*"#
let buttons = #"Button\(.*?\{(?:[^{}]*|\{[^{}]*\})*\}\)"#
let buttonsAndModifiers = #"Button\(.*?\{(?:[^{}]*|\{[^{}]*\})*\}\)((?:\s*\.[a-zA-Z]+\([^)]*\))(?:\s*//.*)?\s*)*"#

