//
//  Copyright © nthState Ltd. 2024. All rights reserved.
//

import ArgumentParser
import Foundation
import OSLog
import InspectorA11yCore

/**
 Examples:
 echo "yes" | swift run InspectorA11y /Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11yCore/TestView.swift
 echo "yes" | swift run InspectorA11y Users/chrisdavis/Developer/InspectorA11y/Sources/InspectorA11yCore/TestView.swift -c

 echo $? // to print the
 */

@main
public struct CLI: AsyncParsableCommand {
  
  @Argument(help: "Files to change", transform: { URL(fileURLWithPath: $0) })
  var files: [URL] = []
  
  @Option(name: .shortAndLong, help: "Output folder, if none specified, will write to the where the Views are specified")
  var output: String?
  
  @Flag(name: .shortAndLong, help: "Dry Run writes to the console")
  var dryRun: Bool = false
  
  @Flag(name: .shortAndLong, help: "Clean the files, reverts, if using this option, all other options are ignored")
  var clean: Bool = false
  
  public init() {
    
  }
  
  public mutating func run() async throws {
    
    print("InspectorA11yCore Starting")
    
    print("Type 'yes' to continue:".red())
    if let response = readLine(), response.lowercased() == "yes" {
      
      
      guard !clean else {
        cleanFiles()
        return
      }
      
      cleanFiles()
      
      processFiles()
      
    } else {
      // Handle the case where the user does not type 'yes'
      print("Operation aborted.".red())
      throw ExitCode(1)
    }
  }
  
  
}

extension String {
  // black   30
  // red     31
  // green   32
  // yellow  33
  // blue    34
  // magenta 35
  // cyan    36
  // white   37
  public func red() -> String {
    "\u{001B}[0;31m\(self)\u{001B}[0;0m"
  }

  public func yellow() -> String {
    "\u{001B}[0;33m\(self)\u{001B}[0;0m"
  }

  public func blue() -> String {
    "\u{001B}[0;34m\(self)\u{001B}[0;0m"
  }
}
