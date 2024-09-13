//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI
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

  func testMirror() {

    let item = TestView().body
      .environment(TestObservable())

    inspect(item: item, indent: 0)
  }

  func inspect(item: Any, indent: Int) {
    let mirror = Mirror(reflecting: item)
    let children = Array(mirror.children)
    print(mirror)

    for child in children {
      print("\(String(repeating: " ", count: indent))child: \(child.label) \(child.value)")

      inspect(item: child.value, indent: indent + 1)
    }
  }

}

@Observable
class TestObservable {

}
