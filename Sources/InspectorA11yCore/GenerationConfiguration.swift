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
  public static let voiceOverText = GenerationConfiguration(rawValue: 1 << 0)
  /// Render tab order
  public static let tabOrder = GenerationConfiguration(rawValue: 1 << 1)
  /// Accessibility Identifier
  public static let accessibilityIdentifier = GenerationConfiguration(rawValue: 1 << 2)
  /// Accessibility type
  public static let accessibilityType = GenerationConfiguration(rawValue: 1 << 3)
  /// Button Shapes
  public static let buttonShapes = GenerationConfiguration(rawValue: 1 << 4)
  /// Smart Invert
  public static let smartInvert = GenerationConfiguration(rawValue: 1 << 5)
  /// tap areas
  public static let tapArea = GenerationConfiguration(rawValue: 1 << 6)
  /// hidden
  public static let hidden = GenerationConfiguration(rawValue: 1 << 7)


  public static let all: GenerationConfiguration = [.voiceOverText, .tabOrder, .accessibilityIdentifier, .accessibilityIdentifier, .buttonShapes, .smartInvert, .tapArea, .hidden]
}

extension GenerationConfiguration: CustomStringConvertible {

  static public var debugDescriptions: [(Self, String)] = [
    (.voiceOverText, "VoiceOver"),
    (.tabOrder, "tabOrder"),
    (.accessibilityIdentifier, "identifier"),
    (.accessibilityType, "type"),
    (.buttonShapes, "buttonShapes"),
    (.smartInvert, "smartInvert"),
    (.tapArea, "tapArea"),
    (.hidden, "hidden")
  ]

  public var description: String {
    let result: [String] = Self.debugDescriptions.filter { contains($0.0) }.map { $0.1 }
    let printable = result.joined(separator: "_")

    return "\(printable)"
  }
}
