//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

public struct ItemData: Equatable {
  public let rect: CGRect
  public let message: String

  public init(rect: CGRect, message: String) {
    self.rect = rect
    self.message = message
  }
}

struct ActionInstructionModifier: ViewModifier {

  let id: String
  let instruction: String

  func body(content: Content) -> some View {

    content
      .background(
        GeometryReader { geometry in
          Group {
            Rectangle()
              .fill(Color.clear)
          }
          .preference(key: InstructionOverlayPreferenceDataKey.self, value: [
            InstructionOverlayPreferenceData(id: id, itemData: ItemData(rect: geometry.frame(in: .global), message: instruction))]
          )
        }
      )
  }
}

extension View {
  func instruction(id: String, _ text: String) -> some View {
    modifier(ActionInstructionModifier(id: id, instruction: text))
  }
}

struct InstructionOverlayPreferenceData: Equatable {
  let id: String
  let itemData: ItemData
}


struct InstructionOverlayPreferenceDataKey: PreferenceKey {
  typealias Value = [InstructionOverlayPreferenceData]

  static var defaultValue: [InstructionOverlayPreferenceData] = []

  static func reduce(value: inout [InstructionOverlayPreferenceData], nextValue: () -> [InstructionOverlayPreferenceData]) {
    value.append(contentsOf: nextValue())
  }
}
