//
//  HistoryManager.swift
//  TryTVOS
//
//  Created by Ben on 20/04/2016.
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

struct HistoryManager {

  // MARK: - Private Properties

  private static var cache: NSURL? {
    guard
      let directory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first,
      let url = NSURL(string: directory)
    else {
      return nil
    }
    return url.URLByAppendingPathComponent("history.dat")
  }

  private static let savingQueue = dispatch_queue_create("io.github.bcylin.savingQueue", DISPATCH_QUEUE_SERIAL)

  // MARK: - Public Methods

  /// Returns the deserialized video history read from the cache directory.
  static var history: [JSON] {
    if let path = cache?.path, let records = NSArray(contentsOfFile: path) as? [NSData] {
      do {
        return try records.map { try JSON(data: $0) }
      } catch {
        Tracker.track(error)
        return [JSON]()
      }
    } else {
      return [JSON]()
    }
  }

  /**
   Converts the video to JSON and saves an array of serialized video history to the cache directory in the background.

   - parameter video: A video object.
   */
  static func save(video video: Video) {
    dispatch_async(savingQueue) {
      guard let path = self.cache?.path else {
        return
      }
      Debug.print(path)

      let json = video.toJSON()
      var records = history

      // Keep the latest video at top.
      for (index, element) in self.history.enumerate() {
        if element["id"] == json["id"] {
          records.removeAtIndex(index)
          break
        }
      }
      records.insert(json, atIndex: 0)
      Debug.print("records.count =", records.count)

      do {
        let data = try records.map { try $0.serialize() } as NSArray
        data.writeToFile(path, atomically: true)
      } catch {
        Tracker.track(error)
      }
    }
  }

  /**
   Deletes the video history in the background.

   - parameter completion: A completion block that's called in the main thread when the action finishes.
   */
  static func deleteCache(completion: ((success: Bool) -> Void)? = nil) {
    if let path = cache?.path {
      dispatch_async(savingQueue) {
        do {
          try NSFileManager.defaultManager().removeItemAtPath(path)
          dispatch_async(dispatch_get_main_queue()) {
            completion?(success: true)
          }
        } catch {
          Tracker.track(error)
          dispatch_async(dispatch_get_main_queue()) {
            completion?(success: false)
          }
        }
      }
    }
  }

}
