//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import XCTest
@testable import InspectorA11yCore

final class InspectorA11yTests: XCTestCase {

  @MainActor func testImageGeneration() async throws {

    let c = Capture()
    let image = await c.start(from: TestView())

    XCTAssertNotNil(image)
  }

}
