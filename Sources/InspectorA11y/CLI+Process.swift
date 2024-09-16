//
//  File.swift
//
//
//  Created by Chris Davis on 14/09/2024.
//

import Foundation
import OSLog

let textFields = #"Text\("([^"]*)"\)"#
let textFieldsAndModifiers = #"Text\("([^"]*)"\)((?:\s*\.[a-zA-Z]+\([^)]*\))(?:\s*//.*)?\s*)*"#
let buttons = #"Button\(.*?\{(?:[^{}]*|\{[^{}]*\})*\}\)"#
let buttonsAndModifiers = #"Button\(.*?\{(?:[^{}]*|\{[^{}]*\})*\}\)((?:\s*\.[a-zA-Z]+\([^)]*\))(?:\s*//.*)?\s*)*"#

extension CLI {

  struct Item {
    let index: Int
    let id: String
    let text: String?
    let order: Int?
  }

  func processFiles() {
    for url in files {
      do {
        print("Processing: \(url)".yellow())
        try processFile(url: url)
        print("Processed: \(url)".blue())
      } catch {
        print("Failed to process: \(url)".red())
      }
    }
  }

  /**
   Read file
   Find all text blocks
   work out what .insttructioin should be, note index
   Find all button blocks
   work out what .instruction should be, note index
   Add .instruction to file in reverse order
   */
  private func processFile(url fileURL: URL) throws {

    var items: [Item] = []

    // Read the file contents into a string
    var fileContents = try String(contentsOf: fileURL, encoding: .utf8)

    var counter = 0
    for regexStr in [textFieldsAndModifiers, buttonsAndModifiers] {
      let regex = try NSRegularExpression(pattern: regexStr, options: [])

      let matches = regex.matches(in: fileContents, options: [], range: NSRange(location: 0, length: fileContents.utf16.count))

      for match in matches {
        //print("found: \(match)")
        if let substringRange = Range(match.range, in: fileContents) {
          let matchedText = fileContents[substringRange]

          let label = accessibilityLabel(text: String(matchedText))
          let sortOrder = Int(accessibilitySortOrder(text: String(matchedText)) ?? "0")
          let text = textString(text: String(matchedText))

          let item = Item(index: match.range.upperBound,
                          id: String(counter),
                          text: label ?? text ?? "",
                          order: sortOrder)

          items.append(item)

          Logger.cli.info("Match found: \(matchedText)")
        } else {
          Logger.cli.info("Invalid range: \(match.range)")
        }

        counter += 1
      }
    }

    for item in items.reversed() {
      let str = "\n.instruction(id: \"\(item.id)\", \"\(item.text!)\", order: \(item.order!))\n"
      fileContents.insert(contentsOf: str, at:  fileContents.index(fileContents.startIndex, offsetBy: item.index))
    }
    fileContents.insert(contentsOf: "import InspectorA11yCore", at: fileContents.index(fileContents.startIndex, offsetBy: 0))

    if !dryRun {
      Logger.cli.info("Writing: \(fileURL)")
      try fileContents.write(to: fileURL, atomically: true, encoding: .utf8)
    }
  }

  private func accessibilityLabel(text: String) -> String? {
    let regexStr = #"\.accessibilityLabel\("([^"]+)"\)"#

    do {
      let regex = try NSRegularExpression(pattern: regexStr, options: [])
      let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
      for match in matches {
        // Extract the range of the first capturing group (group 1)
        if match.numberOfRanges > 1 {
          let groupRange = match.range(at: 1)
          if let substringRange = Range(groupRange, in: text) {
            let capturedGroup = text[substringRange]
            Logger.cli.info("Captured group: \(capturedGroup)")
            return String(capturedGroup)  // Return the first found group
          }
        } else {
          Logger.cli.info("No capturing group found in match: \(match)")
          return nil
        }
      }

    } catch {
      return nil
    }

    return nil
  }

  private func accessibilitySortOrder(text: String) -> String? {
    let regexStr = #"\.accessibility\(sortPriority:\s*(\d+)\)"#

    do {
      let regex = try NSRegularExpression(pattern: regexStr, options: [])
      let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
      for match in matches {
        // Extract the range of the first capturing group (group 1)
        if match.numberOfRanges > 1 {
          let groupRange = match.range(at: 1)
          if let substringRange = Range(groupRange, in: text) {
            let capturedGroup = text[substringRange]
            Logger.cli.info("Captured group: \(capturedGroup)")
            return String(capturedGroup)  // Return the first found group
          }
        } else {
          Logger.cli.info("No capturing group found in match: \(match)")
          return nil
        }
      }

    } catch {
      return nil
    }

    return nil
  }

  private func textString(text: String) -> String? {
    let regexStr = #"Text\("([^"]+)"\)"#

    do {
      let regex = try NSRegularExpression(pattern: regexStr, options: [])
      let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
      for match in matches {
        // Extract the range of the first capturing group (group 1)
        if match.numberOfRanges > 1 {
          let groupRange = match.range(at: 1)
          if let substringRange = Range(groupRange, in: text) {
            let capturedGroup = text[substringRange]
            Logger.cli.info("Captured group: \(capturedGroup)")
            return String(capturedGroup)  // Return the first found group
          }
        } else {
          Logger.cli.info("No capturing group found in match: \(match)")
          return nil
        }
      }

    } catch {
      return nil
    }

    return nil
  }

}
