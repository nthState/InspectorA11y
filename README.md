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

## Why not use Accessibility Inspector?

I want to see everything at once.

## Testing

```
swift build
swift run InspectorA11y
```

## Output

We return `images` and `URLs' to the images of the Views we generate.

In the future, we may score each View.


## Accessibility Renderables
- voice over text       Implemented
- dark mode light mode
- rotation
- larger font sizes
- color invert mode
- button shapes
- device type
- device sizes
- tab order             Implemented

## Running inside Xcode

InspectorA11y needs to modify your source to run, for generation only we need `ENABLE_USER_SCRIPT_SANDBOXING=NO`

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
    timeout-minutes: 5
    steps:

      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Check dependencies
        run: |
          swift --version

      - name: Close and run InspectorA11y
        run: |
          git clone https://github.com/nthState/InspectorA11y.git
          cd InspectorA11y
          chmod +x run
          echo "yes" | ./run ~/MyFile.swift -output ~/AccessibilityImages
        
      - name: Generate Accessibility Screenshots
        run: |
          xcodebuild clean test -project "${{ env.PROJECT_NAME }}" -scheme "${{ env.PROJECT_SCHEME }}" -destination "${{ env.DESTINATION }}" ENABLE_USER_SCRIPT_SANDBOXING=NO
            
      - name: Upload Accessibility Images
        uses: actions/upload-artifact@v4
        with:
          name: AccessibilityImages
          path: someFolder
          retention-days: 3
```




## How it currently works

I'm using Regular Expressions to search for blocks of text and their modifiers, then search within those found blocks to 
extract any pertinent accessibility information.

## Previous Ideas

### Regex?

What if instead of passing in a view, we pass in a file?
Can we read the source code, copy a view, modify and then generate from that view?

### SourceKit

We can scan the source on macOS...but not on iOS...is there a world where we can generate the source in a mac build - then switch.
Is it over-complicated?
Would a regex be easier?

### Reflection/Mirror API

Can we use the `Mirror` API to find all of the view modifiers...yes.
Can we use the `Mirror` API to modify the source? Np.

### Realtime Accessibility Previews

Could we add a view modifier to a preview of a view so that we could see the accessibility information in realtime?

```
#Preview {
  TestView()
    .inspectorA11y(generate: true, [.accessibilityIdentifiers, .tabOrder], rendering: [.transparent], folder: "", fileNamePrefix: "testview")
}
```

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
