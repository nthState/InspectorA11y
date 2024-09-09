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
          .font(.largeTitle)
          .foregroundColor(color)
          .minimumScaleFactor(0.01)
      )
  }
}

#Preview {
  VStack {
    TabOrderView(order: 1, realOrder: 2, color: .blue)
      .frame(width: 40, height: 40)
      .background(Color.red)

    TabOrderView(order: 1000, realOrder: 1000, color: .blue)
      .frame(width: 40, height: 40)
      .background(Color.red)
  }
}
