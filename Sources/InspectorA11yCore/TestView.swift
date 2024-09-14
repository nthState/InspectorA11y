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
          .font(.system(size: 80))
          .background(in: Circle().inset(by: -40))
          .backgroundStyle(.blue.gradient)
          .foregroundStyle(.white.shadow(.drop(radius: 1, y: 1.5)))
          .padding(60)
        Text("Hello, world!")
          .foregroundStyle(Color.orange)
          .font(.largeTitle)
          .accessibilitySortPriority(123)             // not found
          .accessibility(sortPriority: 20)            // AccessibilityPropertiesEntry AccessibilityAttachmentModifier
          .accessibilityLabel("some label")           // AccessibilityLabelStorage AccessibilityAttachmentModifier
        
        Button(action: {}, label: {
          Text("Button")

        })
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
