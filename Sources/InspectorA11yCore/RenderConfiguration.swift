//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation

struct RenderConfiguration: OptionSet {
  public let rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }
  
  public static let transparent = GenerationConfiguration(rawValue: 1 << 0)
}
