//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftUI

class InspectorA11y {

  private var capture: CGImage?
  private var result: CGImage?
  private var rects: [String: ItemData] = [: ]
  private let configuration: GenerationConfiguration

  public init(configuration: GenerationConfiguration = .all) {
    self.configuration = configuration
  }

  @MainActor func capture(from view: some View) async -> CGImage? {

    let name = String(describing: view.self).trimmingCharacters(in: .alphanumerics.inverted)

    capture = ImageRenderer(content:

                              view
      //.environment(\.colorScheme, colorScheme)
      .onPreferenceChange(InstructionOverlayPreferenceDataKey.self) { preferences in
        print("preferences: \(preferences)")
        for p in preferences {
          self.rects[p.id] = p.itemData
        }
      }

    ).cgImage

    try? await Task.sleep(nanoseconds: 1_000_000_000)

    return regen(name: name)

  }

  @MainActor func regen(name: String) -> CGImage? {
    print("generate main image: \(rects)")
    result = ImageRenderer(content:

                            Generator(image: capture!, rects: rects)

    ).cgImage

    if let data = result?.pngData() {


      let filename = getDocumentsDirectory()
        .appendingPathComponent("\(name)_\(configuration.description).png")

      print("writing to \(filename)")
      try? data.write(to: filename)

      return result
    }

    return nil
  }

}
