//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation

struct GenerationConfiguration: OptionSet {
  public let rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }

  /// Render Voice Over
  public static var voiceOverText = GenerationConfiguration(rawValue: 1 << 0)
  /// Render tab order
  public static var tabOrder = GenerationConfiguration(rawValue: 1 << 1)
  /// Accessibility Identifier
  public static var accessibilityIdentifier = GenerationConfiguration(rawValue: 1 << 2)
  /// Accessibility type
  public static var accessibilityType = GenerationConfiguration(rawValue: 1 << 3)
  /// Button Shapes
  public static var buttonShapes = GenerationConfiguration(rawValue: 1 << 4)
  /// Smart Invert
  public static var smartInvert = GenerationConfiguration(rawValue: 1 << 5)
  /// tap areas
  public static var tapArea = GenerationConfiguration(rawValue: 1 << 6)
  /// hidden
  public static var hidden = GenerationConfiguration(rawValue: 1 << 7)
}
