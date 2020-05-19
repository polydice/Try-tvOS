//
//  Video+PlayerItem.swift
//  iCookTV
//
//  Created by Ben on 30/04/2016.
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

import AVKit
import Foundation

extension Video {

  // MARK: - Private Helpers

  private var titleMetaData: AVMetadataItem {
    let _title = AVMutableMetadataItem()
    _title.key = AVMetadataKey.commonKeyTitle as (NSCopying & NSObjectProtocol)?
    _title.keySpace = .common
    _title.locale = Locale.current
    _title.value = title as (NSCopying & NSObjectProtocol)?
    return _title
  }

  private var descriptionMetaData: AVMetadataItem {
    let _description = AVMutableMetadataItem()
    _description.key = AVMetadataKey.commonKeyDescription as (NSCopying & NSObjectProtocol)?
    _description.keySpace = .common
    _description.locale = Locale.current
    _description.value = (description ?? "")
      .components(separatedBy: CharacterSet.newlines)
      .joined(separator: "") as (NSCopying & NSObjectProtocol)?
    return _description
  }

  // MARK: - Public Methods

  func convertToPlayerItemWithCover(_ image: UIImage?, completion: @escaping (AVPlayerItem?) -> Void) {
    DispatchQueue.global().async {
      guard let source = self.source, let url = URL(string: source) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }

      let playerItem = AVPlayerItem(url: url)
      var metadata = [
        self.titleMetaData,
        self.descriptionMetaData
      ]
      if let cover = image {
        metadata.append(cover.metadataItem)
      }
      playerItem.externalMetadata = metadata

      DispatchQueue.main.async {
        completion(playerItem)
      }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension UIImage {

  static let JPEGLeastCompressionQuality = CGFloat(1)

  var metadataItem: AVMetadataItem {
    let _item = AVMutableMetadataItem()
    _item.key = AVMetadataKey.commonKeyArtwork as (NSCopying & NSObjectProtocol)?
    _item.keySpace = .common
    _item.locale = Locale.current
    _item.value = jpegData(compressionQuality: UIImage.JPEGLeastCompressionQuality) as (NSCopying & NSObjectProtocol)?
    return _item
  }

}
