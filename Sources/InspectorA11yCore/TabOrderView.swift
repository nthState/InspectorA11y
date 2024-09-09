//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

struct TabOrderView {
  let order: Int
  let realOrder: Int
  let color: Color
}

extension TabOrderView: View {
  var body: some View {
    Circle()
      .stroke(color, lineWidth: 4)
      .fill(Color.white)
      .overlay(
        Text("\(order)")
          .font(.largeTitle) // Font size
          .foregroundColor(color) // Text color
      )
  }
}

#Preview {
  TabOrderView(order: 1, realOrder: 1000, color: .blue)
    .frame(width: 40, height: 40) // Size of the circle
    .background(Color.red)
}
