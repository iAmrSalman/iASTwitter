//
//  iASError.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/26/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import Foundation

enum iASError: Error {
  case invalid(String, CustomStringConvertible)
  case missing(String)
  case `internal`(String)
}

extension iASError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalid(let str, let object):
      return "invalid \(str): \(object.description)"
    case .missing(let str):
      return "\(str) is missing"
    case .internal(let reason):
      return "internal error: \(reason)"
    }
  }
}
