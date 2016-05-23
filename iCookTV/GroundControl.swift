//
//  GroundControl.swift
//  iCookTV
//
//  Created by Ben on 28/04/2016.
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
import Alamofire

struct GroundControl {

  enum VideoSource {
    case HLS ,YouTube
  }

  /// Returns the URL of default background image URL.
  static var defaultBackgroundURL: NSURL? {
    if let url = NSUserDefaults.standardUserDefaults().stringForKey(Keys.DefaultBackgroundURL) {
      return NSURL(string: url)
    } else {
      return nil
    }
  }

  /// Returns the preferred video source.
  static var videoSource: VideoSource {
    if NSUserDefaults.standardUserDefaults().stringForKey(Keys.VideoSource) == "youtube" {
      return .YouTube
    } else {
      return .HLS
    }
  }

  // MARK: - Private Constants

  private struct Keys {
    static let DefaultBackgroundURL = "default-background-url"
    static let VideoSource = "video-source"
  }

  private static let groundControlURL = "https://polydice.com/iCook-tvOS/ground-control.json"

  // MARK: - Public Methods

  static func sync() {
    Alamofire.request(.GET, groundControlURL).responseJSON { response in
      guard let results = response.result.value as? NSDictionary where response.result.error == nil else {
        return
      }
      Debug.print(results)
      for key in [Keys.DefaultBackgroundURL, Keys.VideoSource] {
        NSUserDefaults.standardUserDefaults().setObject(results[key], forKey: key)
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }

}
