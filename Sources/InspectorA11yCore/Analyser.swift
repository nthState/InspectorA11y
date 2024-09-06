//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation
//import sourcekitd

class Analyser {

  private let sourceKit = SourceKit()
  private let keys: sourcekitd_keys!
  private let requests: sourcekitd_requests!
  private let values: sourcekitd_values!

  init() {
    keys = sourceKit.keys!
    requests = sourceKit.requests!
    values = sourceKit.values!
  }
}

extension Analyser {

  func getModifiers(inURL url: URL) {
      let sourceKit = SourceKit()

      let request = SKRequestDictionary(sourcekitd: sourceKit)
      request[sourceKit.keys.request] = sourceKit.requests.editor_open
    request[sourceKit.keys.name] = url.absoluteString
      request[sourceKit.keys.sourcefile] = url.absoluteString
    print("looking in \(url.absoluteString)")
      let response = sourceKit.sendSync(request)
    print("response: \(response)")
      response.recurseEntities { entity in
        print("rntity")
        if let kind: String = entity[self.keys.kind], kind == "source.lang.swift.expr.call" {
          print("found: \(kind)")
          if let name: String = entity[sourceKit.keys.name], name == "instruction" {
                  print("Modifier found: \(name)")
//                  if let arguments = entity[sourceKit.keys.substructure] {
//                      for arg in arguments {
//                          // process arguments if needed, e.g., check for true/false
//                      }
//                  }
              }
          }
      }
  }

  internal func findFeatures(inURL url: URL) {
    let req = SKRequestDictionary(sourcekitd: sourceKit)

    req[keys.request] = requests.editor_open
    req[keys.name] = url.absoluteString
    req[keys.sourcefile] = url.absoluteString

    print("SourceKit Request: \(req)")
    let response = sourceKit.sendSync(req)
    print("SourceKit Response: \(response)")

    recurse(url: url, response: response)
  }

  internal func recurse(url: URL, response: SKResponseDictionary) {
    response.recurse(uid: keys.substructure) { dict in
      let kind: SKUID? = dict[self.keys.kind]
      self.recurse(url: url, response: dict)

      //print(self.values.)

      guard kind?.uid == self.values.expr_call else {
        return
      }

      if let name: String = dict[self.keys.name],
          let offset: Int = dict[self.keys.offset] {

        print("Call: \(name) \(offset)")
//        if self.expected.contains(name) {
//          self.calls.insert(name)
//          self.newCalls.insert(Call(name: name, url: url, offset: offset))
//        }
      }
    }
  }

}
