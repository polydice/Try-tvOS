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
    case hls, youTube
  }

  /// Returns the URL of default background image URL.
  static var defaultBackgroundURL: URL? {
    if let url = UserDefaults.standard.string(forKey: Keys.DefaultBackgroundURL) {
      return URL(string: url)
    } else {
      return nil
    }
  }

  /// Returns the preferred video source.
  static var videoSource: VideoSource {
    if UserDefaults.standard.string(forKey: Keys.VideoSource) == "youtube" {
      return .youTube
    } else {
      return .hls
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
    Alamofire.request(groundControlURL, method: .get).responseJSON { response in
      guard let results = response.result.value as? NSDictionary, response.result.error == nil else {
        return
      }
      Debug.print(results)
      for key in [Keys.DefaultBackgroundURL, Keys.VideoSource] {
        UserDefaults.standard.set(results[key], forKey: key)
      }
      UserDefaults.standard.synchronize()
    }
  }

}
