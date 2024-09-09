//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import SwiftUI

struct Generator {
  let image: CGImage
  let configuration: GenerationConfiguration
  var rects: [String: ItemData] = ["test": ItemData(rect: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)), message: "some message", order: 1)]

  let imageSize: CGSize

  init(configuration: GenerationConfiguration, image: CGImage, rects: [String : ItemData] = [: ]) {
    self.image = image
    self.configuration = configuration
    self.rects = rects
    self.imageSize = CGSize(width: image.width, height: image.height)

    //    playing with source kit here let analysis = Analyser()
    //    //analysis.findFeatures(inURL: URL(string: "/Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11y/TestView.swift")!)
    //    analysis.getModifiers(inURL: URL(string: "/Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11y/TestView.swift")!)

  }
}

extension Generator: View {
  var body: some View {

    ZStack(alignment: .topLeading) {

      content

      if configuration.contains(.voiceOverText) {
        voiceOverText
      }

      if configuration.contains(.tabOrder) {
        tabOrder
      }

      watermark
    }
    .frame(width: 1000, height: 1000)
    //.coordinateSpace(name: "diagram")
  }

  private var watermark: some View {
    ZStack(alignment: .bottomTrailing) {
      Text("InspectorA11y \(String(describing: Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year))")
        .foregroundStyle(Color.green)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
  }

  private var tabOrder: some View {
    ZStack(alignment: .topLeading) {
      ForEach(rects.sorted(by: { lhs, rhs in
        lhs.key > rhs.key
      }), id: \.key) { key, itemData in

        let rect = itemData.rect

        TabOrderView(order: itemData.order, realOrder: itemData.order)
          .offset(x: rect.minX, y: rect.minY)
          .offset(x: 500.0-(imageSize.width/2), y: 500.0-(imageSize.height/2))

      }
    }
  }

  private var voiceOverText: some View {
    ZStack(alignment: .topLeading) {
      ForEach(rects.sorted(by: { lhs, rhs in
        lhs.key > rhs.key
      }), id: \.key) { key, itemData in

        let targetRect = itemData.rect
        let sourceRect = CGRect(x: 10, y: targetRect.origin.y - 10, width: 100, height: 100)

        Path { path in
          path.move(to: CGPoint(x: sourceRect.midX, y: sourceRect.midY))
          let to = CGPoint(x: (500-(imageSize.width/2))+targetRect.midX, y: (500-(imageSize.height/2))+targetRect.midY)
          let ctrl1 = CGPoint(x: (500-(imageSize.width/2))+targetRect.midX / 2, y: sourceRect.origin.y)
          let ctrl2 = CGPoint(x: sourceRect.origin.x, y: (500-(imageSize.height/2))+targetRect.midY)
          path.addCurve(to: to, control1: ctrl1, control2: ctrl2)
        }
        .stroke(.blue, lineWidth: 2.5)
        .mask {
          InverseShape(

            // text box
            Path { path in
              path.addRect(sourceRect)
            },

            // item on screenshot
            Path { path in
              path.addRect(CGRect(origin: CGPoint(x: (500-(imageSize.width/2)) + targetRect.minX, y: (500-(imageSize.height/2)) + targetRect.minY), size: CGSize(width: targetRect.size.width, height: targetRect.size.height)))
            }
          )
          .fill(style: FillStyle(eoFill: true))
        }

        Text(itemData.message)
          .frame(width: sourceRect.width, height: sourceRect.height)
          .border(Color.pink)
          .font(.largeTitle)
          .foregroundStyle(Color.pink)
          .offset(x: sourceRect.minX, y: sourceRect.minY)

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
    return Generator(configuration: .all, image: image)
  } else {
    return Rectangle()
  }
}
