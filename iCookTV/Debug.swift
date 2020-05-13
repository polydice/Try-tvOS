//
//  Debug.swift
//  TryTVOS
//
//  Created by Ben on 21/04/2016.
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


struct Debug {

  private static let dateFormatter: DateFormatter = {
    let _formatter = DateFormatter()
    _formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return _formatter
  }()

  static func print(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
      let prefix = dateFormatter.string(from: Date()) + " \(file.typeName).\(function):[\(line)]"
      let content = items.map { "\($0)" } .joined(separator: separator)
      Swift.print("\(prefix) \(content)", terminator: terminator)
    #endif
  }

}


////////////////////////////////////////////////////////////////////////////////


extension String {

  var typeName: String {
    return lastPathComponent.stringByDeletingPathExtension
  }

  private var lastPathComponent: String {
    return (self as NSString).lastPathComponent
  }

  private var stringByDeletingPathExtension: String {
    return (self as NSString).deletingPathExtension
  }

}
