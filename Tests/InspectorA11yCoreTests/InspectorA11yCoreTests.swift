//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import XCTest
@testable import InspectorA11yCore

final class InspectorA11yCoreTests: XCTestCase {

  @MainActor func testGenerateAll() async throws {

    let c = InspectorA11y(configuration: .all)
    let image = await c.capture(from: TestView())

    XCTAssertNotNil(image)
  }

  @MainActor func testGenerateVoiceOverText() async throws {

    let c = InspectorA11y(configuration: .voiceOverText)
    let image = await c.capture(from: TestView())

    XCTAssertNotNil(image)
  }

  @MainActor func testGenerateTabOrder() async throws {

    let c = InspectorA11y(configuration: .tabOrder)
    let image = await c.capture(from: TestView())

    XCTAssertNotNil(image)
  }

}
