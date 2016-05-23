//
//  VideoPlayerController.swift
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

import UIKit
import AVKit
import Alamofire
import Freddy

class VideoPlayerController: AVPlayerViewController, Trackable {

  private var video: Video?
  private var coverImage: UIImage?

  /// An activity indicator displayed before the player item is ready.
  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let _indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    _indicator.hidesWhenStopped = true
    return _indicator
  }()

  private let playerItemNotifications = [
    AVPlayerItemDidPlayToEndTimeNotification
  ]

  // MARK: - Initialization

  convenience init(video: Video, coverImage image: UIImage? = nil) {
    self.init(nibName: nil, bundle: nil)
    self.video = video
    self.coverImage = image
  }

  deinit {
    for notification in playerItemNotifications {
      NSNotificationCenter.defaultCenter().removeObserver(self, name: notification, object: nil)
    }
  }

  // MARK: - UIViewController

  override func loadView() {
    super.loadView()
    if let contentView = contentOverlayView {
      contentView.addSubview(loadingIndicator)
      loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
      // AVPlayerViewController's own indicator has a 5 pt offset from the center.
      loadingIndicator.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor, constant: -5).active = true
      loadingIndicator.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    loadingIndicator.startAnimating()

    guard let id = video?.id else {
      setPlayerItem(nil)
      return
    }

    let url = iCookTVKeys.baseAPIURL + "videos/\(id).json"
    Alamofire.request(.GET, url).responseJSON { [weak self] response in
      guard let data = response.data where response.result.error == nil else {
        self?.setPlayerItem(nil)
        Tracker.track(response.result.error)
        return
      }

      do {
        let json = try JSON(data: data)
        let video = try Video(json: json["data"] ?? nil)
        video.convertToPlayerItemWithCover(self?.coverImage) { [weak self] in
          self?.setPlayerItem($0)
        }
      } catch {
        Tracker.track(error)
        self?.setPlayerItem(nil)
      }
    }
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    player?.pause()

    if let playerItem = player?.currentItem {
      let duration: NSTimeInterval = CMTimeGetSeconds(playerItem.duration)
      let currentTime: NSTimeInterval = CMTimeGetSeconds(playerItem.currentTime())
      let fraction = currentTime / duration

      Tracker.track(Event(name: "Played Video", details: [
        TrackableKey.videoID: video?.id ?? "",
        TrackableKey.videoTitle: video?.title ?? "",
        TrackableKey.currentTime: currentTime,
        TrackableKey.duration: duration,
        TrackableKey.percentage: fraction * 100
      ]))
    }
  }

  // MARK: - Trackable

  var pageView: PageView? {
    return PageView(name: "Player", details: [
      TrackableKey.videoID: video?.id ?? "",
      TrackableKey.videoTitle: video?.title ?? ""
    ])
  }

  // MARK: - NSNotification Callbacks

  @objc private func handlePlayerItemNotification(notification: NSNotification) {
    switch notification.name {
    case AVPlayerItemDidPlayToEndTimeNotification:
      dismiss()
    default:
      break
    }
  }

  // MARK: - Private Methods

  private func dismiss() {
    if let navigation = navigationController {
      navigation.popViewControllerAnimated(true)
    } else if let presenter = presentingViewController {
      presenter.dismissViewControllerAnimated(true, completion: nil)
    }
  }

  private func setPlayerItem(playerItem: AVPlayerItem?) {
    loadingIndicator.stopAnimating()

    guard let playerItem = playerItem else {
      let message = "There's something wrong with this video.".localizedString + "\n" +
                    "Contact hi@icook.tw for support.".localizedString
      let alert = UIAlertController(title: "Error\n".localizedString, message: message, preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK".localizedString, style: .Default) { [weak self] _ in
        self?.dismiss()
      })
      presentViewController(alert, animated: true, completion: nil)
      return
    }

    for notification in playerItemNotifications {
      NSNotificationCenter.defaultCenter().addObserver(
        self,
        selector: .handlePlayerItemNotification,
        name: notification,
        object: playerItem
      )
    }

    player = AVPlayer(playerItem: playerItem)
    player?.play()
  }

}


////////////////////////////////////////////////////////////////////////////////


private extension Selector {
  static let handlePlayerItemNotification = #selector(VideoPlayerController.handlePlayerItemNotification(_:))
}
