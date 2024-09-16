//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import CoreGraphics
import SwiftUI
import Foundation

extension CGImage {
    func pngData() -> Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
