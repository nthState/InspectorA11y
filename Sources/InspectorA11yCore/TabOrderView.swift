//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

struct TabOrderView {
  let order: Int
  let realOrder: Int
}

extension TabOrderView: View {
  var body: some View {
    Circle()
      .stroke(Color.blue, lineWidth: 4)
      .fill(Color.white)
      .frame(width: 40, height: 40) // Size of the circle
      .overlay(
        Text("\(order)")
          .font(.largeTitle) // Font size
          .foregroundColor(.blue) // Text color
      )
  }
}

#Preview {
  TabOrderView(order: 1, realOrder: 1000)
    .background(Color.red)
}
