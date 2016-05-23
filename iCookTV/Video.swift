//
//  Video.swift
//  TryTVOS
//
//  Created by Ben on 19/02/2016.
//  Copyright © 2016 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Freddy

struct Video: JSONDecodable, JSONEncodable {

  let id: String
  let title: String
  let subtitle: String?
  let description: String?
  let length: Int
  let youtube: String
  let source: String?
  let cover: String

  var coverURL: NSURL? {
    return NSURL(string: cover)
  }

  var timestamp: String {
    let seconds = length % 60
    let minutes = (length / 60) % 60
    let hours = length / 3600
    return (hours > 0 ? "\(hours):" : "") + String(format: "%d:%02d", minutes, seconds)
  }

  // MARK: - JSONDecodable

  init(json value: JSON) throws {
    let nullable: JSON.SubscriptingOptions = [.NullBecomesNil, .MissingKeyBecomesNil]
    id = try value.string("id")
    title = try value.string("attributes", "title")
    subtitle = try value.string("attributes", "subtitle", alongPath: nullable)
    description = try value.string("attributes", "description", alongPath: nullable)
    length = try value.int("attributes", "length", or: 0)
    youtube = try value.string("attributes", "embed-url")
    source = try value.string("attributes", "video-url", alongPath: nullable)
    cover = try value.string("attributes", "cover-url")
  }

  // MARK: - JSONEncodable

  func toJSON() -> JSON {
    var attributes: [String: JSON] = [
      "title": .String(title),
      "embed-url": .String(youtube),
      "cover-url": .String(cover),
      "length": .Int(length)
    ]

    if let source = source {
      attributes["video-url"] = .String(source)
    }

    if let subtitle = subtitle {
      attributes["subtitle"] = .String(subtitle)
    }

    if let description = description {
      attributes["description"] = .String(description)
    }

    let json: [String: JSON] = [
      "id": .String(id),
      "attributes": .Dictionary(attributes)
    ]

    return .Dictionary(json)
  }

}
