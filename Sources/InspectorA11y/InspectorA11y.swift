//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

struct InspectorA11y {
  @Environment(\.colorScheme) var colorScheme
  @State var capture: CGImage?
  @State var result: CGImage?
  @State var rects: [String: ItemData] = [: ]
}

extension InspectorA11y: View {
  var body: some View {
    Circle()
      .onAppear {

        @MainActor func regen() {
          print("generate main image: \(rects)")
          result = ImageRenderer(content:

                                  Generator(image: capture!, rects: rects)

          ).cgImage

          if let data = result?.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
            print("writing to \(filename)")
            try? data.write(to: filename)
          }
        }

        capture = ImageRenderer(content:

                                  TestView()
          .environment(\.colorScheme, colorScheme)
          .onPreferenceChange(InstructionOverlayPreferenceDataKey.self) { preferences in
            print("preferences: \(preferences)")
            for p in preferences {
              rects[p.id] = p.itemData
            }

            regen()
          }

        ).cgImage

        //print("Found: \(rects)")



      }
  }
}

#Preview {
  InspectorA11y()
}
