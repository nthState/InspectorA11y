//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

public struct ItemData: Equatable {
  public let rect: CGRect
  public let message: String
  public let order: Int

  public init(rect: CGRect, message: String, order: Int) {
    self.rect = rect
    self.message = message
    self.order = order
  }
}

struct ActionInstructionModifier: ViewModifier {

  let id: String
  let instruction: String
  let order: Int

  func body(content: Content) -> some View {

    content
      .background(
        GeometryReader { geometry in
          Group {
            Rectangle()
              .fill(Color.clear)
          }
          .preference(key: InstructionOverlayPreferenceDataKey.self, value: [
            InstructionOverlayPreferenceData(id: id, itemData: ItemData(rect: geometry.frame(in: .global), message: instruction, order: order))]
          )
        }
      )
  }
}

extension View {
  public func instruction(id: String, _ text: String, order: Int) -> some View {
    modifier(ActionInstructionModifier(id: id, instruction: text, order: order))
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
