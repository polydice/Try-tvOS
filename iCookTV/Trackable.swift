//
//  Trackable.swift
//  iCookTV
//
//  Created by Ben on 03/05/2016.
//  Copyright © 2016 Polydice, Inc.
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

/// Required properties of a trackable view controller class.
protocol Trackable: class {
  var pageView: PageView? { get }
}

////////////////////////////////////////////////////////////////////////////////


protocol TrackableAttributes {
  var name: String { get }
  var details: [String: AnyObject] { get }
}


extension TrackableAttributes where Self: CustomStringConvertible {
  var description: String {
    return "{\n  name: \(name),\n  details: \(details)\n}"
  }

  var attributes: [String: AnyObject] {
    var attributes = details
    attributes["name"] = name
    attributes[TrackableKey.categoryTitle] = nil
    attributes[TrackableKey.videoTitle] = nil
    return attributes
  }
}


struct PageView: TrackableAttributes, CustomStringConvertible {
  let name: String
  let details: [String: AnyObject]

  init(name: String, details: [String: AnyObject] = [:]) {
    self.name = name
    self.details = details
  }
}


struct Event: TrackableAttributes, CustomStringConvertible {
  let name: String
  let details: [String: AnyObject]
}

////////////////////////////////////////////////////////////////////////////////


struct TrackableKey {
  static let numberOfItems = "number_of_items"
  static let categoryID = "category_id"
  static let categoryTitle = "category_title"
  static let videoID = "video_id"
  static let videoTitle = "video_title"
  static let page = "page"
  static let currentTime = "current_time"
  static let duration = "duration"
  static let percentage = "percentage"
}
