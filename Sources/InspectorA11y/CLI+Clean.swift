//
//  File.swift
//
//
//  Created by Chris Davis on 14/09/2024.
//

import Foundation
import OSLog

extension CLI {
  /**
   Iterate all files and remove lines starting with .instruction
   */
  func cleanFiles() {
    for url in files {
      do {
        print("Cleaning: \(url)".yellow())
        try removeLinesStartingWith(prefixes: [".instruction", "import InspectorA11yCore"], from: url)
        print("Cleaned: \(url)".blue())
      } catch {
        print("Failed to clean: \(url)".red())
      }
    }
  }

  func removeLinesStartingWith(prefixes: [String], from fileURL: URL) throws {
    // Read the file contents into a string
    let fileContents = try String(contentsOf: fileURL, encoding: .utf8)

    // Split the file contents into lines
    let lines = fileContents.split(separator: "\n", omittingEmptySubsequences: false)

    // Filter out lines that start with the specified prefix
    let filteredLines = lines.filter { line in
          let trimmedLine = line.trimmingCharacters(in: .whitespaces)
          return !prefixes.contains { prefix in trimmedLine.hasPrefix(prefix) }
      }

    // Join the filtered lines into a single string
    let newFileContents = filteredLines.joined(separator: "\n")

    // Write the new contents back to the file
    if !dryRun {
      try newFileContents.write(to: fileURL, atomically: true, encoding: .utf8)
    }
  }

}
