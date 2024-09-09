//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation
import SwiftUI

struct TestView {

}

extension TestView: View {
  var body: some View {
    ZStack {
      Rectangle().fill(Color(red: 4/255, green: 5/255, blue: 15/255).gradient)
      VStack {
        Image(systemName: "photo")
          .instruction(id: "2", "A photo", order: 2)
          .font(.system(size: 80))
          .background(in: Circle().inset(by: -40))
          .backgroundStyle(.blue.gradient)
          .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
          .padding(60)
        Text("Hello, world!")
          .instruction(id: "1", "say this", order: 1)
          .foregroundStyle(Color.orange)
          .font(.largeTitle)
          .accessibility(sortPriority: 20)
        Button(action: {}, label: {
          Text("Button")
        })
        .instruction(id: "3", "button", order: 1000)
        .accessibility(sortPriority: 1000)
      }
    }
    .frame(height: 400)
  }
}

#Preview {
  TestView()
    //.previewLayout(.fixed(width: 1000, height: 1000))
}
