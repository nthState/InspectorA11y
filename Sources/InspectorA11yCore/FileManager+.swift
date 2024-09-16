//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import Foundation

extension FileManager {

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

}
