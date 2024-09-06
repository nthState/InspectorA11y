//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

struct Generator {
  let image: CGImage
  var rects: [String: ItemData] = ["test": ItemData(rect: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)), message: "some message")]

  let imageSize: CGSize

  init(image: CGImage, rects: [String : ItemData] = [: ]) {
    self.image = image
    self.rects = rects
    self.imageSize = CGSize(width: image.width, height: image.height)

    //    let analysis = Analyser()
    //    //analysis.findFeatures(inURL: URL(string: "/Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11y/TestView.swift")!)
    //    analysis.getModifiers(inURL: URL(string: "/Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11y/TestView.swift")!)

  }
}

extension Generator: View {
  var body: some View {

    ZStack(alignment: .topLeading) {

      content

      labels

      watermark
    }
    .frame(width: 1000, height: 1000)
    //.coordinateSpace(name: "diagram")
  }

  private var watermark: some View {
    ZStack(alignment: .bottomTrailing) {
      Text("Watermark")
        .foregroundStyle(Color.green)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
  }

  private var labels: some View {
    ZStack(alignment: .topLeading) {
      ForEach(rects.sorted(by: { lhs, rhs in
        lhs.key > rhs.key
      }), id: \.key) { key, itemData in

        let l = itemData.rect

        Path { path in
          path.move(to: CGPoint(x: 50, y: 50))
          //path.addLine(to: CGPoint(x: (500-(image.size.width/2))+l.midX, y: (500-(image.size.height/2))+l.midY))
          let to = CGPoint(x: (500-(imageSize.width/2))+l.midX, y: (500-(imageSize.height/2))+l.midY)
          let ctrl1 = CGPoint(x: (500-(imageSize.width/2))+l.midX / 2, y: 50)
          let ctrl2 = CGPoint(x: 50, y: (500-(imageSize.height/2))+l.midY)
          path.addCurve(to: to, control1: ctrl1, control2: ctrl2)
        }
        .stroke(.blue, lineWidth: 2.5)
        .mask {
          InverseShape(

            // text box
            Path { path in
              path.addRect(CGRect(x: 0, y: 0, width: 100, height: 100))
            },

            // item on screenshot
            Path { path in
              path.addRect(CGRect(origin: CGPoint(x: (500-(imageSize.width/2)) + l.minX, y: (500-(imageSize.height/2)) + l.minY), size: CGSize(width: l.size.width, height: l.size.height)))
            }
          )
          .fill(style: FillStyle(eoFill: true))
        }

        Text(itemData.message)
          .frame(width: 100, height: 100)
          .border(Color.pink)
          .font(.largeTitle)
          .foregroundStyle(Color.pink)
        //.offset(x: 50, y: 500)


      }
    }
  }

  private var content: some View {

    ZStack(alignment: .topLeading) {

      //Image(uiImage: image)
      Image(decorative: image, scale: 1, orientation: .up)
        .offset(x: 500.0-(imageSize.width/2), y: 500.0-(imageSize.height/2))


      ForEach(rects.sorted(by: { lhs, rhs in
        lhs.key > rhs.key
      }), id: \.key) { key, itemData in

        let rect = itemData.rect
        Rectangle()
          .stroke(lineWidth: 3.0)
          .foregroundColor(Color.green)
          .frame(width: rect.size.width, height: rect.size.height)
          .offset(x: rect.minX, y: rect.minY)
          .offset(x: 500.0-(imageSize.width/2), y: 500.0-(imageSize.height/2))
      }
    }

  }

}

#Preview {
  if let image = ImageRenderer(content: Image("testImage", bundle: .module)).cgImage {

    print(image)
    return Generator(image: image)
  } else {
    return Rectangle()
  }
}
