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
import HCYoutubeParser

extension Video {

  // MARK: - Private Helpers

  private var playerItemURL: NSURL? {
    switch GroundControl.videoSource {
    case .HLS:
      return source == nil ? nil : NSURL(string: source!)
    case .YouTube:
      guard
        let youtubeURL = NSURL(string: youtube),
        let videoURL = HCYoutubeParser.h264videosWithYoutubeURL(youtubeURL)?["hd720"] as? String
      else {
        return nil
      }
      return NSURL(string: videoURL)
    }
  }

  private var titleMetaData: AVMetadataItem {
    let _title = AVMutableMetadataItem()
    _title.key = AVMetadataCommonKeyTitle
    _title.keySpace = AVMetadataKeySpaceCommon
    _title.locale = NSLocale.currentLocale()
    _title.value = title
    return _title
  }

  private var descriptionMetaData: AVMetadataItem {
    let _description = AVMutableMetadataItem()
    _description.key = AVMetadataCommonKeyDescription
    _description.keySpace = AVMetadataKeySpaceCommon
    _description.locale = NSLocale.currentLocale()
    _description.value = (description ?? "")
      .componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
      .joinWithSeparator("")
    return _description
  }

  // MARK: - Public Methods

  func convertToPlayerItemWithCover(image: UIImage?, completion: (AVPlayerItem?) -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      guard let url = self.playerItemURL else {
        dispatch_async(dispatch_get_main_queue()) {
          completion(nil)
        }
        return
      }

      let playerItem = AVPlayerItem(URL: url)
      var metadata = [
        self.titleMetaData,
        self.descriptionMetaData
      ]
      if let cover = image {
        metadata.append(cover.metadataItem)
      }
      playerItem.externalMetadata = metadata

      dispatch_async(dispatch_get_main_queue()) {
        completion(playerItem)
      }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension UIImage {

  private static let JPEGLeastCompressionQuality = CGFloat(1)

  private var metadataItem: AVMetadataItem {
    let _item = AVMutableMetadataItem()
    _item.key = AVMetadataCommonKeyArtwork
    _item.keySpace = AVMetadataKeySpaceCommon
    _item.locale = NSLocale.currentLocale()
    _item.value = UIImageJPEGRepresentation(self, UIImage.JPEGLeastCompressionQuality)
    return _item
  }

}
