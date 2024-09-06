//
//  File.swift
//  
//
//  Created by Chris Davis on 06/09/2024.
//

import Foundation
import CoreGraphics
import SwiftUI

class Capture {

  //complete: (CGImage?) -> Void
  private var capture: CGImage?
  private var result: CGImage?
  private var rects: [String: ItemData] = [: ]

  @MainActor func start(from view: some View) async -> CGImage? {

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

    return regen()

  }

  @MainActor func regen() -> CGImage? {
    print("generate main image: \(rects)")
    result = ImageRenderer(content:

                            Generator(image: capture!, rects: rects)

    ).cgImage

    if let data = result?.pngData() {
      let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
      print("writing to \(filename)")
      try? data.write(to: filename)

      return result
    }

    return nil
  }

}
