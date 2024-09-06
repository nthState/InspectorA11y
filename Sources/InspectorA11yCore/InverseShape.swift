//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI
import CoreGraphics

struct InverseShape: Shape {
  
  let originalPaths: [Path]

  init(_ originalPaths: Path...) {
    self.originalPaths = originalPaths
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    //path.addRect(rect) // Add the full rectangle
    path.addRect(CGRect(origin: rect.origin, size: CGSize(width: 1000, height: 1000)))
    for subPath in self.originalPaths {
      path.addPath(subPath, transform: .identity) // Subtract the original path
    }
    return path
  }

}
