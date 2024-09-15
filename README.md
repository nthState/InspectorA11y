# Inspector A11y

This is a proof of concept to export Accessibility Overviews for SwiftUI Views from Xcode.

Why? The European Accessiblity Act 2025 requires us to make Apps accessible.

I wanted a tool to export, on a per view basis, what I'm missing.

Given

```swift
VStack {
  Image(systemName: "photo")
    .font(.system(size: 80))
    .background(in: Circle().inset(by: -40))
    .backgroundStyle(.blue.gradient)
    .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
    .padding(60)
    .accessibilityLabel("A photo")
    .accessibility(sortPriority: 1)
  Text("Hello, world!")
    .foregroundStyle(Color.orange)
    .font(.largeTitle)
    .accessibilityLabel("say this")
    .accessibility(sortPriority: 2)
}
```

| Type     | Input   | Output   |
| -------- | ------- | -------- |
| Voice over text | ![Input](/Documents/input.png)  | ![Output](/Documents/voiceOverText.jpg) |
| Tab Order | ![Input](/Documents/input.png)  | ![Output](/Documents/tabOrder.jpg) |

The idea is that you pass in a view, and it generates another view showing the accessible data for the view.

## Ramblings below


How do I want to use it?

```
Do we set up custom views in tests, and execute them?

  @MainActor func testImageGeneration() async throws {

    let c = InspectorA11y()
    let result = await c.capture(from: TestView())

    XCTAssertNotNil(result)
  }
```

or

```
This would mean that we'd have to go through all files and append the extra modifiers at runtime.

#Preview {
  TestView()
    .inspectorA11y(generate: true, [.accessibilityIdentifiers, .tabOrder], rendering: [.transparent], folder: "", fileNamePrefix: "testview")
}

I guess this would only work when the user previewed, default parameters could be used. - maybe thats a good thing?
```

or

```
Run a swift command like

swift run InspectorA11y

This would then:

Takes a snapshot of the code
Finds all elements like `Text()` `Image()` `.accessibilityIdentifiers`.
adds an additional modifier after it.
It then takes those views
runs them through the generator
saves the images to disk
revert changes

what should it return?
- A success/error code
- A text version of the output?
- A list of urls to the images
- Should we score them?
```

## Regex?

What if instead of passing in a view, we pass in a file?
Can we read the source code, copy a view, modify and then generate from that view?

## SourceKit

We can scan the source on macOS...but not on iOS...is there a world where we can generate the source in a mac build - then switch.
Is it over-complicated?
Would a regex be easier?

## Source modification

How do we handle source changes, and reverts? - We want it to be unobtrusive to the consumer.

## Testing

```
swift build
swift run InspectorA11y
```


## Accessibility Renderables
- dark mode light mode
- rotation
- larger font sizes
- color invert mode
- button shapes
- device type
- device sizes
- tab order


## Rendering options
- transparency
- watermark as configration


## Technical
- how do we inject render/configurations



- how do i set the full image size?
- save as image mode
-- file location
-- file naming
- realtime mode? - render as a preview with custom size?
- tile results mode?
- CI generation and asset upload
- do i return errors on the image?
- do I make a swift run command?

## Running inside Xcode

Add a `Build Phase` Run `Script`

```bash
echo "yes" | ${BUILD_DIR%Build/*}SourcePackages/checkouts/InspectorA11y/run ${SRCROOT}/MyFile.swift -output ~/AccessibilityImages
```

Add a Unit Test for the Views you want to generate Accessibility Images for

```
import XCTest
import InspectorA11yCore

final class MyUnitTests: XCTestCase {

  @MainActor func test_generate_content_view_accessibility_image() async throws {

    let c = InspectorA11y(configuration: .all, output: URL(string: "~/AccessibilityImages"))
    let result = await c.capture(from: ContentView())

    print(result?.image)
    print(result?.url)

    XCTAssertNotNil(result)
  }
}

```


## Continuous Integration

You may want to let CI handle the generation of the accessibility screenshots, if so, here's a GitHub Action
to do it for you, fill in the `env` properties

```bash
env:
  PROJECT_NAME: "App.xcodeproj"
  PROJECT_SCHEME: "iOS App"
  DESTINATION: "platform=iOS Simulator,name=iPhone 15,OS=latest"

jobs:
  build:
    name: Build
    timeout-minutes: 15
    steps:

      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Generate Accessibility Screenshots
        run: |
            # swift run InspectorA11y someFolder -output someFolder // Sits inside the pre-build
            xcodebuild clean test -project "${{ env.PROJECT_NAME }}" -scheme "${{ env.PROJECT_SCHEME }}" -destination "${{ env.DESTINATION }}" ENABLE_USER_SCRIPT_SANDBOXING=NO
            
      - name: Upload Accessibility Screenshots
        uses: actions/upload-artifact@v4
        with:
          name: AccessibilityScreenshots
          path: someFolder
          retention-days: 3
```
























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


     More concrete

     echo "ChrisDDD"
     echo "yes" | ${BUILD_DIR%Build/*}SourcePackages/checkouts/InspectorA11y/run /Users/chrisdavis/Developer/InspectorA11yApp/InspectorA11yApp/ContentView.swift

     git stash push -m "accessibility-generation"
     ENABLE_USER_SCRIPT_SANDBOXING = NO
     swift run InspectorA11yGenerate -f Sources/InspectorA11yCore/TestView.swift -f Sources/InspectorA11yCore/TestView2.swift -o SomeFolder/ // maybe add a clean option?
     Compile and run Tests // xcodebuild clean test -project "${{ env.PROJECT_NAME }}" -scheme "iOS App" -destination "${{ matrix.devices.destination }}" -testPlan "${{ env.testplan }}"
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
*/
