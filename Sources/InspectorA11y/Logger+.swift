//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import OSLog

public extension Logger {

    private static var subsystem = "com.nthState.inspectorA11y.cli"

    static let cli = Logger(subsystem: subsystem, category: "cli")
}
