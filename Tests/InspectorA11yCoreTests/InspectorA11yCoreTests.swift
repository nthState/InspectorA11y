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

  @MainActor func testCreatingANewFile() async throws {

    /**
     read Sources/InspectorA11yCore/TestView.swift

      find all text / Buttons

      in the found sections, work out what the accessibility details are.

      add them in reverse order

     write to a new file

     ....how do we get that into the project for compilation?
     */


    /**

     This might need to be multistage in a CLI


      Step Pre-Build Pre-Run
        pass in the files we want
        git stash push -m "accessibility-generation"
        modify them
        write to the bottom of the existing file?
      Step
          Compile - what are we compiling?
      Step
          Generate Run
      Step
          Clean up
          git stash apply stash@{0}


     OR

     Step Pre-Build Pre-Run
       pass in the files we want
       git stash push -m "accessibility-generation"
       modify them
       write to the bottom of the existing file? / do we have to replace the existing file as we cant init a view from a string
     Step
      Add a unit test that runs let image = await c.capture(from: TestView()) for each file? - it would need to know the names of the views
    Step Post-Build
     git stash apply stash@{0}

     */


    let str = """
//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation
import SwiftUI

struct TmpView {

}

extension TmpView: View {
  var body: some View {
    ZStack {
      Rectangle().fill(Color(red: 4/255, green: 5/255, blue: 15/255).gradient)
      VStack {
        Image(systemName: "photo")
          .font(.system(size: 80))
          .background(in: Circle().inset(by: -40))
          .backgroundStyle(.blue.gradient)
          .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
          .padding(60)
          .instruction(id: "2", "A photo", order: 2)
        Text("Hello, world!")
          .foregroundStyle(Color.orange)
          .font(.largeTitle)
          .accessibilitySortPriority(123)             // not found
          .accessibility(sortPriority: 20)            // AccessibilityPropertiesEntry AccessibilityAttachmentModifier
          .accessibilityLabel("some label")           // AccessibilityLabelStorage AccessibilityAttachmentModifier
          .instruction(id: "1", "say this", order: 1) // ActionInstructionModifier
        Button(action: {}, label: {
          Text("Button")
        })
        .accessibility(sortPriority: 1000)
        .instruction(id: "3", "button", order: 1000)
      }
    }
    .frame(height: 400)
  }
}

#Preview {
  TmpView()
}

"""

    ////try str.write(to: URL(fileURLWithPath: "/Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11yCore/tmp.swift"), atomically: true, encoding: .utf8)

//    let c = InspectorA11y()
//    let image = await c.capture(from: TmpView())
//
//    XCTAssertNotNil(image)


  }

  func testUsingSwiftMirror() {

    let item = TestView().body
      .environment(TestObservable())

    inspect(item: item, indent: 0)
  }

  func inspect(item: Any, indent: Int) {
    let mirror = Mirror(reflecting: item)
    let children = Array(mirror.children)
    print(mirror)

    for child in children {
      print("\(String(repeating: " ", count: indent))child: \(String(describing: child.label)) \(child.value)")

      inspect(item: child.value, indent: indent + 1)
    }
  }

}

@Observable
class TestObservable {

}
