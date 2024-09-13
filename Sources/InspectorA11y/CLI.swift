//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import ArgumentParser
import Foundation
import OSLog
import InspectorA11yCore

/**
 Examples:
 swift run InspectorA11y /TestView.swift /TestView2.swift
 */

@main
public struct CLI: AsyncParsableCommand {

  @Argument(help: "Files to change")
  var files: [String] = []

  @Option(name: .shortAndLong, help: "Output folder, if none specified, will write to the where the Views are specified")
  var output: String?

  @Flag(name: .shortAndLong, help: "Dry Run writes to the console")
  var dryRun: Bool = false

  public init() {

  }

  public mutating func run() async throws {

    print("InspectorA11yCore Starting")
    print("files: \(files)")

  }
}
