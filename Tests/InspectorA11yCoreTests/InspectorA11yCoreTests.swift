//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI
import XCTest
@testable import InspectorA11yCore

final class InspectorA11yCoreTests: XCTestCase {
  
  @MainActor func testGenerateAll() async throws {
    
    let c = InspectorA11y(configuration: .all, output: getDocumentsDirectory())
    let image = await c.capture(from: TestView())
    
    XCTAssertNotNil(image)
  }
  
  @MainActor func testGenerateVoiceOverText() async throws {
    
    let c = InspectorA11y(configuration: .voiceOverText, output: getDocumentsDirectory())
    let image = await c.capture(from: TestView())
    
    XCTAssertNotNil(image)
  }
  
  @MainActor func testGenerateTabOrder() async throws {
    
    let c = InspectorA11y(configuration: .tabOrder, output: getDocumentsDirectory())
    let image = await c.capture(from: TestView())
    
    XCTAssertNotNil(image)
  }
  
}
