//
//  Logger.swift
//  ShieldConfigBugExample
//
//  Created by Maximillian Stabe on 25.10.24.
//

import Foundation
import OSLog

public extension Logger {
  private static var subsystem = Bundle.main.bundleIdentifier!

  static let debug = Logger(subsystem: subsystem, category: "debug")
}
