//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import OSLog

public extension Logger {

    private static var subsystem = "com.nthState.inspectorA11y.core"

    static let core = Logger(subsystem: subsystem, category: "core")
}
