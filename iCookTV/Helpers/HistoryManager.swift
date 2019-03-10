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

  private static var cache: URL? {
    guard let
      directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
      let url = URL(string: directory)
    else {
      return nil
    }
    return url.appendingPathComponent("history.dat")
  }

  private static let savingQueue = DispatchQueue(label: "io.github.bcylin.savingQueue", attributes: [])

  // MARK: - Public Methods

  /// Returns the deserialized video history read from the cache directory.
  static var history: [JSON] {
    if let path = cache?.path, let records = NSArray(contentsOfFile: path) as? [Data] {
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
  static func save(video: Video) {
    savingQueue.async {
      guard let path = self.cache?.path else {
        return
      }
      Debug.print(path)

      let json = video.toJSON()
      var records = history

      // Keep the latest video at top.
      if let index = self.history.firstIndex(where: { $0["id"] == json["id"] }) {
        records.remove(at: index)
      }
      records.insert(json, at: 0)
      Debug.print("records.count =", records.count)

      do {
        let data = try records.map { try $0.serialize() } as NSArray
        data.write(toFile: path, atomically: true)
      } catch {
        Tracker.track(error)
      }
    }
  }

  /**
   Deletes the video history in the background.

   - parameter completion: A completion block that's called in the main thread when the action finishes.
   */
  static func deleteCache(_ completion: ((_ success: Bool) -> Void)? = nil) {
    if let path = cache?.path {
      savingQueue.async {
        do {
          try FileManager.default.removeItem(atPath: path)
          DispatchQueue.main.async {
            completion?(true)
          }
        } catch {
          Tracker.track(error)
          DispatchQueue.main.async {
            completion?(false)
          }
        }
      }
    }
  }

}
